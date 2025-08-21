open! Core
open Virtual_dom

let component () =
  Bonsai.const (
    Vdom.Node.div
      [Vdom.Node.h1 [Vdom.Node.text "Projects"]; 
       Vdom.Node.p [Vdom.Node.text "My OCaml projects will be listed here."]]
  )