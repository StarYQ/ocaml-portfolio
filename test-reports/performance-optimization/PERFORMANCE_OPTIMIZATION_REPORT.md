# Bonsai Portfolio Performance Optimization Report

## Executive Summary

This report provides comprehensive performance optimization techniques for Bonsai portfolio sites, covering incremental computation patterns, Virtual DOM optimization, bundle size reduction, and rendering performance strategies. Based on research of Jane Street's Bonsai framework documentation and js_of_ocaml optimization capabilities.

## 1. Incremental Computation Patterns

### 1.1 Core Principles

Bonsai's incremental computation model is built on Jane Street's Incremental library, providing smart memoization where functions run efficiently when inputs change slightly between runs.

**Key Performance Characteristics:**
- Single node firing overhead: ~30ns
- Most beneficial when computation per node is large relative to overhead
- Optimal for large graphs where only sub-graphs need recomputation

### 1.2 Bonsai.memo Usage

```ocaml
(* Use memo for expensive computations *)
let%sub expensive_result = 
  let%sub memoized = 
    Bonsai.memo 
      (module String)  (* Key module *)
      compute_expensive_function
  in
  memoized input
```

**Best Practices:**
- Use for computations taking >100μs
- Apply to pure functions with deterministic outputs
- Avoid memoizing functions with side effects

### 1.3 Cutoff Functions

Cutoff functions prevent unnecessary recomputation when values are semantically unchanged:

```ocaml
(* Define custom equality for cutoff *)
module Model_with_cutoff = struct
  type t = {
    id: int;
    data: string;
    (* Other fields *)
  } [@@deriving sexp]
  
  (* Custom equality - ignore certain fields *)
  let equal t1 t2 = 
    Int.equal t1.id t2.id && 
    String.equal t1.data t2.data
end

(* Use in state *)
let%sub state = 
  Bonsai.state_opt 
    (module Model_with_cutoff)
    ~default_model
```

**Optimization Strategies:**
- Default cutoff uses physical equality (fastest)
- Custom semantic equality for complex types
- Project model fields into separate incrementals for field-level cutoff

### 1.4 Dependency Tracking

```ocaml
(* Efficient dependency tracking pattern *)
let%sub derived_value =
  let%arr base_value = base_value in
  (* Computation only runs when base_value changes *)
  expensive_transform base_value

(* Avoid unnecessary dependencies *)
let%sub optimized =
  let%sub needed_field = 
    let%arr model = model in
    model.specific_field  (* Project only needed field *)
  in
  compute_with_field needed_field
```

### 1.5 Minimal Re-renders

```ocaml
(* Use match%sub for conditional rendering *)
let%sub content = 
  match%sub route with
  | Home -> 
    (* Home component only instantiated when route = Home *)
    Pages.Page_home.component ()
  | About -> 
    Pages.Page_about.component ()
  | _ -> 
    (* Other routes *)
```

## 2. Bundle Optimization

### 2.1 js_of_ocaml Compilation Flags

**Production Build Configuration:**

```dune
(executable
 (name main)
 (libraries client)
 (modes js)
 (js_of_ocaml
  (flags 
   (:standard
    --profile=prod           ; Enable aggressive dead code elimination
    --opt=3                  ; Maximum optimization level
    --enable=effects         ; Enable effects optimization
    --enable=toplevel-var    ; Optimize toplevel variables
    --enable=staticeval      ; Static evaluation
    --disable=debugger       ; Remove debug statements
    --disable=pretty         ; Minify output
    --disable=source-map     ; Remove source maps for production
    )))
 (preprocess (pps js_of_ocaml-ppx)))
```

### 2.2 Dead Code Elimination Strategies

**Current Capabilities:**
- Static analysis removes unreachable code
- All imports resolved at compile time
- Global optimization pass for functors (recent improvement)

**Known Limitations & Workarounds:**

