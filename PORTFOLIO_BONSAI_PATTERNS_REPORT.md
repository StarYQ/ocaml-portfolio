# Portfolio-Specific Bonsai Web Development Patterns

**Date**: January 22, 2025  
**Focus**: Practical patterns for building portfolio websites with Bonsai  
**Sources**: Existing codebase analysis, Bonsai documentation research, web development best practices

## Executive Summary

This report consolidates portfolio-specific patterns for building professional portfolio websites using Jane Street's Bonsai framework. Focus is on immediately actionable patterns that enhance user experience and showcase technical expertise.

## 1. Component Architecture for Portfolios

### 1.1 Page Component Pattern
```ocaml
(* Standard portfolio page component *)
module Page = struct
  type state = {
    scroll_position: float;
    animation_state: [ `Entering | `Visible | `Exiting ];
    content_loaded: bool;
  }

  let component ~route ~theme graph =
    let%sub state = Bonsai.state_machine0 
      ~default_model:{ scroll_position = 0.0; animation_state = `Entering; content_loaded = false }
      ~apply_action:(fun _ctx model action -> 
        match action with
        | `Scroll pos -> { model with scroll_position = pos }
        | `AnimationUpdate state -> { model with animation_state = state }
        | `ContentLoaded -> { model with content_loaded = true })
      graph
    in
    let%sub content = create_content route state graph in
    let%arr content = content and state = state in
    content, state  (* Return view and state tuple *)
