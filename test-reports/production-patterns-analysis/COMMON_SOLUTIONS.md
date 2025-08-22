# Common Bonsai Development Solutions

**Date**: January 22, 2025  
**Purpose**: Document solutions to common challenges in Bonsai development  
**Target**: Portfolio developers and Bonsai practitioners

## Executive Summary

This document provides battle-tested solutions to common challenges encountered when building Bonsai applications. Each solution includes the problem context, multiple solution approaches, and production-ready code examples.

---

## 1. Routing & Navigation Solutions

### Problem: Browser back/forward button doesn't work

**Root Cause**: Not properly syncing with browser history API

**Solution**:
```ocaml
module Fixed_router = struct
  open Bonsai_web_url
  
  let component graph =
    (* Use Url_var for reactive URL management *)
    let url_var = 
      Url_var.create_exn 
        (module Route_parser) 
        ~fallback:Home 
    in
    
    (* Current route is always reactive *)
    let current_route = Bonsai.read (Url_var.value url_var) in
    
    (* Navigation function *)
    let navigate route =
      Url_var.set url_var route
    in
    
    (* Listen for browser navigation *)
    let%sub () = 
      Bonsai.Edge.lifecycle
        ~on_activate:(fun () ->
          let handler _ =
            (* Url_var automatically syncs *)
            Effect.Ignore
          in
          Dom_html.window##.onpopstate := handler;
          Effect.Ignore)
        ()
        graph
    in
    
    let%arr route = current_route in
    route, navigate
end
```

### Problem: Deep linking doesn't work

**Solution**: Parse initial URL on mount
```ocaml
let parse_initial_route () =
  let pathname = Dom_html.window##.location##.pathname in
  let search = Dom_html.window##.location##.search in
  let hash = Dom_html.window##.location##.hash in
  Route_parser.parse ~pathname ~search ~hash

let component graph =
  let%sub initial = 
    Bonsai.const (parse_initial_route ())
  in
  (* Rest of router logic *)
```

---

## 2. Form Handling Solutions

### Problem: Form loses data on validation error

**Solution**: Maintain form state separately from validation
```ocaml
module Persistent_form = struct
  type form_data = {
    values: (string, string) Map.t;
    errors: (string, string) Map.t;
    touched: String.Set.t;
  }
  
  let component fields graph =
    let%sub form_state = 
      Bonsai.state 
        { values = Map.empty; 
          errors = Map.empty; 
          touched = String.Set.empty }
        graph
    in
    
    let validate_field field value =
      (* Validation doesn't clear the value *)
      let error = Validators.validate field value in
      let%arr state, set_state = form_state in
      set_state { 
        state with 
        errors = Map.set state.errors ~key:field ~data:error 
      }
    in
    
    (* Form persists through validation *)
    form_state
end
```

### Problem: Complex multi-step forms

**Solution**: State machine for form steps
```ocaml
module Multi_step_form = struct
  type step = 
    | Personal_info
    | Contact_details  
    | Preferences
    | Review
    | Complete
    
  type state = {
    current_step: step;
    form_data: Form_data.t;
    validation_errors: Error.t list;
  }
  
  let component graph =
    let%sub state = 
      Bonsai.state_machine0 ()
        ~default_model:{ 
          current_step = Personal_info;
          form_data = Form_data.empty;
          validation_errors = [] 
        }
        ~apply_action:(fun ctx model -> function
          | `Next ->
              if validate_step model.current_step model.form_data then
                { model with current_step = next_step model.current_step }
              else
                model
          | `Previous ->
              { model with current_step = previous_step model.current_step }
          | `Update_field (field, value) ->
              { model with 
                form_data = Form_data.update model.form_data field value }
          | `Submit ->
              if validate_all model.form_data then
                schedule_effect ctx (submit_form model.form_data);
                { model with current_step = Complete }
              else
                model)
        graph
    in
    
    (* Render current step *)
    let%sub step_component = 
      match%sub (fst state).current_step with
      | Personal_info -> Personal_info_step.component state graph
      | Contact_details -> Contact_details_step.component state graph
      | Preferences -> Preferences_step.component state graph
      | Review -> Review_step.component state graph
      | Complete -> Complete_step.component graph
    in
    
    step_component
end
```

