# Bonsai Routing & Navigation Research Report

## Executive Summary

This report documents comprehensive research on proper routing and navigation patterns for Bonsai portfolio sites. The current implementation uses inefficient polling (checking URL every 50ms), which should be replaced with reactive event-based routing using browser's popstate events.

## Current Implementation Problems

### 1. Polling-Based Approach (INEFFICIENT)
```ocaml
(* Current problematic implementation in Router.ml *)
let%sub () = 
  Bonsai.Clock.every
    ~when_to_start_next_effect:`Every_multiple_of_period_blocking
    (Time_ns.Span.of_ms 50.0)
    polling_effect
in
```

**Issues:**
- Checks URL every 50ms regardless of actual changes
- Wastes CPU cycles
- Creates unnecessary re-renders
- Not truly reactive
- Delays up to 50ms for navigation feedback

### 2. Global Mutable State
```ocaml
let route_setter_ref : (route -> unit Vdom.Effect.t) option ref = ref None
```

**Issues:**
- Side-effects outside Bonsai's state management
- Potential race conditions
- Not compositional

## Recommended Solution: Event-Based Reactive Routing

### 1. Proper Url_var Implementation

Based on research from Ceramic Hacker's blog and Bonsai patterns, the proper approach uses:

```ocaml
open! Core
open Bonsai.Let_syntax
open Bonsai_web
open Js_of_ocaml

(* Create a top-level URL atom using Bonsai.Var *)
let uri_atom = 
  let initial_uri = 
    Dom_html.window##.location##.pathname
    |> Js.to_string
    |> Uri.of_string
  in
  Bonsai.Var.create initial_uri

(* Reactive URL value accessible throughout the app *)
let current_uri = Bonsai.Var.value uri_atom

(* Update URL and browser history *)
let set_path path =
  let open Vdom.Effect.Expert in
  handle (fun () ->
    (* Update internal state *)
    Bonsai.Var.set uri_atom (Uri.of_string path);
    (* Update browser history *)
    Dom_html.window##.history##pushState 
      Js.null 
      (Js.string "") 
      (Js.string path)
  )
```

### 2. Browser History Event Handling

Use popstate events for back/forward navigation:

```ocaml
(* Set up popstate listener on app initialization *)
let setup_history_listener () =
  Dom_html.window##.onpopstate := Dom_html.handler (fun _evt ->
    let pathname = 
      Dom_html.window##.location##.pathname
      |> Js.to_string
    in
    (* Update Bonsai state reactively *)
    Bonsai.Var.set uri_atom (Uri.of_string pathname);
    Js._false
  )

(* Alternative using addEventListener for better control *)
let setup_history_listener_v2 () =
  let listener = Dom.addEventListener 
    Dom_html.window 
    (Dom.Event.make "popstate")
    (Dom_html.handler (fun evt ->
      let pathname = 
        Dom_html.window##.location##.pathname
        |> Js.to_string
      in
      Effect.Expert.handle (fun () ->
        Bonsai.Var.set uri_atom (Uri.of_string pathname)
      );
      Js._false
    ))
    Js._false
  in
  (* Store listener ID if removal needed later *)
  listener
```

### 3. Router Component Pattern

```ocaml
module Router = struct
  let component routes =
    let%sub uri = Bonsai.Var.Watch.value_cutoff uri_atom ~equal:Uri.equal in
    let%arr uri = uri in
    let path = Uri.path uri in
    routes path
