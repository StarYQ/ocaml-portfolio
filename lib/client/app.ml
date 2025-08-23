open! Core
open Bonsai.Let_syntax
open Shared.Types
open Bonsai_web
module Nav_styles = Components.Navigation_styles.Styles

let app_computation =
  (* Initialize theme state with proper state management *)
  let%sub theme, set_theme = Bonsai.state (module Theme) ~default_model:(Theme.initial_theme ()) in
  
  
  (* Create app with theme-aware navigation *)
  let%sub current_route = Components.Router.create_route_state () in
  
  (* Create navigation with theme state *)
  let%sub navigation = 
    let%arr theme = theme 
    and set_theme = set_theme in
    let toggle_button = 
      Vdom.Node.button
        ~attrs:[
          Nav_styles.theme_toggle;
          Vdom.Attr.on_click (fun _ ->
            let new_theme = Theme.toggle theme in
            (* Update document class immediately *)
            let open Js_of_ocaml in
            Dom_html.document##.body##.className := 
              Js.string (Theme.to_class_name new_theme);
            Theme.store_theme new_theme;
            set_theme new_theme);
          Vdom.Attr.create "aria-label" 
            (match theme with
             | Theme.Light -> "Switch to dark mode"
             | Theme.Dark -> "Switch to light mode")
        ]
        [
          Vdom.Node.span
            ~attrs:[Nav_styles.theme_icon]
            [Vdom.Node.text 
              (match theme with
               | Theme.Light -> "🌙"
               | Theme.Dark -> "☀️")]
        ]
    in
    (* Return navigation with theme toggle *)
    Vdom.Node.create "nav"
      ~attrs:[Nav_styles.navbar]
      [
        Vdom.Node.div
          ~attrs:[Nav_styles.nav_container]
          [
            Components.Nav_link.create' 
              ~route:Home 
              ~attrs:[Nav_styles.nav_brand]
              [Vdom.Node.text "Portfolio"];
            
            Vdom.Node.div
              ~attrs:[Nav_styles.nav_menu]
              [
                Components.Nav_link.create' ~route:Home ~attrs:[Nav_styles.nav_link] [Vdom.Node.text "Home"];
                Components.Nav_link.create' ~route:About ~attrs:[Nav_styles.nav_link] [Vdom.Node.text "About"];
                Components.Nav_link.create' ~route:Projects ~attrs:[Nav_styles.nav_link] [Vdom.Node.text "Projects"];
                Components.Nav_link.create' ~route:Words ~attrs:[Nav_styles.nav_link] [Vdom.Node.text "Words"];
                Components.Nav_link.create' ~route:Contact ~attrs:[Nav_styles.nav_link] [Vdom.Node.text "Contact"];
                toggle_button
              ]
          ]
      ]
  in
  
  (* Render page content based on the current route *)
  let%sub content = 
    match%sub current_route with
    | Home -> Pages.Page_home.component ()
    | About -> Pages.Page_about.component ()
    | Projects -> Pages.Page_projects.component ()
    | Words -> Pages.Page_words.component ()
    | Contact -> Pages.Page_contact.component ()
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