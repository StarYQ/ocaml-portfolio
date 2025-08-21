open! Core
open Bonsai.Let_syntax
open Shared.Types
open Virtual_dom

let app_computation =
  (* Get the route state from the router *)
  let%sub current_route = Router.create_route_state () in
  
  (* Render content based on the current route *)
  let%arr route = current_route in
  
  let content = 
    match route with
    | Home -> 
        Vdom.Node.div
          [Vdom.Node.h1 [Vdom.Node.text "Home"]; 
           Vdom.Node.p [Vdom.Node.text "Welcome to my OCaml portfolio!"]]
    | About -> 
        Vdom.Node.div
          [Vdom.Node.h1 [Vdom.Node.text "About Me"]; 
           Vdom.Node.p [Vdom.Node.text "I'm a passionate software developer with a strong focus on functional programming and OCaml."]]
    | Projects -> 
        Vdom.Node.div
          [Vdom.Node.h1 [Vdom.Node.text "Projects"]; 
           Vdom.Node.p [Vdom.Node.text "My OCaml projects will be listed here."]]
    | Words -> 
        Vdom.Node.div
          [Vdom.Node.h1 [Vdom.Node.text "Words"]; 
           Vdom.Node.p [Vdom.Node.text "My thoughts and writings."]]
    | Contact -> 
        Vdom.Node.div
          [Vdom.Node.h1 [Vdom.Node.text "Contact"]; 
           Vdom.Node.p [Vdom.Node.text "Get in touch with me."]]
  in
  
  Components.Layout.render 
    ~navigation:(Components.Navigation.render ~current_route:route)
    ~content

let run () =
  Bonsai_web.Start.start
    ~bind_to_element_with_id:"app"
    app_computation