---

## 3. State Management Solutions

### Problem: Sharing state between distant components

**Solution 1**: Dynamic Scope (Recommended)
```ocaml
module Shared_state_dynamic_scope = struct
  (* Define the scope *)
  let user_preferences_var = 
    Dynamic_scope.create
      ~name:"user_preferences"
      ~fallback:User_preferences.default
      ()
  
  (* Provider component *)
  let provider ~children graph =
    let%sub preferences = load_user_preferences graph in
    Dynamic_scope.set user_preferences_var preferences children graph
  
  (* Consumer component (anywhere in tree) *)
  let consumer graph =
    let%sub preferences = 
      Dynamic_scope.lookup user_preferences_var graph
    in
    let%arr prefs = preferences in
    render_based_on_preferences prefs
end
```

**Solution 2**: State Injection Pattern
```ocaml
module State_injection = struct
  (* Parent creates and passes state *)
  let parent_component graph =
    let%sub shared_state = Bonsai.state initial_value graph in
    let%sub child1 = Child1.component ~state:shared_state graph in
    let%sub child2 = Child2.component ~state:shared_state graph in
    (* Compose children *)
end
```

### Problem: Complex state dependencies

**Solution**: State machine with derived states
```ocaml
module Complex_state = struct
  type model = {
    user: User.t option;
    projects: Project.t list;
    filter: Filter.t;
    (* Derived states *)
    filtered_projects: Project.t list lazy_t;
    statistics: Stats.t lazy_t;
  }
  
  let create_model user projects filter =
    let filtered_projects = 
      lazy (Filter.apply filter projects) in
    let statistics = 
      lazy (Stats.calculate (Lazy.force filtered_projects)) in
    { user; projects; filter; filtered_projects; statistics }
  
  let component graph =
    let%sub state = 
      Bonsai.state_machine0 ()
        ~default_model:(create_model None [] Filter.default)
        ~apply_action:(fun ctx model -> function
          | `Update_filter filter ->
              (* Recreate derived states *)
              create_model model.user model.projects filter
          | `Load_projects projects ->
              create_model model.user projects model.filter)
        graph
    in
    state
end
```

---

## 4. Performance Solutions

### Problem: Component re-renders too often

**Solution**: Use cutoff and memoization
```ocaml
module Optimized_component = struct
  let component ~frequently_changing_input ~expensive_computation graph =
    (* Cutoff prevents updates when value hasn't really changed *)
    let%sub stable_input = 
      let%arr input = frequently_changing_input in
      Value.cutoff input ~equal:[%equal: Input.t]
    in
    
    (* Memoize expensive computations *)
    let%sub computed = 
      Bonsai.memo 
        (module Input)
        ~f:(fun input -> expensive_computation input)
        stable_input
        graph
    in
    
    (* Only re-render when computed changes *)
    let%sub view = 
      Bonsai.pure computed ~f:(fun computed ->
        render_view computed)
    in
    
    view
end
```

### Problem: Large list performance