end
```

### 1.2 Reusable UI Components

#### Project Card Component
```ocaml
module Project_card = struct
  let component ~project ~on_click graph =
    let%sub hover_state = Bonsai.state false graph in
    let%arr hover, set_hover = hover_state 
    and project = project 
    and on_click = on_click in
    
    let styles = 
      let open Ppx_css.Syntax in
      [%css {|
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        cursor: pointer;
        &:hover {
          transform: translateY(-4px);
          box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
      |}]
    in
    
    Vdom.Node.div
      ~attrs:[
        Vdom.Attr.classes styles;
        Vdom.Attr.on_mouseenter (fun _ -> set_hover true);
        Vdom.Attr.on_mouseleave (fun _ -> set_hover false);
        Vdom.Attr.on_click (fun _ -> on_click project.id);
      ]
      [ render_project_content project hover ]
end
```

#### Skill Badge Component
```ocaml
module Skill_badge = struct
  let component ~skill ~clickable graph =
    let%sub selected = Bonsai.state false graph in
    let%arr selected, set_selected = selected
    and skill = skill in
    
    let styles = 
      let open Ppx_css.Syntax in
      [%css {|
        display: inline-block;
        padding: 0.5rem 1rem;
        border-radius: 9999px;
        background: %{if selected then "#3b82f6" else "#e5e7eb"};
        color: %{if selected then "white" else "#374151"};
        transition: all 0.2s ease;
        user-select: none;
        %{if clickable then "cursor: pointer;" else ""}
      |}]
    in
    
    Vdom.Node.span
      ~attrs:[
        Vdom.Attr.classes styles;
        (if clickable then
          Vdom.Attr.on_click (fun _ -> set_selected (not selected))
        else Vdom.Attr.empty);
      ]
      [Vdom.Node.text skill.name]
end
```

### 1.3 Layout Composition
```ocaml
module Portfolio_layout = struct
  let component ~navigation ~content ~footer ~theme graph =
    let%sub scroll_progress = track_scroll_progress graph in
    let%sub page_transition = manage_page_transitions graph in
    
    let%arr navigation = navigation
    and content = content
    and footer = footer
    and scroll_progress = scroll_progress
    and page_transition = page_transition
    and theme = theme in
    
    Vdom.Node.div
      ~attrs:[Vdom.Attr.class_ (theme_class theme)]
      [
        render_progress_bar scroll_progress;
        navigation;
        apply_transition page_transition content;
        footer;
      ]
end
```

## 2. State Management for SPAs

### 2.1 Route State Management (Fixed Pattern)
```ocaml
module Router = struct
  (* Proper reactive routing without polling *)
  let create_router graph =
    let url_var = Url_var.create_exn (module Route_parser) ~fallback:Home in
    let current_route = Bonsai.read (Url_var.value url_var) in
    
    let set_route route =
      let url = Route_parser.unparse route in
      Url_var.set url_var url
    in
    
    let%sub () = 
      (* Listen for browser back/forward *)
      Bonsai.Edge.lifecycle
        ~on_activate:(fun () ->
          let handler _ =
            let route = parse_current_url () in
            Url_var.set url_var (Route_parser.unparse route)
          in
          Dom_html.window##.addEventListener 
            (Js.string "popstate") 
            (Dom.handler (fun e -> handler e; Js._false))
          |> ignore;
          Vdom.Effect.Ignore)
        ()
    in
    
    current_route, set_route
end
```

### 2.2 Theme/Dark Mode State
```ocaml
module Theme = struct
  type t = Light | Dark [@@deriving sexp, equal]
  
  let var = Dynamic_scope.create 
    ~name:"theme" 
    ~fallback:Light 
    ~sexp_of_t:[%sexp_of: t] 
    ()
  
  let provider ~default graph =
    let%sub theme, set_theme = Bonsai.state (module struct
      type t = Theme.t [@@deriving sexp, equal]
    end) ~default_model:default graph in
    
    let%sub () = 
      (* Persist theme preference *)
      Bonsai.Edge.on_change theme
        ~callback:(fun theme ->
          let storage = Dom_html.window##.localStorage in
          storage##setItem (Js.string "theme") 
            (Js.string (if theme = Dark then "dark" else "light"));
          Vdom.Effect.Ignore)
        graph
    in
    
    Dynamic_scope.set var theme graph
  
  let use graph = Dynamic_scope.lookup var graph
end
```

### 2.3 Form State Handling
```ocaml
module Contact_form = struct
  let component graph =
    open Bonsai_web_ui_form.Elements in
    
    let%sub name = Textbox.string ~placeholder:"Your Name" graph in
    let%sub email = 
      Email.string ~placeholder:"your@email.com" graph
      |> Form.validate ~f:(fun email ->
        if String.contains email '@' then Ok email
        else Error "Invalid email address")
    in
    let%sub message = Textarea.string ~placeholder:"Your message" graph in
    
    let%sub submission_state = Bonsai.state_machine0
      ~default_model:`Idle
      ~apply_action:(fun _ctx model action ->
        match action with
        | `Submit -> `Submitting
        | `Success -> `Success
        | `Error msg -> `Error msg
        | `Reset -> `Idle)
      graph
    in
    
    let%arr name = name
    and email = email
    and message = message
    and state, inject = submission_state in
    
    render_form ~name ~email ~message ~state ~inject
end
```

### 2.4 Animation State
```ocaml
module Animation = struct
  type state = {
    scroll_triggered: String.Set.t;  (* IDs of triggered animations *)
    hover_states: String.Map.t;      (* ID -> hover state *)
    transition_phase: [ `Idle | `Entering | `Leaving ];
  }
  
  let create_animation_state graph =
    let%sub state = Bonsai.state_machine0
      ~default_model:{ 
        scroll_triggered = String.Set.empty;
        hover_states = String.Map.empty;
        transition_phase = `Idle;
      }
      ~apply_action:(fun _ctx model -> function
        | `TriggerScroll id -> 
            { model with scroll_triggered = Set.add model.scroll_triggered id }
        | `SetHover (id, hovering) ->
            { model with hover_states = Map.set model.hover_states ~key:id ~data:hovering }
        | `SetTransition phase ->
            { model with transition_phase = phase })
      graph
    in
    state
