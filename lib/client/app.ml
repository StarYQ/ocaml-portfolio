open! Core
open Bonsai.Let_syntax
open Shared.Types
open Bonsai_web
module Nav_styles = Components.Navigation_styles.Styles
module Theme_styles = Styles.Theme_styles.Styles

let apply_theme_to_body theme =
  let open Js_of_ocaml in
  let body = Dom_html.document##.body in
  let class_list = body##.classList in
  (* Remove both classes first *)
  class_list##remove (Js.string "light-theme");
  class_list##remove (Js.string "dark-theme");
  (* Add the appropriate class *)
  class_list##add (Js.string (Theme.to_class_name theme))

let app_computation =
  (* Initialize theme state with proper state management *)
  let initial = Theme.initial_theme () in
  (* Apply initial theme to body immediately *)
  apply_theme_to_body initial;
  let%sub theme, set_theme = Bonsai.state (module Theme) ~default_model:initial in
  
  
  (* Create app with theme-aware navigation *)
  let%sub current_route = Components.Router.create_route_state () in
  
  (* Create navigation with theme state *)
  let%sub navigation = 
    let%arr theme = theme 
    and set_theme = set_theme in
    let toggle_button = 
      Vdom.Node.div
        ~attrs:[
          (match theme with
           | Theme.Light -> Nav_styles.theme_toggle
           | Theme.Dark -> Vdom.Attr.many [Nav_styles.theme_toggle; Nav_styles.dark]);
          Vdom.Attr.on_click (fun _ ->
            let new_theme = Theme.toggle theme in
            (* Apply theme to body *)
            apply_theme_to_body new_theme;
            (* Store in localStorage *)
            Theme.store_theme new_theme;
            (* Update state *)
            set_theme new_theme);
          Vdom.Attr.create "role" "switch";
          Vdom.Attr.create "aria-checked" 
            (match theme with
             | Theme.Light -> "false"
             | Theme.Dark -> "true");
          Vdom.Attr.create "aria-label" 
            (match theme with
             | Theme.Light -> "Switch to dark mode"
             | Theme.Dark -> "Switch to light mode")
        ]
        [
          (* Sliding knob with icon *)
          Vdom.Node.div
            ~attrs:[Nav_styles.theme_slider]
            [
              Vdom.Node.span
                ~attrs:[Nav_styles.theme_icon]
                [Vdom.Node.text 
                  (match theme with
                   | Theme.Light -> "☀"
                   | Theme.Dark -> "🌙")]
            ]
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
  
  (* Render page content based on the current route with theme *)
  let%sub content = 
    match%sub current_route with
    | Home -> Pages.Page_home.component ~theme ()
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