end
```

### 4. Navigation Link Component

```ocaml
module Nav_link = struct
  let component ~href ~children () =
    let%arr href = href in
    Vdom.Node.a
      ~attrs:[
        Vdom.Attr.href href;
        Vdom.Attr.on_click (fun evt ->
          (* Check for modifier keys *)
          if List.exists
            [evt##.ctrlKey; evt##.shiftKey; evt##.altKey; evt##.metaKey]
            ~f:Js.to_bool
          then
            (* Let browser handle modified clicks *)
            Effect.Ignore
          else
            (* Handle as SPA navigation *)
            Effect.Many [
              set_path href;
              Effect.Prevent_default
            ]
        )
      ]
      children
end
```

## Navigation Pattern Recommendations

### 1. Navigation Bar Component

```ocaml
module Navigation_bar = struct
  let component ~current_route =
    let%sub theme = Theme.current () in
    let%arr current_route = current_route
    and theme = theme in
    
    let nav_item route label =
      let is_active = Route.equal current_route route in
      let classes = 
        [ "nav-item"
        ; if is_active then "active" else "" 
        ] |> String.concat ~sep:" "
      in
      Nav_link.component 
        ~href:(Route.to_string route)
        ~children:[Vdom.Node.text label]
        ~attrs:[Vdom.Attr.class_ classes]
        ()
    in
    
    Vdom.Node.nav
      ~attrs:[Vdom.Attr.class_ "main-nav"]
      [
        Vdom.Node.div ~attrs:[Vdom.Attr.class_ "nav-brand"]
          [Nav_link.component 
            ~href:"/" 
            ~children:[Vdom.Node.text "Portfolio"] 
            ()];
        Vdom.Node.ul ~attrs:[Vdom.Attr.class_ "nav-menu"]
          [ nav_item Home "Home"
          ; nav_item About "About"  
          ; nav_item Projects "Projects"
          ; nav_item Words "Blog"
          ; nav_item Contact "Contact"
          ]
      ]
end
```

### 2. Breadcrumb Navigation

```ocaml
module Breadcrumbs = struct
  let component ~route =
    let%arr route = route in
    
    let breadcrumb_items = 
      match route with
      | Home -> []
      | About -> [("Home", Home); ("About", About)]
      | Projects -> [("Home", Home); ("Projects", Projects)]
      | Project_detail id -> 
          [("Home", Home); ("Projects", Projects); 
           (sprintf "Project %s" id, Project_detail id)]
      | _ -> []
    in
    
    let items = List.map breadcrumb_items ~f:(fun (label, route) ->
      Vdom.Node.li ~attrs:[Vdom.Attr.class_ "breadcrumb-item"]
        [Nav_link.component 
          ~href:(Route.to_string route) 
          ~children:[Vdom.Node.text label]
          ()]
    ) in
    
    Vdom.Node.nav ~attrs:[Vdom.Attr.("aria-label", "breadcrumb")]
      [Vdom.Node.ol ~attrs:[Vdom.Attr.class_ "breadcrumb"] items]
end
```

### 3. Mobile-Responsive Menu

```ocaml
module Mobile_menu = struct
  let component ~current_route =
    let%sub is_open = Bonsai.state false in
    let%arr is_open, set_is_open = is_open
    and current_route = current_route in
    
    let toggle_menu = 
      Vdom.Attr.on_click (fun _ -> 
        set_is_open (not is_open))
    in
    
    let menu_class = 
      if is_open then "mobile-menu open" else "mobile-menu"
    in
    
    Vdom.Node.div ~attrs:[Vdom.Attr.class_ "mobile-nav"]
      [ (* Hamburger button *)
        Vdom.Node.button 
          ~attrs:[
            Vdom.Attr.class_ "menu-toggle";
            toggle_menu;
            Vdom.Attr.("aria-label", "Toggle menu")
          ]
          [Vdom.Node.span ~attrs:[Vdom.Attr.class_ "hamburger"] []]
      ; (* Menu overlay *)
        Vdom.Node.div ~attrs:[Vdom.Attr.class_ menu_class]
          [ (* Close button *)
            Vdom.Node.button
              ~attrs:[
                Vdom.Attr.class_ "menu-close";
                toggle_menu
              ]
              [Vdom.Node.text "×"]
          ; (* Menu items *)
            Navigation_items.component ~current_route 
              ~on_click:(fun _ -> set_is_open false)
          ]
      ]
end
```

## Advanced Routing Features

### 1. Route Transitions

```ocaml
module Route_transition = struct
  let component ~route ~content =
    let%sub animation_state = 
      Bonsai.state_machine0 () ~default_model:`Entering
        ~apply_action:(fun _ model action ->
          match action with
          | `Enter -> `Entering
          | `Entered -> `Entered
          | `Exit -> `Exiting
          | `Exited -> `Exited
        )
    in
    
    let%sub () = 
      (* Trigger animation on route change *)
      Bonsai.Edge.on_change route ~callback:(fun _ _ ->
        let%bind.Effect () = send_action `Exit in
        let%bind.Effect () = 
          Effect.of_sync_fun (fun () ->
            Js_of_ocaml.Dom_html.window##setTimeout
              (Js.wrap_callback (fun () -> 
                Effect.Expert.handle (fun () -> send_action `Enter)))
              300.0
          ) ()
        in
        Effect.return ()
      )
    in
    
    let%arr state = animation_state
    and content = content in
    
    let animation_class = 
      match state with
      | `Entering -> "fade-enter"
      | `Entered -> "fade-enter-active"
      | `Exiting -> "fade-exit"
      | `Exited -> "fade-exit-active"
    in
    
    Vdom.Node.div 
      ~attrs:[Vdom.Attr.class_ ("route-transition " ^ animation_class)]
      [content]
end
```

### 2. Query Parameters

```ocaml
module Query_params = struct
  type t = (string * string) list [@@deriving sexp, equal]
  
  let parse uri =
    Uri.query uri
    |> List.concat_map ~f:(fun (key, values) ->
      List.map values ~f:(fun value -> (key, value))
    )
  
  let get params key =
    List.Assoc.find params key ~equal:String.equal
  
  let set params key value =
    List.Assoc.add params key value ~equal:String.equal
  
  let to_string params =
    params
    |> List.map ~f:(fun (k, v) -> sprintf "%s=%s" k v)
    |> String.concat ~sep:"&"
    |> function
      | "" -> ""
      | s -> "?" ^ s
end
```

### 3. Route Guards

```ocaml
module Route_guard = struct
  let require_auth ~is_authenticated ~route ~fallback =
    if is_authenticated then
      route
    else
      fallback
  
  let component ~check ~route ~fallback_route =
    let%sub passes_check = check route in
    let%arr passes = passes_check
    and route = route in
    
    if passes then
      route
    else (
      (* Redirect to fallback *)
      Effect.Expert.handle (fun () ->
        set_path (Route.to_string fallback_route)
      );
      fallback_route
    )
end
```

### 4. Dynamic Routes

```ocaml
module Dynamic_route = struct
  type t = 
    | Static of string
    | Param of string
    | Wildcard
  [@@deriving sexp, equal]
  
  let parse pattern path =
    let pattern_parts = String.split pattern ~on:'/' in
    let path_parts = String.split path ~on:'/' in
    
    let rec match_parts patterns paths params =
      match patterns, paths with
      | [], [] -> Some params
      | Static s :: ps, h :: ts when String.equal s h ->
          match_parts ps ts params
      | Param name :: ps, h :: ts ->
          match_parts ps ts ((name, h) :: params)
      | Wildcard :: _, _ -> Some params
      | _ -> None
    in
    
    match_parts pattern_parts path_parts []
end
```

## SEO Considerations

### 1. Meta Tags Management

```ocaml
module Meta_tags = struct
  let update_for_route route =
    let title, description = 
      match route with
      | Home -> "Portfolio", "Welcome to my portfolio"
      | About -> "About Me", "Learn more about my experience"
      | Projects -> "Projects", "View my work and projects"
      | Contact -> "Contact", "Get in touch with me"
      | _ -> "Portfolio", ""
    in
    
    (* Update document title *)
    Dom_html.document##.title := Js.string title;
    
    (* Update meta description *)
    let meta_desc = 
      Dom_html.document##querySelector (Js.string "meta[name='description']")
    in
    Option.iter meta_desc ~f:(fun elem ->
      elem##setAttribute (Js.string "content") (Js.string description)
    )
end
```

### 2. Structured Data

```ocaml
module Structured_data = struct
  let update_for_route route =
    let json_ld = 
      match route with
      | Home -> 
          {|{
            "@context": "https://schema.org",
            "@type": "Person",
            "name": "Your Name",
            "jobTitle": "Software Developer"
          }|}
      | Projects ->
          {|{
            "@context": "https://schema.org",
            "@type": "CreativeWork",
            "name": "Portfolio Projects"
          }|}
      | _ -> ""
    in
    
    (* Update or create JSON-LD script *)
    let script_id = "structured-data" in
    let existing = Dom_html.document##getElementById (Js.string script_id) in
    
    Option.iter existing ~f:(fun elem ->
      elem##.innerHTML := Js.string json_ld
    )
end
```

## Implementation Checklist

### Phase 1: Core Routing (Priority 1)
- [ ] Replace polling with popstate event listener
- [ ] Implement Bonsai.Var-based URL state
- [ ] Create reactive router component
- [ ] Update nav_link to use new routing

### Phase 2: Navigation Components (Priority 2)
- [ ] Implement responsive navigation bar
- [ ] Add mobile menu with hamburger
- [ ] Create breadcrumb component
- [ ] Add active link highlighting

### Phase 3: Advanced Features (Priority 3)
- [ ] Add route transitions/animations
- [ ] Implement query parameter handling
- [ ] Add route guards for protected pages
- [ ] Support dynamic route patterns

### Phase 4: SEO & Performance (Priority 4)
- [ ] Update meta tags on route change
- [ ] Add structured data support
- [ ] Implement route prefetching
- [ ] Add focus management

## Performance Considerations

### 1. Eliminate Polling
- **Before**: 50ms polling = 20 checks/second
- **After**: Event-based = 0 checks until actual navigation
- **Improvement**: ~100% reduction in idle CPU usage

### 2. Use Incremental Computations
```ocaml
(* Use cutoff to prevent unnecessary recomputations *)
let%sub uri = Bonsai.Var.Watch.value_cutoff uri_atom ~equal:Uri.equal in
```

### 3. Lazy Load Route Components
```ocaml
module Lazy_route = struct
  let component route =
    match route with
    | Projects -> 
        (* Load projects component only when needed *)
        lazy (Projects_page.component ())
    | _ -> ...
end
```

## Testing Strategy

### 1. Unit Tests
```ocaml
let%expect_test "route parsing" =
  print_endline (Route.to_string Home);
  [%expect {| / |}];
  
  print_endline (Route.to_string (Route.of_string "/projects"));
  [%expect {| /projects |}]
```

### 2. Browser Tests (Playwright)
```javascript
// Test navigation works
await page.goto('http://localhost:8080');
await page.click('nav a[href="/about"]');
await expect(page).toHaveURL('http://localhost:8080/about');

// Test browser back button
await page.goBack();
await expect(page).toHaveURL('http://localhost:8080/');
```

## Migration Path

### Step 1: Update Router.ml
1. Remove polling-based implementation
2. Add popstate event listener
3. Use Bonsai.Var for state

### Step 2: Update App.ml
1. Initialize history listener on startup
2. Use new router component

### Step 3: Update Navigation
1. Ensure nav_link uses new routing
2. Test all navigation paths

### Step 4: Add Features
1. Implement advanced routing features
2. Add SEO optimizations
3. Enhance mobile experience

## Resources & References

1. **Ceramic Hacker Blog**: Comprehensive Bonsai routing tutorial
2. **Jane Street Bonsai**: Official repository and examples
3. **js_of_ocaml Documentation**: DOM and event handling
4. **MDN Web Docs**: History API and popstate events
5. **Bonsai Tutorials**: askvortsov1's comprehensive tutorials

## Conclusion

The current polling-based routing implementation is inefficient and not truly reactive. By adopting event-based routing with popstate listeners and Bonsai.Var for state management, we can achieve:

1. **True Reactivity**: Instant response to navigation events
2. **Better Performance**: No wasted CPU cycles on polling
3. **Cleaner Architecture**: Proper separation of concerns
4. **Enhanced UX**: Smooth transitions and faster navigation
5. **SEO Benefits**: Proper meta tag and structured data management

The recommended implementation follows established Bonsai patterns and leverages the framework's strengths in incremental computation and reactive state management.