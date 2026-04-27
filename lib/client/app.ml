open! Core
open Bonsai.Let_syntax
open Shared.Types
open Bonsai_web
module Nav_styles = Components.Navigation_styles.Styles
module Theme_styles = Styles.Theme_styles.Styles

let apply_theme_to_body theme =
  let open Js_of_ocaml in
  let body = Dom_html.document##.body in
  let root = Dom_html.document##.documentElement in
  let remove_classes class_list =
    List.iter Theme.class_names ~f:(fun class_name ->
      class_list##remove (Js.string class_name))
  in
  remove_classes body##.classList;
  remove_classes root##.classList;
  body##.classList##add (Js.string (Theme.to_class_name theme));
  root##.classList##add (Js.string (Theme.to_class_name theme))

let app_computation =
  (* Initialize theme state with proper state management *)
  let initial = Theme.initial_theme () in
  (* Apply initial theme to body immediately *)
  apply_theme_to_body initial;
  let%sub theme, set_theme = Bonsai.state (module Theme) ~default_model:initial in
  
  (* Create app with theme-aware navigation *)
  let%sub current_route = Components.Router.create_route_state () in
  
  (* Use the navigation_simple component with mobile support *)
  let%sub navigation = Components.Navigation.component ~theme ~set_theme in
  
  (* Render page content based on the current route with theme *)
  let%sub content = 
    match%sub current_route with
    | Home -> Pages.Page_home.component ~theme ()
    | Work -> Pages.Page_work.component ~theme ()
    | About -> Pages.Page_about.component ~theme ()
    | Me -> Pages.Page_me.component ~theme ()
    | Projects -> Pages.Page_projects.component ~theme ()
    | Project_detail slug -> Pages.Page_project_detail.component ~theme ~slug ()
    | Resume -> Pages.Page_resume.component ~theme ()
  in
  
  let%arr content = content 
  and navigation = navigation in
  Components.Layout.render 
    ~navigation
    ~content

let run () =
  Bonsai_web.Start.start
    ~bind_to_element_with_id:"app"
    app_computation
