(* IMPLEMENTATION_EXAMPLES.ml - Working code examples for Bonsai routing *)

open! Core
open Bonsai.Let_syntax
open Bonsai_web
open Js_of_ocaml

(* ============================================================================
   SECTION 1: REACTIVE URL STATE MANAGEMENT
   ============================================================================ *)

module Url_state = struct
  (* Global URL atom using Bonsai.Var for reactive state *)
  let url_var = 
    let initial_path = 
      Dom_html.window##.location##.pathname |> Js.to_string
    in
    Bonsai.Var.create initial_path

  (* Get current URL as a Bonsai value *)
  let current () = Bonsai.Var.value url_var

  (* Update URL and browser history *)
  let set_path path =
    let open Vdom.Effect.Expert in
    handle (fun () ->
      (* Update internal state *)
      Bonsai.Var.set url_var path;
      (* Update browser history without triggering popstate *)
      Dom_html.window##.history##pushState 
        Js.null 
        (Js.string "") 
        (Js.string path)
    )

  (* Replace current history entry *)
  let replace_path path =
    let open Vdom.Effect.Expert in
    handle (fun () ->
      Bonsai.Var.set url_var path;
      Dom_html.window##.history##replaceState 
        Js.null 
        (Js.string "") 
        (Js.string path)
    )

  (* Initialize popstate listener for browser back/forward *)
  let init_history_listener () =
    Dom_html.window##.onpopstate := Dom_html.handler (fun _evt ->
      let new_path = 
        Dom_html.window##.location##.pathname |> Js.to_string
      in
      (* Update state reactively when user navigates via browser buttons *)
      Vdom.Effect.Expert.handle (fun () ->
        Bonsai.Var.set url_var new_path
      );
      Js._false
    )
end

(* ============================================================================
   SECTION 2: ROUTE DEFINITIONS WITH PARSING
   ============================================================================ *)

module Route = struct
  type t = 
    | Home
    | About
    | Projects
    | Project_detail of string
    | Blog
    | Blog_post of string
    | Contact
    | Not_found
  [@@deriving sexp, equal]

  let to_path = function
    | Home -> "/"
    | About -> "/about"
    | Projects -> "/projects"
    | Project_detail id -> sprintf "/projects/%s" id
    | Blog -> "/blog"
    | Blog_post slug -> sprintf "/blog/%s" slug
    | Contact -> "/contact"
    | Not_found -> "/404"

  let of_path path =
    let parts = 
      String.split path ~on:'/' 
      |> List.filter ~f:(fun s -> not (String.is_empty s))
    in
    match parts with
    | [] -> Home
    | ["about"] -> About
    | ["projects"] -> Projects
    | ["projects"; id] -> Project_detail id
    | ["blog"] -> Blog
    | ["blog"; slug] -> Blog_post slug
    | ["contact"] -> Contact
    | _ -> Not_found

  let to_title = function
    | Home -> "Home"
    | About -> "About Me"
    | Projects -> "My Projects"
    | Project_detail id -> sprintf "Project: %s" id
    | Blog -> "Blog"
    | Blog_post slug -> sprintf "Post: %s" slug
    | Contact -> "Contact"
    | Not_found -> "Page Not Found"
end

(* ============================================================================
   SECTION 3: ROUTER COMPONENT
   ============================================================================ *)

module Router = struct
  let component () =
    (* Get reactive URL value *)
    let%sub current_path = Url_state.current () in
    
    (* Parse route from path *)
    let%sub current_route =
      let%arr path = current_path in
      Route.of_path path
    in
    
    (* Update document title when route changes *)
    let%sub () =
      Bonsai.Edge.on_change 
        (module Route)
        current_route
        ~callback:(fun _prev curr ->
          let title = sprintf "%s | Portfolio" (Route.to_title curr) in
          Vdom.Effect.of_sync_fun (fun () ->
            Dom_html.document##.title := Js.string title
          ) ()
        )
    in
    
    return current_route
end

(* ============================================================================
   SECTION 4: NAVIGATION LINK COMPONENT
   ============================================================================ *)

