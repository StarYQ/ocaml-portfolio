open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom
open Shared.Types

(* Import navigation styles *)
module Styles = Navigation_styles.Styles

let component =
  let%sub menu_open, set_menu_open = Bonsai.state (module Bool) ~default_model:false in
  let%sub current_route = Router.create_route_state () in
  let%sub theme = Theme.current () in
  
  let%arr menu_open = menu_open
  and set_menu_open = set_menu_open
  and current_route = current_route
  and theme = theme in
  
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
  
  (* Hamburger icon attrs *)
  let hamburger_attrs = 
    if menu_open then 
      [Styles.hamburger; Styles.is_open]
    else 
      [Styles.hamburger]
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
                  nav_item Words "Words";
                  nav_item Contact "Contact";
                  
                  (* Theme Toggle Button *)
                  Vdom.Node.button
                    ~attrs:[
                      Styles.theme_toggle;
                      Vdom.Attr.on_click (fun _ ->
                        let new_theme = Theme.toggle theme in
                        Theme.store_theme new_theme;
                        (* Update document class *)
                        let open Js_of_ocaml in
                        Dom_html.document##.body##.className := 
                          Js.string (Theme.to_class_name new_theme);
                        Vdom.Effect.Ignore);
                      Vdom.Attr.create "aria-label" 
                        (match theme with
                         | Theme.Light -> "Switch to dark mode"
                         | Theme.Dark -> "Switch to light mode")
                    ]
                    [
                      Vdom.Node.span
                        ~attrs:[Styles.theme_icon]
                        [Vdom.Node.text 
                          (match theme with
                           | Theme.Light -> "🌙"
                           | Theme.Dark -> "☀️")]
                    ]
                ];
              
              (* Mobile Menu Toggle *)
              Vdom.Node.button
                ~attrs:[
                  Styles.menu_toggle;
                  toggle_menu;
                  Vdom.Attr.create "aria-label" "Toggle menu"
                ]
                [
                  Vdom.Node.span
                    ~attrs:hamburger_attrs
                    []
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
              mobile_nav_item Words "Words";
              mobile_nav_item Contact "Contact";
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
              nav_item Words "Words";
              nav_item Contact "Contact";
            ]
        ]
    ]