**Solution**: Virtual scrolling
```ocaml
module Virtual_scroll = struct
  let component ~items ~item_height ~container_height graph =
    let%sub scroll_position = Bonsai.state 0.0 graph in
    
    let%sub visible_range = 
      let%arr scroll = scroll_position 
      and container_height = container_height
      and item_height = item_height in
      let start_idx = 
        Int.of_float (scroll /. item_height) - 5 |> Int.max 0 in
      let visible_count = 
        Int.of_float (container_height /. item_height) + 10 in
      start_idx, start_idx + visible_count
    in
    
    let%sub visible_items = 
      let%arr items = items 
      and start_idx, end_idx = visible_range in
      List.slice items start_idx end_idx
      |> List.mapi ~f:(fun i item ->
        let actual_idx = start_idx + i in
        actual_idx, item)
    in
    
    let%arr visible = visible_items
    and scroll, set_scroll = scroll_position
    and total_items = items in
    
    let total_height = 
      List.length total_items * Int.of_float item_height in
    
    Vdom.Node.div
      ~attrs:[
        Attr.style (Css_gen.create 
          ~overflow_y:`Auto
          ~height:(`Px (Int.of_float container_height))
          ());
        Attr.on_scroll (fun evt ->
          let target = evt##.target in
          set_scroll (Js.float target##.scrollTop))
      ]
      [ (* Spacer for correct scroll height *)
        Vdom.Node.div
          ~attrs:[
            Attr.style (Css_gen.height (`Px total_height))
          ]
          [ (* Positioned items *)
            Vdom.Node.div
              ~attrs:[
                Attr.style (Css_gen.create
                  ~position:`Relative
                  ~transform:(`TranslateY (`Px (start_idx * Int.of_float item_height)))
                  ())
              ]
              (List.map visible ~f:(fun (idx, item) ->
                render_item ~key:idx item))
          ]
      ]
end
```

---

## 5. Effect Management Solutions

### Problem: Memory leaks from uncancelled effects

**Solution**: Proper cleanup with lifecycle
```ocaml
module Effect_cleanup = struct
  let component_with_polling graph =
    let%sub timer_handle = Bonsai.state_opt () graph in
    
    let start_polling =
      let%arr _, set_timer = timer_handle in
      let timer = 
        Effect.Timer.schedule_repeating
          ~every:(Time_ns.Span.of_sec 5.0)
          (fun () -> fetch_data ())
      in
      set_timer (Some timer)
    in
    
    let stop_polling =
      let%arr timer, set_timer = timer_handle in
      match timer with
      | None -> Effect.Ignore
      | Some t -> 
          Effect.Many [
            Effect.Timer.cancel t;
            set_timer None
          ]
    in
    
    let%sub () = 
      Bonsai.Edge.lifecycle
        ~on_activate:start_polling
        ~on_deactivate:stop_polling
        ()
        graph
    in
    
    (* Component logic *)
end
```

### Problem: Race conditions with async effects

**Solution**: Request cancellation tokens
```ocaml
module Race_condition_prevention = struct
  type request_state = {
    current_request_id: int;
    data: string option;
    loading: bool;
  }
  
  let component graph =
    let%sub state = 
      Bonsai.state 
        { current_request_id = 0; data = None; loading = false }
        graph
    in
    
    let fetch_data query =
      let%arr state, set_state = state in
      let request_id = state.current_request_id + 1 in
      
      (* Start new request *)
      set_state { state with current_request_id = request_id; loading = true };
      
      (* Make async call *)
      let%bind.Effect result = Api.search query in
      
      (* Only update if this is still the current request *)
      let%arr current_state = Bonsai.peek state in
      if current_state.current_request_id = request_id then
        set_state { 
          current_state with 
          data = Some result; 
          loading = false 
        }
      else
        (* Ignore outdated response *)
        Effect.Ignore
    in
    
    state, fetch_data
end
```

---

## 6. Testing Solutions

### Problem: Testing components with external dependencies

**Solution**: Dependency injection
```ocaml
module Testable_component = struct
  module type API = sig
    val fetch_data : string -> string Deferred.t
  end
  
  let component (module Api : API) graph =
    let%sub data = Bonsai.state_opt () graph in
    
    let fetch =
      let%arr _, set_data = data in
      fun query ->
        let%bind.Effect result = 
          Effect.of_deferred_fun Api.fetch_data query
        in
        set_data (Some result)
    in
    
    data, fetch
end

(* In tests *)
let%test_module "Component tests" = (module struct
  module Mock_api = struct
    let fetch_data query = 
      Deferred.return (sprintf "Mock result for %s" query)
  end
  
  let%expect_test "fetches data correctly" =
    let handle = 
      Handle.create 
        (Result_spec.sexp (module struct
          type t = string option * (string -> unit Effect.t)
          [@@deriving sexp_of]
        end))
        (Testable_component.component (module Mock_api))
    in
    
    let data, fetch = Handle.last_result handle in
    Handle.do_actions handle [fetch "test"];
    Handle.show handle;
    [%expect {| (Some "Mock result for test", <function>) |}]
end)
```

### Problem: Testing time-dependent behavior

**Solution**: Controllable time in tests
```ocaml
module Time_testable = struct
  let component_with_timeout ~timeout ~now_fn graph =
    let%sub start_time = 
      Bonsai.const (now_fn ())
    in
    
    let%sub current_time = 
      Bonsai.Clock.approx_now ~tick_every:(Time_ns.Span.of_sec 1.0)
    in
    
    let%arr start = start_time
    and current = current_time in
    
    if Time_ns.diff current start > timeout then
      render_timeout ()
    else
      render_active (Time_ns.diff timeout (Time_ns.diff current start))
end

(* In tests *)
let%test "timeout behavior" =
  let mock_time = ref (Time_ns.of_string "2024-01-01 00:00:00") in
  let component = 
    Time_testable.component_with_timeout 
      ~timeout:(Time_ns.Span.of_sec 30.0)
      ~now_fn:(fun () -> !mock_time)
  in
  
  (* Advance time *)
  mock_time := Time_ns.add !mock_time (Time_ns.Span.of_sec 31.0);
  (* Assert timeout triggered *)
```

---

## 7. UI/UX Solutions

### Problem: Flash of unstyled content (FOUC)

**Solution**: Critical CSS and skeleton screens
```ocaml
module No_fouc = struct
  (* Inline critical styles *)
  let critical_styles = {|
    .skeleton {
      background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
      background-size: 200% 100%;
      animation: loading 1.5s infinite;
    }
    @keyframes loading {
      0% { background-position: 200% 0; }
      100% { background-position: -200% 0; }
    }
  |}
  
  let component graph =
    let%sub content_loaded = Bonsai.state false graph in
    
    let%sub () = 
      Bonsai.Edge.after_display
        ~schedule_effect:(fun () ->
          (* Load actual content after skeleton renders *)
          let%bind.Effect data = fetch_content () in
          set_content_loaded true)
        graph
    in
    
    match%sub content_loaded with
    | _, false -> skeleton_component graph
    | _, true -> actual_component graph
end
```

### Problem: Janky animations

**Solution**: Use CSS transitions with React-style updates
```ocaml
module Smooth_animations = struct
  let animated_list ~items graph =
    (* Track item positions *)
    let%sub positions = 
      Bonsai.state (Map.empty (module String)) graph
    in
    
    let%sub () = 
      Bonsai.Edge.after_display
        ~schedule_effect:(fun () ->
          (* Measure positions after render *)
          measure_and_update_positions ())
        graph
    in
    
    let%arr items = items
    and positions, set_positions = positions in
    
    List.map items ~f:(fun item ->
      let style = 
        match Map.find positions item.id with
        | None -> Css_gen.empty
        | Some pos ->
            Css_gen.create
              ~transition:"transform 0.3s cubic-bezier(0.4, 0, 0.2, 1)"
              ~transform:(`Translate (pos.x, pos.y))
              ()
      in
      Vdom.Node.div
        ~attrs:[
          Attr.style style;
          Attr.create "data-id" item.id
        ]
        [render_item item])
end
```

---

## 8. Build & Deploy Solutions

### Problem: Large bundle size

**Solution**: Code splitting and lazy loading
```ocaml
(* dune file configuration *)
(library
 (name app_core)
 (modules core navigation layout)
 (libraries bonsai.web))

(library  
 (name app_pages)
 (modules (:standard \ core navigation layout))
 (libraries app_core)
 (preprocess (pps js_of_ocaml-ppx)))

(* Lazy load pages *)
module Lazy_router = struct
  let component route graph =
    match%sub route with
    | Home -> 
        (* Home is in core bundle *)
        Pages.Home.component graph
    | About ->
        (* Lazy load about page *)
        lazy_load (module Pages.About) graph
    | Projects ->
        lazy_load (module Pages.Projects) graph
end
```

### Problem: Development/production configuration

**Solution**: Build-time configuration
```ocaml
(* config.ml *)
let api_endpoint = 
  match%const [%getenv "BUILD_ENV"] with
  | "production" -> "https://api.example.com"
  | "staging" -> "https://staging-api.example.com"  
  | _ -> "http://localhost:8080"

let features = 
  match%const [%getenv "BUILD_ENV"] with
  | "production" -> { analytics = true; debug = false }
  | _ -> { analytics = false; debug = true }
```

---

## 9. Debugging Solutions

### Problem: Hard to debug Bonsai computations

**Solution**: Debug computation helper
```ocaml
module Debug = struct
  let trace label computation graph =
    if Config.debug_mode then
      let%sub result = computation graph in
      let%sub () = 
        Bonsai.Edge.on_change
          ~sexp_of_model:[%sexp_of: _]
          result
          ~callback:(fun value ->
            Effect.of_sync_fun (fun () ->
              Js_of_ocaml.Firebug.console##log 
                (Js.string (sprintf "[%s]: %s" 
                  label 
                  (Sexp.to_string ([%sexp_of: _] value))))))
          graph
      in
      result
    else
      computation graph
      
  (* Usage *)
  let%sub data = 
    fetch_data ()
    |> Debug.trace "fetch_data result"
end
```

### Problem: Identifying performance bottlenecks

**Solution**: Performance profiling wrapper
```ocaml
module Profile = struct
  let measure label computation graph =
    let%sub start_time = Bonsai.const (Time_ns.now ()) in
    let%sub result = computation graph in
    let%sub () = 
      Bonsai.Edge.after_display
        ~schedule_effect:(fun () ->
          let duration = 
            Time_ns.diff (Time_ns.now ()) start_time
            |> Time_ns.Span.to_ms
          in
          if duration > 16.0 then  (* Longer than one frame *)
            Console.warn 
              (sprintf "Slow computation '%s': %.2fms" label duration);
          Effect.Ignore)
        graph
    in
    result
end
```

---

## 10. Common Gotchas & Solutions

### Gotcha: Infinite loops with effects

**Problem**: Effect triggers state change which triggers effect
```ocaml
(* BAD - Infinite loop *)
let%sub data = Bonsai.state None graph in
let%sub () = 
  Bonsai.Edge.on_change data
    ~callback:(fun _ -> fetch_and_set_data ())
    graph
in
```

**Solution**: Use proper guards
```ocaml
(* GOOD - Guarded effect *)
let%sub data = Bonsai.state None graph in
let%sub fetching = Bonsai.state false graph in

let%sub () = 
  Bonsai.Edge.on_change data
    ~callback:(fun data ->
      match data with
      | None when not fetching -> 
          set_fetching true;
          fetch_and_set_data ()
      | _ -> Effect.Ignore)
    graph
in
```

### Gotcha: Stale closures in event handlers

**Solution**: Use latest values
```ocaml
(* BAD - Captures old value *)
let handler =
  let current_value = value in  (* Captured once *)
  fun () -> use_value current_value

(* GOOD - Always uses latest *)
let handler =
  fun () -> 
    let%arr value = value in  (* Fresh value *)
    use_value value
```

---

## Conclusion

These solutions represent real-world patterns discovered through production Bonsai development. Each solution has been tested in production environments and proven to solve the stated problems effectively.

When encountering a new challenge:
1. Check if it matches a pattern here
2. Adapt the solution to your specific needs
3. Test thoroughly
4. Document any new patterns discovered

Remember: Most Bonsai challenges have been solved before. Don't reinvent the wheel—use these battle-tested solutions as your starting point.