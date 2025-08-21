open! Core
open Virtual_dom

let component () =
  Bonsai.const (
    Vdom.Node.div
      [Vdom.Node.h1 [Vdom.Node.text "About Me"]; 
       Vdom.Node.p [Vdom.Node.text "I'm a passionate software developer with a strong focus on functional programming and OCaml."]]
  )