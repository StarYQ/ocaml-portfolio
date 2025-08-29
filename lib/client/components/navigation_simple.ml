open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom
open Shared.Types

(* Import navigation styles *)
module Styles = Navigation_styles.Styles

let component =
  (* Initialize theme state *)
  let initial_theme = Theme.initial_theme () in
  let%sub theme, set_theme = Bonsai.state (module Theme) ~default_model:initial_theme in
  let%sub menu_open, set_menu_open = Bonsai.state (module Bool) ~default_model:false in
  let%sub current_route = Router.create_route_state () in
  
  let%arr menu_open = menu_open
  and set_menu_open = set_menu_open
  and theme = theme
  and set_theme = set_theme
  and current_route = current_route in
  
  (* Toggle mobile menu *)
  let toggle_menu = 
    Vdom.Attr.on_click (fun _ ->
      set_menu_open (not menu_open))
  in
  
  (* Close menu when clicking overlay *)
  let close_menu = 
    Vdom.Attr.on_click (fun _ ->
      set_menu_open false)
  in
  
  (* Handle theme toggle *)
  let toggle_theme () =
    let new_theme = Theme.toggle theme in
    (* Apply theme to body *)
    let open Js_of_ocaml in
    let body = Dom_html.document##.body in
    let class_list = body##.classList in
    class_list##remove (Js.string "light-theme");
    class_list##remove (Js.string "dark-theme");
    class_list##add (Js.string (Theme.to_class_name new_theme));
    (* Store in localStorage *)
    Theme.store_theme new_theme;
    (* Update state *)
    set_theme new_theme
  in
  
  (* Create nav link with active state *)
  let nav_item route text =
    let is_active = Shared.Types.equal_route current_route route in
    let attrs = 
      if is_active then 
        [Styles.nav_link; Styles.active]
      else 
        [Styles.nav_link]
    in
    Nav_link.create' ~route ~attrs [Vdom.Node.text text]
  in
  
  (* Mobile nav link *)
  let mobile_nav_item route text =
    let is_active = Shared.Types.equal_route current_route route in
    let attrs = 
      if is_active then 
        [
          Styles.mobile_nav_link;
          Styles.active;
          close_menu (* Close menu on navigation *)
        ]
      else 
        [
          Styles.mobile_nav_link;
          close_menu (* Close menu on navigation *)
        ]
    in
    Nav_link.create' ~route ~attrs [Vdom.Node.text text]
  in
  
  (* Create SVG hamburger icon *)
  let hamburger_icon =
    let color = 
      match theme with
      | Theme.Light -> "#1a202c"  (* Dark color in light mode *)
      | Theme.Dark -> "#f7fafc"    (* Light color in dark mode *)
    in
    Vdom.Node.create_svg "svg"
      ~attrs:[
        Vdom.Attr.create "width" "24";
        Vdom.Attr.create "height" "24";
        Vdom.Attr.create "viewBox" "0 0 24 24";
        Vdom.Attr.create "fill" "none";
        Vdom.Attr.create "xmlns" "http://www.w3.org/2000/svg";
        Vdom.Attr.class_ (if menu_open then "hamburger-svg is-open" else "hamburger-svg")
      ]
      [
        (* Top line *)
        Vdom.Node.create_svg "line"
          ~attrs:[
            Vdom.Attr.create "x1" "3";
            Vdom.Attr.create "y1" "6";
            Vdom.Attr.create "x2" "21";
            Vdom.Attr.create "y2" "6";
            Vdom.Attr.create "stroke" color;
            Vdom.Attr.create "stroke-width" "2";
            Vdom.Attr.create "stroke-linecap" "round";
            Vdom.Attr.class_ "hamburger-line-top"
          ]
          [];
        (* Middle line *)
        Vdom.Node.create_svg "line"
          ~attrs:[
            Vdom.Attr.create "x1" "3";
            Vdom.Attr.create "y1" "12";
            Vdom.Attr.create "x2" "21";
            Vdom.Attr.create "y2" "12";
            Vdom.Attr.create "stroke" color;
            Vdom.Attr.create "stroke-width" "2";
            Vdom.Attr.create "stroke-linecap" "round";
            Vdom.Attr.class_ "hamburger-line-middle"
          ]
          [];
        (* Bottom line *)
        Vdom.Node.create_svg "line"
          ~attrs:[
            Vdom.Attr.create "x1" "3";
            Vdom.Attr.create "y1" "18";
            Vdom.Attr.create "x2" "21";
            Vdom.Attr.create "y2" "18";
            Vdom.Attr.create "stroke" color;
            Vdom.Attr.create "stroke-width" "2";
            Vdom.Attr.create "stroke-linecap" "round";
            Vdom.Attr.class_ "hamburger-line-bottom"
          ]
          []
      ]
  in
  
  (* Mobile menu attrs *)
  let mobile_menu_attrs = 
    if menu_open then 
      [Styles.mobile_menu; Styles.is_open]
    else 
      [Styles.mobile_menu]
  in
  
  (* Overlay attrs *)
  let overlay_attrs = 
    if menu_open then 
      [Styles.menu_overlay; Styles.is_open]
    else 
      [Styles.menu_overlay]
  in
  
  Vdom.Node.div
    ~attrs:[]
    [
      (* Main Navigation Bar *)
      Vdom.Node.create "nav"
        ~attrs:[Styles.navbar]
        [
          Vdom.Node.div
            ~attrs:[Styles.nav_container]
            [
              (* Brand/Logo *)
              Nav_link.create' 
                ~route:Home 
                ~attrs:[Styles.nav_brand]
                [Vdom.Node.text "Portfolio"];
              
              (* Desktop Navigation *)
              Vdom.Node.div
                ~attrs:[Styles.nav_menu]
                [
                  nav_item Home "Home";
                  nav_item About "About";
                  nav_item Projects "Projects";
                  nav_item Resume "Resume";
                  
                  (* Desktop Theme Toggle - Sliding Toggle *)
                  Vdom.Node.div
                    ~attrs:[
                      (match theme with
                       | Theme.Light -> Styles.theme_toggle
                       | Theme.Dark -> Vdom.Attr.many [Styles.theme_toggle; Styles.dark]);
                      Vdom.Attr.on_click (fun _ -> toggle_theme ());
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
                        ~attrs:[Styles.theme_slider]
                        [
                          Vdom.Node.span
                            ~attrs:[Styles.theme_icon]
                            [Vdom.Node.text 
                              (match theme with
                               | Theme.Light -> "☀"   (* SUN for light mode *)
                               | Theme.Dark -> "🌙")]  (* MOON for dark mode *)
                        ]
                    ]
                ];
              
              (* Mobile Controls Container *)
              Vdom.Node.div
                ~attrs:[Styles.mobile_controls]
                [
                  (* Mobile Theme Toggle - Sliding Toggle *)
                  Vdom.Node.div
                    ~attrs:[
                      (match theme with
                       | Theme.Light -> Styles.theme_toggle
                       | Theme.Dark -> Vdom.Attr.many [Styles.theme_toggle; Styles.dark]);
                      Vdom.Attr.on_click (fun _ -> toggle_theme ());
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
                        ~attrs:[Styles.theme_slider]
                        [
                          Vdom.Node.span
                            ~attrs:[Styles.theme_icon]
                            [Vdom.Node.text 
                              (match theme with
                               | Theme.Light -> "☀"   (* SUN for light mode *)
                               | Theme.Dark -> "🌙")]  (* MOON for dark mode *)
                        ]
                    ];
                  
                  (* Mobile Menu Toggle *)
                  Vdom.Node.button
                    ~attrs:[
                      Styles.menu_toggle;
                      toggle_menu;
                      Vdom.Attr.create "aria-label" "Toggle menu"
                    ]
                    [hamburger_icon]
                ]
            ]
        ];
      
      (* Mobile Menu Overlay *)
      Vdom.Node.div
        ~attrs:(overlay_attrs @ [close_menu])
        [];
      
      (* Mobile Menu Panel *)
      Vdom.Node.div
        ~attrs:mobile_menu_attrs
        [
          Vdom.Node.div
            ~attrs:[Styles.mobile_nav_items]
            [
              mobile_nav_item Home "Home";
              mobile_nav_item About "About";
              mobile_nav_item Projects "Projects";
              mobile_nav_item Resume "Resume";
            ]
        ]
    ]

(* Backward compatibility wrapper *)
let render ~current_route = 
  (* For now, return a simple version for compatibility *)
  let nav_item route text =
    let is_active = Shared.Types.equal_route current_route route in
    let attrs = 
      if is_active then 
        [Styles.nav_link; Styles.active]
      else 
        [Styles.nav_link]
    in
    Nav_link.create' ~route ~attrs [Vdom.Node.text text]
  in
  
  Vdom.Node.create "nav"
    ~attrs:[Styles.navbar]
    [
      Vdom.Node.div
        ~attrs:[Styles.nav_container]
        [
          Nav_link.create' 
            ~route:Home 
            ~attrs:[Styles.nav_brand]
            [Vdom.Node.text "Portfolio"];
          
          Vdom.Node.div
            ~attrs:[Styles.nav_menu]
            [
              nav_item Home "Home";
              nav_item About "About";
              nav_item Projects "Projects";
              nav_item Resume "Resume";
            ]
        ]
    ]