end
```

## 3. Styling Patterns with ppx_css

### 3.1 Type-Safe CSS
```ocaml
module Styles = struct
  open Ppx_css.Syntax
  
  let hero_section ~theme =
    [%css {|
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: %{theme_gradient theme};
      position: relative;
      overflow: hidden;
      
      @media (max-width: 768px) {
        padding: 2rem;
      }
    |}]
  
  let animated_entrance ~delay =
    [%css {|
      animation: fadeInUp 0.8s ease-out %{delay}s both;
      
      @keyframes fadeInUp {
        from {
          opacity: 0;
          transform: translateY(30px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
    |}]
end
```

### 3.2 Dynamic Styling
```ocaml
let dynamic_gradient ~scroll_position ~theme =
  let open Ppx_css.Syntax in
  let hue = Float.to_int (scroll_position *. 60.0) in
  [%css {|
    background: linear-gradient(
      135deg,
      hsl(%{hue}, 70%, %{if theme = Dark then "20%" else "95%"}),
      hsl(%{hue + 30}, 70%, %{if theme = Dark then "10%" else "85%"})
    );
    transition: background 0.5s ease;
  |}]
```

### 3.3 Responsive Design
```ocaml
module Responsive = struct
  let container =
    let open Ppx_css.Syntax in
    [%css {|
      width: 100%;
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 1rem;
      
      @media (min-width: 640px) {
        padding: 0 2rem;
      }
      
      @media (min-width: 1024px) {
        padding: 0 4rem;
      }
    |}]
  
  let grid ~columns =
    [%css {|
      display: grid;
      gap: 2rem;
      grid-template-columns: repeat(1, 1fr);
      
      @media (min-width: 768px) {
        grid-template-columns: repeat(%{min columns 2}, 1fr);
      }
      
      @media (min-width: 1024px) {
        grid-template-columns: repeat(%{columns}, 1fr);
      }
    |}]
end
```

## 4. User Interaction Patterns

### 4.1 Click Handlers
```ocaml
let interactive_element ~on_click ~on_hover graph =
  let%sub interaction_state = Bonsai.state `Idle graph in
  
  let%arr state, set_state = interaction_state
  and on_click = on_click in
  
  Vdom.Node.button
    ~attrs:[
      Vdom.Attr.on_click (fun _ -> 
        set_state `Clicked;
        on_click ());
      Vdom.Attr.on_mouseenter (fun _ -> set_state `Hover);
      Vdom.Attr.on_mouseleave (fun _ -> set_state `Idle);
      Vdom.Attr.class_ (interaction_class state);
    ]
    [render_button_content state]
```

### 4.2 Hover Effects
```ocaml
module Hover_card = struct
  let component ~content ~details graph =
    let%sub hover = Bonsai.state false graph in
    let%sub mouse_position = Bonsai.state (0.0, 0.0) graph in
    
    let%arr hover, set_hover = hover
    and mouse_x, mouse_y = mouse_position
    and content = content
    and details = details in
    
    Vdom.Node.div
      ~attrs:[
        Vdom.Attr.on_mouseenter (fun _ -> set_hover true);
        Vdom.Attr.on_mouseleave (fun _ -> set_hover false);
        Vdom.Attr.on_mousemove (fun evt ->
          let x = Js.Optdef.get evt##.offsetX (fun () -> 0) in
          let y = Js.Optdef.get evt##.offsetY (fun () -> 0) in
          set_mouse_position (Float.of_int x, Float.of_int y));
      ]
      [
        content;
        if hover then render_tooltip details mouse_x mouse_y else Vdom.Node.none;
      ]
end
```

### 4.3 Smooth Scrolling
```ocaml
module Smooth_scroll = struct
  let scroll_to_element ~id ~offset =
    Vdom.Effect.of_sync_fun (fun () ->
      let element = Dom_html.getElementById_opt id in
      match element with
      | Some el ->
          let rect = el##getBoundingClientRect in
          let top = rect##.top +. Dom_html.window##.pageYOffset -. offset in
          Dom_html.window##scrollTo 
            (object%js
              val top = top
              val behavior = Js.string "smooth"
            end)
      | None -> ())
    
  let scroll_spy ~sections graph =
    let%sub active_section = Bonsai.state "" graph in
    
    let%sub () = 
      Bonsai.Clock.every
        (Time_ns.Span.of_ms 100.0)
        (let%map active, set_active = active_section
         and sections = sections in
         check_visible_section sections set_active)
    in
    
    active_section
end
```

### 4.4 Page Transitions
```ocaml
module Page_transition = struct
  type transition = {
    from_route: route;
    to_route: route;
    progress: float;  (* 0.0 to 1.0 *)
    phase: [ `Exiting | `Entering ];
  }
  
  let animate_transition ~from_route ~to_route graph =
    let%sub transition_state = Bonsai.state_machine0
      ~default_model:{ from_route; to_route; progress = 0.0; phase = `Exiting }
      ~apply_action:(fun ctx model action ->
        match action with
        | `Tick ->
            if model.progress >= 1.0 then
              if model.phase = `Exiting then
                { model with progress = 0.0; phase = `Entering }
              else
                model  (* Complete *)
            else
              { model with progress = min 1.0 (model.progress +. 0.05) }
        | `Reset (from, to_) ->
            { from_route = from; to_route = to_; progress = 0.0; phase = `Exiting })
      graph
    in
    
    let%sub () =
      Bonsai.Clock.every
        (Time_ns.Span.of_ms 16.0)  (* 60 FPS *)
        (let%map _, inject = transition_state in
         inject `Tick)
    in
    
    transition_state
end
```

## 5. Portfolio-Specific Components

### 5.1 Project Gallery
```ocaml
module Project_gallery = struct
  let component ~projects ~filter graph =
    let%sub filtered_projects = 
      let%map projects = projects
      and filter = filter in
      List.filter projects ~f:(fun p ->
        match filter with
        | `All -> true
        | `Category cat -> String.equal p.category cat
        | `Tech tech -> List.mem p.technologies tech ~equal:String.equal)
    in
    
    let%sub project_cards = 
      Bonsai.assoc (module String) 
        (Value.map filtered_projects ~f:(fun ps ->
          String.Map.of_alist_exn (List.map ps ~f:(fun p -> p.id, p))))
        ~f:(fun id project graph ->
          Project_card.component ~project ~on_click:(navigate_to_project id) graph)
        graph
    in
    
    let%arr cards = project_cards in
    Vdom.Node.div
      ~attrs:[Vdom.Attr.class_ "project-gallery"]
      (Map.data cards)
