open! Core
open Virtual_dom
open Shared.Types

let render ~current_route =
  let nav_item route text =
    let is_active = Shared.Types.equal_route current_route route in
    let attrs = 
      if is_active then 
        [Vdom.Attr.class_ "active"]
      else 
        []
    in
    (* Using the Jane Street nav_link module we copied *)
    Nav_link.create ~route ~text ~attrs ()
  in
  
  Vdom.Node.create "nav"
    ~attrs:[Vdom.Attr.class_ "main-navigation"]
    [
      nav_item Home "Home";
      nav_item About "About";
      nav_item Projects "Projects";
      nav_item Words "Words";
      nav_item Contact "Contact";
    ]