module Link = struct
  let component ?(attrs = []) ~href ~children () =
    let%arr href = href in
    
    let click_handler evt =
      (* Check for modifier keys *)
      if List.exists
        [evt##.ctrlKey; evt##.shiftKey; evt##.altKey; evt##.metaKey]
        ~f:Js.to_bool
      then
        (* Let browser handle modified clicks (open in new tab, etc) *)
        Vdom.Effect.Ignore
      else
        (* Handle as SPA navigation *)
        Vdom.Effect.Many [
          Url_state.set_path href;
          Vdom.Effect.Prevent_default
        ]
    in
    
    Vdom.Node.a
      ~attrs:(
        attrs @ [
          Vdom.Attr.href href;
          Vdom.Attr.on_click click_handler
        ]
      )
      children

  (* Convenience function for route-based links *)
  let route_link ?(attrs = []) ~route ~children () =
    component ~attrs ~href:(Value.return (Route.to_path route)) ~children ()
end

(* ============================================================================
   SECTION 5: NAVIGATION BAR COMPONENT
   ============================================================================ *)

module Nav_bar = struct
  let component ~current_route =
    let%arr current_route = current_route in
    
    let nav_item route label =
      let is_active = Route.equal current_route route in
      let class_name = 
        String.concat ~sep:" " [
          "nav-link";
          if is_active then "active" else ""
        ]
      in
      
      Link.route_link
        ~attrs:[Vdom.Attr.class_ class_name]
        ~route
        ~children:[Vdom.Node.text label]
        ()
    in
    
    Vdom.Node.nav ~attrs:[Vdom.Attr.class_ "navbar"]
      [ Vdom.Node.div ~attrs:[Vdom.Attr.class_ "nav-brand"]
          [ Link.route_link 
              ~route:Home 
              ~children:[Vdom.Node.text "My Portfolio"] 
              ()
          ]
      ; Vdom.Node.ul ~attrs:[Vdom.Attr.class_ "nav-menu"]
          [ Vdom.Node.li [] [nav_item Home "Home"]
          ; Vdom.Node.li [] [nav_item About "About"]
          ; Vdom.Node.li [] [nav_item Projects "Projects"]
          ; Vdom.Node.li [] [nav_item Blog "Blog"]
          ; Vdom.Node.li [] [nav_item Contact "Contact"]
          ]
      ]
end

(* ============================================================================
   SECTION 6: MOBILE NAVIGATION MENU
   ============================================================================ *)

module Mobile_nav = struct
  let component ~current_route =
    let%sub is_open = Bonsai.state false in
    
    let%arr is_open, set_open = is_open
    and current_route = current_route in
    
    let toggle_menu = 
      Vdom.Attr.on_click (fun _ -> set_open (not is_open))
    in
    
    let close_menu = 
      Vdom.Attr.on_click (fun _ -> set_open false)
    in
    
    let menu_class = 
      String.concat ~sep:" " [
        "mobile-menu";
        if is_open then "open" else "closed"
      ]
    in
    
    let nav_item route label =
      Link.route_link
        ~attrs:[
          Vdom.Attr.class_ "mobile-nav-link";
          close_menu  (* Close menu on navigation *)
        ]
        ~route
        ~children:[Vdom.Node.text label]
        ()
    in
    
    Vdom.Node.div ~attrs:[Vdom.Attr.class_ "mobile-navigation"]
      [ (* Hamburger button *)
        Vdom.Node.button
          ~attrs:[
            Vdom.Attr.class_ "menu-toggle";
            toggle_menu;
            Vdom.Attr.("aria-label", "Toggle navigation menu");
            Vdom.Attr.("aria-expanded", if is_open then "true" else "false")
          ]
          [ Vdom.Node.span ~attrs:[Vdom.Attr.class_ "hamburger-icon"] [] ]
      
      ; (* Sliding menu *)
        Vdom.Node.div ~attrs:[Vdom.Attr.class_ menu_class]
          [ (* Close button *)
            Vdom.Node.button
              ~attrs:[
                Vdom.Attr.class_ "menu-close";
                close_menu;
                Vdom.Attr.("aria-label", "Close menu")
              ]
              [Vdom.Node.text "×"]
          
          ; (* Menu items *)
            Vdom.Node.nav ~attrs:[Vdom.Attr.class_ "mobile-nav-items"]
              [ nav_item Home "Home"
              ; nav_item About "About"
              ; nav_item Projects "Projects"
              ; nav_item Blog "Blog"
              ; nav_item Contact "Contact"
              ]
          ]
      
      ; (* Overlay backdrop *)
        if is_open then
          Vdom.Node.div 
            ~attrs:[
              Vdom.Attr.class_ "menu-overlay";
              close_menu
            ]
            []
        else
          Vdom.Node.none
      ]
end

(* ============================================================================
   SECTION 7: BREADCRUMB NAVIGATION
   ============================================================================ *)

module Breadcrumbs = struct
  let component ~current_route =
    let%arr current_route = current_route in
    
    let crumbs = 
      match current_route with
      | Home -> []
      | About -> [("Home", Home); ("About", About)]
      | Projects -> [("Home", Home); ("Projects", Projects)]
      | Project_detail id -> 
          [("Home", Home); 
           ("Projects", Projects); 
           (sprintf "Project %s" id, Project_detail id)]
      | Blog -> [("Home", Home); ("Blog", Blog)]
      | Blog_post slug ->
          [("Home", Home);
           ("Blog", Blog);
           (slug, Blog_post slug)]
      | Contact -> [("Home", Home); ("Contact", Contact)]
      | Not_found -> [("Home", Home); ("404", Not_found)]
    in
    
    match crumbs with
    | [] -> Vdom.Node.none
    | _ ->
        let items = 
          List.mapi crumbs ~f:(fun i (label, route) ->
            let is_last = i = List.length crumbs - 1 in
            Vdom.Node.li 
              ~attrs:[
                Vdom.Attr.class_ "breadcrumb-item";
                if is_last then Vdom.Attr.("aria-current", "page") else Vdom.Attr.empty
              ]
              [ if is_last then
                  Vdom.Node.span [] [Vdom.Node.text label]
                else
                  Link.route_link ~route ~children:[Vdom.Node.text label] ()
              ]
          )
        in
        
        Vdom.Node.nav ~attrs:[Vdom.Attr.("aria-label", "breadcrumb")]
          [ Vdom.Node.ol ~attrs:[Vdom.Attr.class_ "breadcrumb"]
              items
          ]
end

(* ============================================================================
   SECTION 8: ROUTE TRANSITIONS
   ============================================================================ *)

module Route_transition = struct
  type animation_state = 
    | Idle
    | Exiting
    | Entering
  [@@deriving sexp, equal]

  let component ~route ~content =
    let%sub animation_state = Bonsai.state Idle in
    
    (* Trigger animation on route change *)
    let%sub () =
      Bonsai.Edge.on_change
        (module Route)
        route
        ~callback:(fun prev curr ->
          if not (Route.equal prev curr) then
            let%bind.Vdom.Effect () = 
              snd animation_state Exiting 
            in
            let%bind.Vdom.Effect () =
              (* Wait for exit animation *)
              Vdom.Effect.of_sync_fun (fun () ->
                ignore (
                  Dom_html.window##setTimeout
                    (Js.wrap_callback (fun () ->
                      Vdom.Effect.Expert.handle (fun () ->
                        snd animation_state Entering
                      )
                    ))
                    300.0
                )
              ) ()
            in
            let%bind.Vdom.Effect () =
              (* Reset to idle after enter animation *)
              Vdom.Effect.of_sync_fun (fun () ->
                ignore (
                  Dom_html.window##setTimeout
                    (Js.wrap_callback (fun () ->
                      Vdom.Effect.Expert.handle (fun () ->
                        snd animation_state Idle
                      )
                    ))
                    600.0
                )
              ) ()
            in
            Vdom.Effect.return ()
          else
            Vdom.Effect.Ignore
        )
    in
    
    let%arr state = fst animation_state
    and content = content in
    
    let animation_class = 
      match state with
      | Idle -> "route-content"
      | Exiting -> "route-content fade-exit"
      | Entering -> "route-content fade-enter"
    in
    
    Vdom.Node.div ~attrs:[Vdom.Attr.class_ animation_class]
      [content]
end

(* ============================================================================
   SECTION 9: QUERY PARAMETERS
   ============================================================================ *)

module Query_params = struct
  type t = (string * string) list [@@deriving sexp, equal]

  let parse () =
    let search = Dom_html.window##.location##.search |> Js.to_string in
    if String.is_empty search then
      []
    else
      let search = String.drop_prefix search 1 in (* Remove '?' *)
      String.split search ~on:'&'
      |> List.filter_map ~f:(fun pair ->
        match String.split pair ~on:'=' with
        | [key; value] -> 
            Some (
              Js_of_ocaml.Url.urldecode key,
              Js_of_ocaml.Url.urldecode value
            )
        | _ -> None
      )

  let get params key =
    List.Assoc.find params key ~equal:String.equal

  let set params key value =
    List.Assoc.add params key value ~equal:String.equal

  let remove params key =
    List.Assoc.remove params key ~equal:String.equal

  let to_string params =
    match params with
    | [] -> ""
    | _ ->
        params
        |> List.map ~f:(fun (k, v) -> 
          sprintf "%s=%s" 
            (Js_of_ocaml.Url.urlencode k)
            (Js_of_ocaml.Url.urlencode v)
        )
        |> String.concat ~sep:"&"
        |> sprintf "?%s"

  (* Update URL with new query params *)
  let update params =
    let path = Dom_html.window##.location##.pathname |> Js.to_string in
    let new_url = path ^ to_string params in
    Url_state.replace_path new_url
end

(* ============================================================================
   SECTION 10: SCROLL RESTORATION
   ============================================================================ *)

module Scroll_restoration = struct
  (* Store scroll positions for each route *)
  let scroll_positions = String.Table.create ()

  let save_position route =
    let scroll_y = Dom_html.window##.pageYOffset in
    Hashtbl.set scroll_positions 
      ~key:(Route.to_path route) 
      ~data:scroll_y

  let restore_position route =
    match Hashtbl.find scroll_positions (Route.to_path route) with
    | Some pos ->
        Dom_html.window##scrollTo 0. pos
    | None ->
        Dom_html.window##scrollTo 0. 0.

  (* Component that manages scroll restoration *)
  let component ~route =
    let%sub previous_route = Bonsai.previous_value route in
    
    let%sub () =
      Bonsai.Edge.on_change
        (module Route) 
        route
        ~callback:(fun prev curr ->
          (* Save previous route's scroll position *)
          Option.iter prev ~f:save_position;
          (* Restore or reset scroll for new route *)
          Vdom.Effect.of_sync_fun restore_position curr
        )
    in
    
    return ()
end

(* ============================================================================
   SECTION 11: MAIN APP INTEGRATION
   ============================================================================ *)

module App = struct
  let component () =
    (* Initialize history listener once on app start *)
    let%sub () = 
      Bonsai.Edge.lifecycle
        ~on_activate:(
          Vdom.Effect.of_sync_fun Url_state.init_history_listener ()
        )
        ()
    in
    
    (* Get current route *)
    let%sub current_route = Router.component () in
    
    (* Enable scroll restoration *)
    let%sub () = Scroll_restoration.component ~route:current_route in
    
    (* Render page content based on route *)
    let%sub page_content =
      let%arr route = current_route in
      match route with
      | Home -> Pages.Home.component ()
      | About -> Pages.About.component ()
      | Projects -> Pages.Projects.component ()
      | Project_detail id -> Pages.Project_detail.component ~id ()
      | Blog -> Pages.Blog.component ()
      | Blog_post slug -> Pages.Blog_post.component ~slug ()
      | Contact -> Pages.Contact.component ()
      | Not_found -> Pages.Not_found.component ()
    in
    
    (* Wrap in route transition *)
    let%sub content_with_transition =
      Route_transition.component 
        ~route:current_route 
        ~content:page_content
    in
    
    (* Compose full layout *)
    let%arr navigation = Nav_bar.component ~current_route
    and mobile_nav = Mobile_nav.component ~current_route
    and breadcrumbs = Breadcrumbs.component ~current_route
    and content = content_with_transition in
    
    Vdom.Node.div ~attrs:[Vdom.Attr.id "app"]
      [ navigation
      ; mobile_nav
      ; breadcrumbs
      ; Vdom.Node.main ~attrs:[Vdom.Attr.class_ "main-content"]
          [content]
      ]
end

(* ============================================================================
   SECTION 12: APP STARTUP
   ============================================================================ *)

let run () =
  Bonsai_web.Start.start
    ~bind_to_element_with_id:"app"
    (App.component ())