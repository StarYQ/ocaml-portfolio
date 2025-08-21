open! Core
open Virtual_dom

let component () =
  Bonsai.const (
    Vdom.Node.div
      [Vdom.Node.h1 [Vdom.Node.text "Home"]; 
       Vdom.Node.p [Vdom.Node.text "Welcome to my OCaml portfolio!"]]
  )