```ocaml
(* AVOID: Functors create bundle bloat *)
module StringSet = Set.Make(String)  (* All Set functions included *)

(* PREFER: Custom minimal implementation if only need subset *)
module StringSet = struct
  type t = string list
  let empty = []
  let add x s = if List.mem x s then s else x :: s
  let mem = List.mem
end

(* AVOID: Optional labeled arguments add overhead *)
let create_element ?class_name ?id ?style () = ...

(* PREFER: Variants or separate functions *)
type element_config = 
  | Default
  | WithClass of string
  | WithId of string
  
let create_element config = ...
```

### 2.3 Bundle Size Reduction Techniques

**Remove Unnecessary PPX Derivers:**
```dune
(* Before - includes all derivers *)
(preprocess (pps ppx_jane))

(* After - selective derivers *)
(preprocess (pps 
  ppx_let 
  ppx_sexp_conv 
  ppx_compare
  js_of_ocaml-ppx 
  bonsai.ppx_bonsai))
```

**Size Impact of Common PPX:**
- `ppx_bin_prot`: ~800KB
- `ppx_variants_conv`: ~50KB
- `show, eq, compare, sexp`: ~20KB each

**Use Browser APIs:**
```ocaml
(* AVOID: Including Yojson parser *)
let parse_json str = 
  Yojson.Safe.from_string str

(* PREFER: Browser's JSON.parse *)
let parse_json str =
  Js.Unsafe.global##._JSON##parse (Js.string str)
  |> Js.to_string
```

### 2.4 Code Splitting Strategies

```ocaml
(* Lazy loading pattern for routes *)
let%sub page_component =
  match%sub route with
  | Projects ->
    (* Load projects module only when needed *)
    let%sub projects_loaded = 
      Bonsai.lazy_
        (lazy (Pages.Page_projects.component ()))
    in
    projects_loaded
  | _ -> 
    (* Other routes *)
```

## 3. Rendering Performance

### 3.1 Virtual DOM Efficiency

**Minimize VDOM Node Creation:**
```ocaml
(* AVOID: Creating new nodes on every render *)
let view model =
  let items = List.map (fun x -> 
    Vdom.Node.div [ Vdom.Node.text x ]
  ) model.items in
  Vdom.Node.div items

(* PREFER: Stable node creation with keys *)
let view =
  let%sub items_view = 
    Bonsai.assoc
      (module String)
      items
      ~f:(fun _key data ->
        let%arr data = data in
        Vdom.Node.div 
          ~key:(sprintf "item-%s" data.id)
          [ Vdom.Node.text data.content ])
  in
  let%arr items_view = items_view in
  Vdom.Node.div (Map.data items_view)
```

### 3.2 Batch Updates

```ocaml
(* Group related state updates *)
let handle_bulk_update items =
  Vdom.Effect.Many [
    set_loading true;
    update_items items;
    set_count (List.length items);
    set_loading false;
  ]
```

### 3.3 Animation Performance

```ocaml
(* Use CSS animations over JS *)
let animated_element =
  Vdom.Node.div
    ~attr:(Vdom.Attr.many [
      Vdom.Attr.class_ "fade-in";  (* CSS animation *)
      Vdom.Attr.style (Css_gen.create ~field:"will-change" ~value:"opacity")
    ])
    [ content ]
```

### 3.4 Scroll Performance

