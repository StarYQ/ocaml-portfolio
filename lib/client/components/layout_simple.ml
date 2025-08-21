open! Core
open Virtual_dom

let render ~navigation ~content =
  Vdom.Node.div
    [navigation; content]