open! Core
open Virtual_dom

let render ~current_route =
  ignore current_route;
  Vdom.Node.div
    [Vdom.Node.div
      [Vdom.Node.a ~attrs:[
         Vdom.Attr.href "/";
         Vdom.Attr.create "data-nav-link" "true"
       ] [Vdom.Node.text "Home"];
       Vdom.Node.a ~attrs:[
         Vdom.Attr.href "/about";
         Vdom.Attr.create "data-nav-link" "true"
       ] [Vdom.Node.text "About"];
       Vdom.Node.a ~attrs:[
         Vdom.Attr.href "/projects";
         Vdom.Attr.create "data-nav-link" "true"
       ] [Vdom.Node.text "Projects"];
       Vdom.Node.a ~attrs:[
         Vdom.Attr.href "/words";
         Vdom.Attr.create "data-nav-link" "true"
       ] [Vdom.Node.text "Words"];
       Vdom.Node.a ~attrs:[
         Vdom.Attr.href "/contact";
         Vdom.Attr.create "data-nav-link" "true"
       ] [Vdom.Node.text "Contact"];
      ]]