end
```

### 5.2 Skills Showcase
```ocaml
module Skills_showcase = struct
  type display_mode = Grid | Cloud | Timeline
  
  let component ~skills ~mode graph =
    let%sub selected_skills = Bonsai.state String.Set.empty graph in
    let%sub animation_delay = stagger_animation_delays skills graph in
    
    let%arr skills = skills
    and selected, set_selected = selected_skills
    and delays = animation_delay
    and mode = mode in
    
    match mode with
    | Grid -> render_grid_layout skills selected set_selected delays
    | Cloud -> render_tag_cloud skills selected set_selected
    | Timeline -> render_timeline skills selected
end
```

### 5.3 Contact Form with Validation
```ocaml
module Professional_contact_form = struct
  let component graph =
    let open Bonsai_web_ui_form in
    
    let%sub form = 
      let%sub name = Elements.Textbox.string 
        ~placeholder:"Full Name" 
        ~validation:(Elements.Validation.required ~error_message:"Name is required")
        graph 
      in
      
      let%sub email = Elements.Email.string
        ~placeholder:"email@example.com"
        ~validation:(Elements.Validation.chain [
          Elements.Validation.required ~error_message:"Email is required";
          Elements.Validation.email ~error_message:"Invalid email format";
        ])
        graph
      in
      
      let%sub subject = Elements.Dropdown.string
        ~options:["Collaboration"; "Job Opportunity"; "General Inquiry"]
        ~placeholder:"Select a subject"
        graph
      in
      
      let%sub message = Elements.Textarea.string
        ~placeholder:"Your message..."
        ~min_length:10
        ~max_length:1000
        graph
      in
      
      let%sub captcha = implement_simple_captcha graph in
      
      combine_form_fields ~name ~email ~subject ~message ~captcha graph
    in
    
    let%sub submission = handle_form_submission form graph in
    
    let%arr form = form
    and submission = submission in
    render_contact_form form submission
end
```

### 5.4 About Section with Timeline
```ocaml
module About_timeline = struct
  type milestone = {
    year: int;
    title: string;
    description: string;
    icon: string;
  }
  
  let component ~milestones graph =
    let%sub visible_items = 
      track_scroll_visibility milestones graph
    in
    
    let%arr milestones = milestones
    and visible = visible_items in
    
    Vdom.Node.div
      ~attrs:[Vdom.Attr.class_ "timeline-container"]
      (List.mapi milestones ~f:(fun i milestone ->
        let is_visible = Set.mem visible i in
        render_timeline_item milestone i is_visible))
end
```

### 5.5 Blog/Article Display
```ocaml
module Article_viewer = struct
  let component ~article ~theme graph =
    let%sub reading_progress = track_reading_progress graph in
    let%sub toc_active = track_active_heading graph in
    
    let%arr article = article
    and progress = reading_progress
    and active_heading = toc_active
    and theme = theme in
    
    Vdom.Node.article
      ~attrs:[
        Vdom.Attr.class_ (article_styles theme);
      ]
      [
        render_progress_indicator progress;
        render_table_of_contents article.headings active_heading;
        render_article_content article;
        render_share_buttons article;
      ]
