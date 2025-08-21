open! Core
open Virtual_dom

let component () =
  Bonsai.const (
    Vdom.Node.div
      [Vdom.Node.h1 [Vdom.Node.text "Words"]; 
       Vdom.Node.p [Vdom.Node.text "My articles and blog posts."]]
  )