```ocaml
(* Virtualized list for long content *)
let%sub virtual_list =
  Bonsai_web_ui_virtual_list.component
    (module Int)
    ~row_height:(Value.return (`Px 50))
    ~height:(`Px 500)
    ~items
    ~render_row:(fun ~index ~data ->
      let%arr data = data in
      Vdom.Node.div [ Vdom.Node.text data ])
```

## 4. State Management Optimization

### 4.1 Efficient State Updates

```ocaml
(* Normalize state structure *)
module State = struct
  type t = {
    entities: Entity.t Int.Map.t;  (* Normalized *)
    ui_state: Ui_state.t;
    (* Separate frequently changing from stable data *)
  }
end

(* Update specific fields *)
let update_entity id updater =
  let%arr state = state
  and set_state = set_state in
  let entities = 
    Map.update state.entities id ~f:(function
      | None -> updater None
      | Some e -> updater (Some e))
  in
  set_state { state with entities }
```

### 4.2 Avoiding Unnecessary Computations

```ocaml
(* Use Bonsai.Expert for fine control *)
let%sub filtered_items =
  Bonsai.Expert.thunk (fun () ->
    (* Only recompute when dependencies change *)
    let%sub filter = filter in
    let%sub items = items in
    let%arr filter = filter
    and items = items in
    List.filter ~f:(matches_filter filter) items)
```

### 4.3 Reference Equality Optimization

```ocaml
(* Maintain reference equality when possible *)
let update_if_changed current new_value =
  if Model.equal current new_value
  then current  (* Keep same reference *)
  else new_value
```

## 5. Loading Performance

### 5.1 Initial Load Optimization

**HTML Template Optimization:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- Preload critical resources -->
  <link rel="preload" href="main.bc.js" as="script">
  
  <!-- Inline critical CSS -->
  <style>
    /* Critical path CSS */
    body { margin: 0; font-family: system-ui; }
    #app { min-height: 100vh; }
    /* Loading state */
    .loading { display: flex; justify-content: center; align-items: center; }
  </style>
  
  <!-- Defer non-critical CSS -->
  <link rel="stylesheet" href="styles.css" media="print" onload="this.media='all'">
</head>
<body>
  <div id="app" class="loading">
    <!-- Initial loading content -->
    <div>Loading...</div>
  </div>
  
  <!-- Load JS with defer -->
  <script defer src="main.bc.js"></script>
</body>
</html>
```

### 5.2 Progressive Enhancement

```ocaml
(* Progressive loading pattern *)
let%sub app =
  let%sub initial_data = 
    (* Load critical data first *)
    fetch_critical_data ()
  in
  let%sub enhanced_features =
    (* Load enhanced features after initial render *)
    Bonsai.lazy_ (lazy (
      load_enhanced_features ()
    ))
  in
  render_app initial_data enhanced_features
```

### 5.3 Caching Strategies

```ocaml
(* Client-side caching *)
module Cache = struct
  let storage = ref String.Map.empty
  
  let get_or_fetch key fetch_fn =
    match Map.find !storage key with
    | Some value -> 
      Bonsai.return value
    | None ->
      let%sub value = fetch_fn () in
      let%arr value = value in
      storage := Map.set !storage ~key ~data:value;
      value
end
```

## 6. Performance Checklist

### Pre-Development
- [ ] Define performance budget (bundle size, load time, FPS)
- [ ] Plan code splitting strategy
- [ ] Choose minimal PPX derivers
- [ ] Design normalized state structure

### During Development
- [ ] Use `Bonsai.memo` for expensive computations (>100μs)
- [ ] Implement custom cutoff functions for complex types
- [ ] Project model fields for field-level incrementality
- [ ] Use `match%sub` for conditional component rendering
- [ ] Prefer browser APIs over OCaml libraries when possible
- [ ] Add keys to list items for stable VDOM diffing
- [ ] Batch related state updates

### Build Configuration
- [ ] Enable `--profile=prod` for production builds
- [ ] Set `--opt=3` for maximum optimization
- [ ] Remove debug flags and source maps
- [ ] Configure dead code elimination
- [ ] Set `FORCE_DROP_INLINE_TEST=true`

### Testing & Monitoring
- [ ] Measure initial bundle size
- [ ] Profile initial load time
- [ ] Test time to interactive (TTI)
- [ ] Monitor frame rate during animations
- [ ] Check memory usage over time
- [ ] Validate incremental computation efficiency

## 7. Profiling Techniques

### Browser DevTools
```javascript
// Add performance marks in OCaml
let mark name =
  Js.Unsafe.global##.performance##mark (Js.string name)

// Measure between marks
let measure name start_mark end_mark =
  Js.Unsafe.global##.performance##measure 
    (Js.string name) 
    (Js.string start_mark) 
    (Js.string end_mark)
```

### Incremental Graph Analysis
```ocaml
(* Debug incremental computation *)
let%sub debug_node =
  let%sub value = expensive_computation in
  let%sub () = 
    Bonsai.Edge.on_change
      (module Model)
      value
      ~callback:(fun prev curr ->
        Js.log (sprintf "Value changed from %s to %s" 
          (Model.to_string prev)
          (Model.to_string curr));
        Effect.Ignore)
  in
  value
```

## 8. Common Pitfalls to Avoid

### Anti-Pattern Examples

**1. Creating New Functions in Render:**
```ocaml
(* AVOID: Creates new function on every render *)
let view model =
  Vdom.Node.button
    ~attr:(Vdom.Attr.on_click (fun _ -> 
      do_something model))
    
(* PREFER: Stable event handler *)
let%sub handler = 
  let%arr model = model in
  fun _ -> do_something model
in
let%arr handler = handler in
Vdom.Node.button
  ~attr:(Vdom.Attr.on_click handler)
```

**2. Excessive Model Nesting:**
```ocaml
(* AVOID: Deep nesting causes cascade updates *)
type model = {
  user: { profile: { settings: { theme: string } } }
}

(* PREFER: Flattened structure *)
type model = {
  user_id: int;
  user_theme: string;
  (* Other fields *)
}
```

**3. Uncontrolled Effect Chains:**
```ocaml
(* AVOID: Cascading effects *)
let%sub () =
  Bonsai.Edge.on_change
    (module Model)
    model
    ~callback:(fun _ new_model ->
      set_derived_state (compute new_model))

(* PREFER: Derived state through computation *)
let%sub derived_state =
  let%arr model = model in
  compute model
```

## 9. Framework-Specific Optimizations

### Router Performance
```ocaml
(* Current implementation uses polling - consider optimization *)
module Router = struct
  (* Instead of polling every 50ms *)
  let create_route_state () =
    (* Use popstate event listener *)
    let%sub route, set_route = 
      Bonsai.state (module Route) ~default_model
    in
    let%sub () =
      Bonsai.Edge.lifecycle
        ~on_activate:(fun () ->
          (* Add event listener *)
          Dom_html.window##.onpopstate := Dom_html.handler (fun _ ->
            set_route (parse_current_url ());
            Js._false))
        ()
    in
    route
