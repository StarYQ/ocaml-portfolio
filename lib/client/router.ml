open! Core
open Bonsai.Let_syntax
open Shared.Types
open Virtual_dom
open Js_of_ocaml

(* Module for route state *)
module Route_model = struct
  type t = route [@@deriving sexp, equal]
end

(* Global mutable reference for the setter *)
let route_setter_ref : (route -> unit Vdom.Effect.t) option ref = ref None

(* Helper to update browser URL without triggering navigation *)
let update_browser_url route =
  let path = route_to_string route in
  let open Js.Unsafe in
  global##.history##pushState Js.null (Js.string "") (Js.string path)

(* Parse route from current URL *)
let parse_current_url () =
  let pathname = 
    Js.to_string Dom_html.window##.location##.pathname 
  in
  match route_of_string pathname with
  | Some route -> route
  | None -> Home

(* Create the route state computation *)
let create_route_state () =
  (* Get initial route from URL *)
  let initial_route = parse_current_url () in
  
  let%sub route, set_route = 
    Bonsai.state (module Route_model) ~default_model:initial_route
  in
  
  (* Create the polling effect *)
  let%sub polling_effect =
    let%arr route = route
    and set_route = set_route in
    (* Store setter globally on each tick *)
    route_setter_ref := Some set_route;
    
    (* Check if URL changed (e.g., from back/forward button) *)
    let current_url_route = parse_current_url () in
    if not (equal_route route current_url_route) then
      set_route current_url_route
    else
      Vdom.Effect.Ignore
  in
  
  (* Poll for URL changes every 100ms to handle browser back/forward *)
  let%sub () = 
    Bonsai.Clock.every
      ~when_to_start_next_effect:`Every_multiple_of_period_blocking
      (Time_ns.Span.of_sec 0.1)
      polling_effect
  in
  
  return route

(* Navigate to a route *)
let navigate_to_route route =
  match !route_setter_ref with
  | Some set_route ->
      Vdom.Effect.Many [
        (* Update the state *)
        set_route route;
        (* Update browser URL *)
        Vdom.Effect.of_sync_fun update_browser_url route;
      ]
  | None ->
      (* Fallback: just update URL if setter not available yet *)
      Vdom.Effect.of_sync_fun update_browser_url route

(* Link component for navigation *)
module Link = struct
  let create ~route ~text ?(attrs = []) () =
    Vdom.Node.a
      ~attrs:(
        (* Include href for accessibility and fallback *)
        Vdom.Attr.href (route_to_string route) ::
        (* Handle click to navigate without page reload *)
        Vdom.Attr.on_click (fun _evt ->
          (* Prevent default browser navigation *)
          Vdom.Effect.Many [
            Vdom.Effect.Prevent_default;
            (* Navigate using our router *)
            navigate_to_route route
          ]
        ) :: attrs
      )
      [Vdom.Node.text text]
end