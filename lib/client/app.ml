open! Core
open Bonsai.Let_syntax
open Shared.Types

let app_computation =
  (* Get the route state from the router *)
  let%sub current_route = Components.Router.create_route_state () in
  
  (* Render page content based on the current route *)
  let%sub content = 
    match%sub current_route with
    | Home -> Pages.Page_home.component ()
    | About -> Pages.Page_about.component ()
    | Projects -> Pages.Page_projects.component ()
    | Words -> Pages.Page_words.component ()
    | Contact -> Pages.Page_contact.component ()
  in
  
  let%arr content = content and route = current_route in
  Components.Layout.render 
    ~navigation:(Components.Navigation.render ~current_route:route)
    ~content

let run () =
  Bonsai_web.Start.start
    ~bind_to_element_with_id:"app"
    app_computation