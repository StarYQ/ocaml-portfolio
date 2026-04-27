open! Core
open Virtual_dom

let create ?(attrs = []) ~href children =
  Vdom.Node.a
    ~attrs:
      (attrs
       @ [ Vdom.Attr.href href ])
    children
;;

let mailto ?attrs address children =
  let href =
    if String.is_prefix address ~prefix:"mailto:" then address else "mailto:" ^ address
  in
  create ?attrs ~href children
;;
