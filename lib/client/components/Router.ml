open! Core
open Bonsai_web
open Shared.Types

(** Get the base path for the current environment *)
let get_base_path () =
  let open Js_of_ocaml in
  let hostname = 
    Js.to_string (Js.Unsafe.get Dom_html.window##.location (Js.string "hostname"))
  in
  if String.equal hostname "staryq.github.io" then
    "/ocaml-portfolio"
  else
    ""

(** Module for parsing routes from URLs using Url_var for reactive navigation *)
module Route_parser = struct
  type t = route [@@deriving sexp, equal]
  
  (** Parse a route from URL components *)
  let parse_exn ({ path; _ } : Bonsai_web_ui_url_var.Components.t) : t =
    let base_path = get_base_path () in
    (* Remove base path if present *)
    let clean_path = 
      if not (String.equal base_path "") && String.is_prefix path ~prefix:base_path then
        let without_base = String.drop_prefix path (String.length base_path) in
        (* Ensure path starts with / after removing base *)
        if String.is_prefix without_base ~prefix:"/" then
          without_base
        else if String.equal without_base "" then
          "/"
        else
          "/" ^ without_base
      else
        path
    in
    (* Ensure clean_path starts with / *)
    let clean_path = 
      if String.length clean_path > 0 && not (Char.equal (String.get clean_path 0) '/') then
        "/" ^ clean_path
      else if String.length clean_path = 0 then
        "/"
      else
        clean_path
    in
    route_of_string clean_path |> Option.value ~default:Home
    
  (** Convert a route to URL components *)
  let unparse (route : t) : Bonsai_web_ui_url_var.Components.t =
    let base_path = get_base_path () in
    let path = base_path ^ (route_to_string route) in
    Bonsai_web_ui_url_var.Components.create ~path ()
end

(** Global Url_var instance for reactive routing *)
let url_var = lazy (Bonsai_web_ui_url_var.create_exn (module Route_parser) ~fallback:Home)

(** Create the route state computation - reactive, no polling *)
let create_route_state () =
  let url_var = Lazy.force url_var in
  Bonsai.read (Bonsai_web_ui_url_var.value url_var)

(** Navigate to a route - updates URL reactively *)
let navigate_to_route route =
  let url_var = Lazy.force url_var in
  (* Wrap the unit-returning function in an Effect *)
  Effect.of_sync_fun (fun r -> Bonsai_web_ui_url_var.set url_var r) route