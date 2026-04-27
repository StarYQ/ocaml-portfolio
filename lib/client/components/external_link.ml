open! Core
open Bonsai_web
open Virtual_dom

let has_modifier event =
  List.exists
    [ event##.ctrlKey; event##.shiftKey; event##.altKey; event##.metaKey ]
    ~f:Js_of_ocaml.Js.to_bool
;;

let open_href href =
  let open Js_of_ocaml in
  Dom_html.window##.location##assign (Js.string href)
;;

let create ?(attrs = []) ~href children =
  Vdom.Node.a
    ~attrs:
      (attrs
       @ [ Vdom.Attr.href href
         ; Vdom.Attr.on_click (fun event ->
             if has_modifier event
             then Effect.Ignore
             else Effect.Many [ Effect.of_sync_fun open_href href; Effect.Prevent_default ])
         ])
    children
;;

let mailto ?attrs address children =
  let href =
    if String.is_prefix address ~prefix:"mailto:" then address else "mailto:" ^ address
  in
  create ?attrs ~href children
;;