end
```

## 6. Performance Optimization Patterns

### 6.1 Lazy Loading
```ocaml
module Lazy_load = struct
  let component ~load_content ~placeholder graph =
    let%sub is_visible = Bonsai.state false graph in
    let%sub content = 
      Bonsai.lazy_ (fun graph ->
        match%sub is_visible with
        | false -> Bonsai.const placeholder
        | true -> load_content graph)
      graph
    in
    
    let%sub () = setup_intersection_observer is_visible graph in
    
    content
end
```

### 6.2 Debounced Search
```ocaml
module Search = struct
  let debounced_search ~delay graph =
    let%sub search_input = Bonsai.state "" graph in
    let%sub debounced = 
      Bonsai_extra.debounce 
        search_input 
        ~delay:(Time_ns.Span.of_ms delay)
        graph
    in
    
    let%sub results = 
      Bonsai.Edge.on_change debounced
        ~callback:(fun query -> perform_search query)
        graph
    in
    
    search_input, results
end
```

### 6.3 Virtual Scrolling for Large Lists
```ocaml
module Virtual_scroll = struct
  let component ~items ~item_height ~viewport_height graph =
    let%sub scroll_top = Bonsai.state 0.0 graph in
    
    let%sub visible_range = 
      let%map scroll = scroll_top
      and item_height = item_height
      and viewport_height = viewport_height in
      let start = Int.of_float (scroll /. item_height) in
      let count = Int.of_float (viewport_height /. item_height) + 2 in
      (start, start + count)
    in
    
    let%sub visible_items = 
      let%map items = items
      and (start, end_) = visible_range in
      List.slice items start end_
    in
    
    render_virtual_list visible_items scroll_top
end
```

## 7. Testing Patterns

### 7.1 Component Testing
```ocaml
let%test_module "Portfolio Component Tests" = (module struct
  open Bonsai_web_test
  
  let%expect_test "project card hover effect" =
    let project = sample_project () in
    let handle = Handle.create 
      (Result_spec.vdom Fn.id) 
      (Project_card.component ~project ~on_click:ignore)
    in
    
    Handle.trigger_event handle ~selector:".project-card" ~event:`Mouseenter;
    Handle.show_diff handle;
    [%expect {| +class="hovering" |}];
    
    Handle.trigger_event handle ~selector:".project-card" ~event:`Mouseleave;
    Handle.show_diff handle;
    [%expect {| -class="hovering" |}]
  
  let%expect_test "contact form validation" =
    let handle = Handle.create 
      (Result_spec.vdom Fn.id) 
      Contact_form.component
    in
    
    Handle.input_text handle ~selector:"input[name=email]" ~text:"invalid";
    Handle.click_on handle ~selector:"button[type=submit]";
    Handle.show handle;
    [%expect {| <span class="error">Invalid email address</span> |}]
end)
```

### 7.2 Integration Testing with Playwright
```ocaml
(* In test files *)
let test_portfolio_navigation () =
  (* Use mcp__playwright__* tools *)
  navigate_to "http://localhost:8080";
  click_element "nav a[href='/projects']";
  wait_for_text "My Projects";
  take_screenshot "projects-page.png";
  assert_url_contains "/projects"
```

## 8. Implementation Roadmap

### Phase 1: Core Fixes (Immediate)
1. Replace polling router with Url_var
2. Remove global mutable state
3. Implement proper component return patterns

### Phase 2: UI Enhancement (Week 1)
1. Add smooth scroll and page transitions
2. Implement hover effects on project cards
3. Add responsive grid layouts
4. Create reusable animation utilities

### Phase 3: Interactive Features (Week 2)
1. Build filterable project gallery
2. Add contact form with validation
3. Implement theme switching
4. Create skills showcase component

### Phase 4: Polish (Week 3)
1. Add loading states and skeletons
2. Implement error boundaries
3. Optimize performance with lazy loading
4. Add comprehensive tests

## Key Takeaways

1. **Always use reactive patterns** - No polling, use Bonsai's reactive primitives
2. **Component composition** - Return (view, state) tuples for flexibility
3. **Type-safe styling** - Use ppx_css for maintainable styles
4. **Leverage existing libraries** - Use Bonsai_web_ui_* components
5. **Test everything** - Use Bonsai_web_test and Playwright
6. **Performance matters** - Use incremental computation and lazy loading
7. **User experience focus** - Smooth animations, responsive design, accessibility

This pattern guide provides a foundation for building a professional, performant portfolio website that showcases both the project content and OCaml/Bonsai expertise.