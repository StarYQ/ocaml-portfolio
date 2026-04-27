open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom
open Shared.Types

module Styles = Navigation_styles.Styles

let sun_icon attrs =
  Vdom.Node.create_svg
    "svg"
    ~attrs:
      (attrs
       @ [ Vdom.Attr.create "viewBox" "0 0 24 24"
         ; Vdom.Attr.create "fill" "none"
         ; Vdom.Attr.create "stroke" "currentColor"
         ; Vdom.Attr.create "stroke-width" "1.5"
         ; Vdom.Attr.create "aria-hidden" "true"
         ])
    [ Vdom.Node.create_svg
        "circle"
        ~attrs:
          [ Vdom.Attr.create "cx" "12"
          ; Vdom.Attr.create "cy" "12"
          ; Vdom.Attr.create "r" "4"
          ]
        []
    ; Vdom.Node.create_svg
        "path"
        ~attrs:
          [ Vdom.Attr.create
              "d"
              "M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41"
          ]
        []
    ]

let moon_icon attrs =
  Vdom.Node.create_svg
    "svg"
    ~attrs:
      (attrs
       @ [ Vdom.Attr.create "viewBox" "0 0 24 24"
         ; Vdom.Attr.create "fill" "none"
         ; Vdom.Attr.create "stroke" "currentColor"
         ; Vdom.Attr.create "stroke-width" "1.5"
         ; Vdom.Attr.create "aria-hidden" "true"
         ])
    [ Vdom.Node.create_svg
        "path"
        ~attrs:
          [ Vdom.Attr.create "d" "M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" ]
        []
    ]

let info_icon attrs =
  Vdom.Node.create_svg
    "svg"
    ~attrs:
      (attrs
       @ [ Vdom.Attr.create "viewBox" "0 0 24 24"
         ; Vdom.Attr.create "fill" "none"
         ; Vdom.Attr.create "stroke" "currentColor"
         ; Vdom.Attr.create "stroke-width" "1.5"
         ; Vdom.Attr.create "aria-hidden" "true"
         ])
    [ Vdom.Node.create_svg
        "circle"
        ~attrs:
          [ Vdom.Attr.create "cx" "12"
          ; Vdom.Attr.create "cy" "12"
          ; Vdom.Attr.create "r" "9"
          ]
        []
    ; Vdom.Node.create_svg
        "path"
        ~attrs:
          [ Vdom.Attr.create "d" "M12 16v-4M12 8h.01"
          ; Vdom.Attr.create "stroke-linecap" "round"
          ]
        []
    ]

let arrow_icon attrs =
  Vdom.Node.create_svg
    "svg"
    ~attrs:
      (attrs
       @ [ Vdom.Attr.create "viewBox" "0 0 24 24"
         ; Vdom.Attr.create "fill" "none"
         ; Vdom.Attr.create "stroke" "currentColor"
         ; Vdom.Attr.create "stroke-width" "1.5"
         ; Vdom.Attr.create "aria-hidden" "true"
         ])
    [ Vdom.Node.create_svg
        "path"
        ~attrs:
          [ Vdom.Attr.create "d" "M5 12h14m-4-4l4 4-4 4"
          ; Vdom.Attr.create "stroke-linecap" "round"
          ; Vdom.Attr.create "stroke-linejoin" "round"
          ]
        []
    ]

