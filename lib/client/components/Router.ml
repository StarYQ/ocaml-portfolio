open! Core
open Bonsai_web
open Shared.Types

(** Module for parsing routes from URLs using Url_var for reactive navigation *)
module Route_parser = struct
  type t = route [@@deriving sexp, equal]
  
  (** Parse a route from URL components *)
  let parse_exn ({ path; _ } : Bonsai_web_ui_url_var.Components.t) : t =
    route_of_string path |> Option.value ~default:Home
    
  (** Convert a route to URL components *)
  let unparse (route : t) : Bonsai_web_ui_url_var.Components.t =
    Bonsai_web_ui_url_var.Components.create ~path:(route_to_string route) ()
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