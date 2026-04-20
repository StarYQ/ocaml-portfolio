open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom
open Shared.Types

module Styles = Navigation_styles.Styles

let toggle_theme ~theme ~set_theme =
  let new_theme = Theme.toggle theme in
  let open Js_of_ocaml in
  let body = Dom_html.document##.body in
  let class_list = body##.classList in
  class_list##remove (Js.string "light-theme");
  class_list##remove (Js.string "dark-theme");
  class_list##add (Js.string (Theme.to_class_name new_theme));
  Theme.store_theme new_theme;
  set_theme new_theme

let component ~theme ~set_theme =
  let%sub current_route = Router.create_route_state () in
  let%arr theme = theme
  and set_theme = set_theme
  and current_route = current_route in
  let nav_item attr route label =
    let attrs =
      if route_matches_nav current_route route
      then [ attr; Styles.active ]
      else [ attr ]
    in
    Nav_link.create' ~route ~attrs [ Vdom.Node.text label ]
  in
  Vdom.Node.create "nav"
    ~attrs:[ Styles.navbar ]
    [ Vdom.Node.div
        ~attrs:[ Styles.nav_container ]
        [ Nav_link.create'
            ~route:Home
            ~attrs:[ Styles.nav_brand ]
            [ Vdom.Node.text "ARNAB BHOWMIK" ]
        ; Vdom.Node.div
            ~attrs:[ Styles.nav_actions ]
            [ Vdom.Node.div
                ~attrs:[ Styles.nav_menu ]
                [ nav_item Styles.nav_link Home "INDEX"
                ; nav_item Styles.nav_link Work "WORK"
                ; nav_item Styles.nav_link Projects "PROJECTS"
                ; nav_item Styles.nav_link About "ABOUT"
                ]
            ; Vdom.Node.button
                ~attrs:
                  [ Styles.theme_toggle
                  ; Vdom.Attr.on_click (fun _ -> toggle_theme ~theme ~set_theme)
                  ; Vdom.Attr.create "type" "button"
                  ; Vdom.Attr.create "aria-label"
                      (match theme with
                       | Theme.Light -> "Switch to dark mode"
                       | Theme.Dark -> "Switch to light mode")
                  ]
                [ Vdom.Node.text
                    (match theme with
                     | Theme.Light -> "DARK"
                     | Theme.Dark -> "LIGHT")
                ]
            ]
        ]
    ; Vdom.Node.div
        ~attrs:[ Styles.mobile_row ]
        [ nav_item Styles.mobile_nav_link Home "INDEX"
        ; nav_item Styles.mobile_nav_link Work "WORK"
        ; nav_item Styles.mobile_nav_link Projects "PROJECTS"
        ; nav_item Styles.mobile_nav_link About "ABOUT"
        ]
    ]

let render ~current_route =
  let nav_item attr route label =
    let attrs =
      if route_matches_nav current_route route
      then [ attr; Styles.active ]
      else [ attr ]
    in
    Nav_link.create' ~route ~attrs [ Vdom.Node.text label ]
  in
  Vdom.Node.create "nav"
    ~attrs:[ Styles.navbar ]
    [ Vdom.Node.div
        ~attrs:[ Styles.nav_container ]
        [ Nav_link.create'
            ~route:Home
            ~attrs:[ Styles.nav_brand ]
            [ Vdom.Node.text "ARNAB BHOWMIK" ]
        ; Vdom.Node.div
            ~attrs:[ Styles.nav_menu ]
            [ nav_item Styles.nav_link Home "INDEX"
            ; nav_item Styles.nav_link Work "WORK"
            ; nav_item Styles.nav_link Projects "PROJECTS"
            ; nav_item Styles.nav_link About "ABOUT"
            ]
        ]
    ; Vdom.Node.div
        ~attrs:[ Styles.mobile_row ]
        [ nav_item Styles.mobile_nav_link Home "INDEX"
        ; nav_item Styles.mobile_nav_link Work "WORK"
        ; nav_item Styles.mobile_nav_link Projects "PROJECTS"
        ; nav_item Styles.mobile_nav_link About "ABOUT"
        ]
    ]