let toggle_theme ~theme ~set_theme =
  let new_theme = Theme.toggle theme in
  let open Js_of_ocaml in
  let body = Dom_html.document##.body in
  let root = Dom_html.document##.documentElement in
  let remove_classes class_list =
    List.iter Theme.class_names ~f:(fun class_name ->
      class_list##remove (Js.string class_name))
  in
  remove_classes body##.classList;
  remove_classes root##.classList;
  body##.classList##add (Js.string (Theme.to_class_name new_theme));
  root##.classList##add (Js.string (Theme.to_class_name new_theme));
  Theme.store_theme new_theme;
  set_theme new_theme

let component ~theme ~set_theme =
  let%sub current_route = Router.create_route_state () in
  let%arr theme = theme
  and set_theme = set_theme
  and current_route = current_route in
  let
    ( slider_class
    , left_foreground_class
    , center_foreground_class
    , right_foreground_class )
    =
    match theme with
    | Theme.Light ->
      ( Styles.theme_slider_light
      , Styles.theme_icon_inverted
      , Styles.theme_logo_muted
      , Styles.theme_icon_default )
    | Theme.Sunset ->
      ( Styles.theme_slider_sunset
      , Styles.theme_icon_default
      , Styles.theme_logo_active
      , Styles.theme_icon_default )
    | Theme.Dark ->
      ( Styles.theme_slider_dark
      , Styles.theme_icon_default
      , Styles.theme_logo_muted
      , Styles.theme_icon_inverted )
  in
  let logo_src = Router.get_base_path () ^ "/static/ocaml-logo.svg" in
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
        [ Vdom.Node.div
            ~attrs:[ Styles.nav_left ]
            [ Nav_link.create'
                ~route:Home
                ~attrs:[ Styles.nav_brand ]
                [ Vdom.Node.text "ARNAB BHOWMIK" ]
            ; Vdom.Node.div
                ~attrs:[ Styles.ocaml_badge_group ]
                [ Vdom.Node.div
                    ~attrs:
                      [ Styles.ocaml_badge_trigger
                      ; Vdom.Attr.create "role" "note"
                      ; Vdom.Attr.create "aria-label" "This site was written entirely in OCaml."
                      ]
                    [ info_icon [ Styles.ocaml_badge_icon ] ]
                ; Vdom.Node.div
                    ~attrs:[ Styles.ocaml_popover_shell ]
                    [ Vdom.Node.div
                        ~attrs:[ Styles.ocaml_popover ]
                        [ Vdom.Node.div
                            ~attrs:[ Styles.ocaml_popover_row ]
                            [ Vdom.Node.create "img"
                                ~attrs:
                                  [ Styles.ocaml_logo
                                  ; Vdom.Attr.src logo_src
                                  ; Vdom.Attr.alt "OCaml"
                                  ]
                                []
                            ; Vdom.Node.p
                                ~attrs:[ Styles.ocaml_popover_text ]
                                [ Vdom.Node.text "This site was written entirely in OCaml." ]
                            ]
                        ; Vdom.Node.a
                            ~attrs:
                              [ Styles.ocaml_link
                              ; Vdom.Attr.href "https://ocaml.org"
                              ; Vdom.Attr.target "_blank"
                              ; Vdom.Attr.create "rel" "noopener noreferrer"
                              ]
                            [ Vdom.Node.text "Learn more about OCaml"
                            ; arrow_icon [ Styles.ocaml_link_arrow ]
                            ]
                        ]
                    ]
                ]
            ]
        ; Vdom.Node.div
            ~attrs:[ Styles.nav_actions ]
            [ Vdom.Node.div
                ~attrs:[ Styles.nav_menu ]
                [ nav_item Styles.nav_link Home "INDEX"
                ; nav_item Styles.nav_link Work "WORK"
                ; nav_item Styles.nav_link Projects "PROJECTS"
                ; nav_item Styles.nav_link About "ABOUT"
                ; nav_item Styles.nav_link Resume "RESUME"
                ; nav_item Styles.nav_link Me "ME"
                ]
            ; Vdom.Node.button
                ~attrs:
                  [ Styles.theme_toggle
                  ; Vdom.Attr.on_click (fun _ -> toggle_theme ~theme ~set_theme)
                  ; Vdom.Attr.create "type" "button"
                  ; Vdom.Attr.create
                      "aria-label"
                      ("Cycle theme. Current theme: " ^ Theme.to_string theme)
                  ]
                [ sun_icon [ Styles.theme_icon_background; Styles.theme_icon_left ]
                ; Vdom.Node.create "img"
                    ~attrs:
                      [ Styles.theme_logo_background
                      ; Styles.theme_icon_center
                      ; Styles.theme_logo_muted
                      ; Vdom.Attr.src logo_src
                      ; Vdom.Attr.alt ""
                      ; Vdom.Attr.create "aria-hidden" "true"
                      ]
                    []
                ; moon_icon [ Styles.theme_icon_background; Styles.theme_icon_right ]
                ; Vdom.Node.div ~attrs:[ Styles.theme_slider; slider_class ] []
                ; sun_icon
                    [ Styles.theme_icon_foreground
                    ; Styles.theme_icon_left
                    ; left_foreground_class
                    ]
                ; Vdom.Node.create "img"
                    ~attrs:
                      [ Styles.theme_logo_foreground
                      ; Styles.theme_icon_center
                      ; center_foreground_class
                      ; Vdom.Attr.src logo_src
                      ; Vdom.Attr.alt ""
                      ; Vdom.Attr.create "aria-hidden" "true"
                      ]
                    []
                ; moon_icon
                    [ Styles.theme_icon_foreground
                    ; Styles.theme_icon_right
                    ; right_foreground_class
                    ]
                ]
            ]
        ]
    ; Vdom.Node.div
        ~attrs:[ Styles.mobile_row ]
        [ nav_item Styles.mobile_nav_link Home "INDEX"
        ; nav_item Styles.mobile_nav_link Work "WORK"
        ; nav_item Styles.mobile_nav_link Projects "PROJECTS"
        ; nav_item Styles.mobile_nav_link About "ABOUT"
        ; nav_item Styles.mobile_nav_link Resume "RESUME"
        ; nav_item Styles.mobile_nav_link Me "ME"
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
            ; nav_item Styles.nav_link Resume "RESUME"
            ; nav_item Styles.nav_link Me "ME"
            ]
        ]
    ; Vdom.Node.div
        ~attrs:[ Styles.mobile_row ]
        [ nav_item Styles.mobile_nav_link Home "INDEX"
        ; nav_item Styles.mobile_nav_link Work "WORK"
        ; nav_item Styles.mobile_nav_link Projects "PROJECTS"
        ; nav_item Styles.mobile_nav_link About "ABOUT"
        ; nav_item Styles.mobile_nav_link Resume "RESUME"
        ; nav_item Styles.mobile_nav_link Me "ME"
        ]
    ]
