open! Core
open Virtual_dom

let component () =
  Bonsai.const (
    Vdom.Node.div
      [Vdom.Node.h1 [Vdom.Node.text "Contact"]; 
       Vdom.Node.p [Vdom.Node.text "Get in touch with me."]]
  )