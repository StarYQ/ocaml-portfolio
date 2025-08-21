open Core
open Bonsai_web
open Shared.Types

(* This is adapted from Jane Street's bonsai_web_components nav_link *)
(* Original source: https://github.com/janestreet/bonsai_web_components/tree/master/nav_link *)

let make' ?(attrs = []) ~set_url ~page_to_string page children =
  let attrs =
    attrs
    @ [ Vdom.Attr.href (page_to_string page)
      ; Vdom.Attr.on_click (fun event ->
          if List.exists
               [ event##.ctrlKey; event##.shiftKey; event##.altKey; event##.metaKey ]
               ~f:Js_of_ocaml.Js.to_bool
          then
            (* If any modifier key is pressed, let the browser handle it as a normal
               <a>: Ctrl-Click opens in a new tab, etc *)
            Effect.Ignore
          else
            (* Otherwise perform an on-page navigation. *)
            Effect.Many [ set_url page; Effect.Prevent_default ])
      ]
  in
  Vdom.Node.a ~attrs children
;;

let make ?attrs ~set_url ~page_to_string page text =
  make' ?attrs ~set_url ~page_to_string page [ Vdom.Node.text text ]
;;

(* Convenience functions that use our router *)
let create ?attrs ~route ~text () =
  make 
    ?attrs 
    ~set_url:Router.navigate_to_route 
    ~page_to_string:route_to_string 
    route 
    text
;;

let create' ?attrs ~route children =
  make' 
    ?attrs 
    ~set_url:Router.navigate_to_route 
    ~page_to_string:route_to_string 
    route 
    children
;;