end
```

### Component Lazy Loading
```ocaml
module Lazy_component = struct
  let create loader =
    let%sub loaded = 
      Bonsai.state_opt () 
    in
    let%sub () =
      match%sub loaded with
      | None -> 
        Bonsai.Edge.lifecycle
          ~on_activate:(fun () ->
            loader () >>| set_loaded)
          ()
      | Some _ -> Bonsai.return ()
    in
    loaded
end
```

## 10. Future Optimizations

### Potential Improvements
1. **Implement code splitting** per route
2. **Add service worker** for offline caching
3. **Use Web Workers** for heavy computations
4. **Implement virtual scrolling** for long lists
5. **Add resource hints** (preconnect, prefetch)
6. **Enable HTTP/2 Push** for critical resources
7. **Implement skeleton screens** during loading
8. **Add intersection observer** for lazy loading

## Conclusion

Performance optimization in Bonsai requires understanding both the incremental computation model and js_of_ocaml compilation. Key strategies include:

1. **Leverage incrementality** through proper use of cutoffs and memoization
2. **Minimize bundle size** with dead code elimination and selective imports
3. **Optimize rendering** with stable VDOM nodes and batch updates
4. **Structure state** for efficient updates and minimal recomputation
5. **Configure builds** with production optimization flags

Regular profiling and monitoring ensure these optimizations provide real-world benefits. The goal is fast, responsive portfolio sites that showcase both content and technical excellence.

## References

- Jane Street Blog: "Introducing Incremental"
- Jane Street: "Seven Implementations of Incremental"
- Bonsai.red Documentation
- js_of_ocaml Optimization Wiki
- OCaml Flambda Documentation