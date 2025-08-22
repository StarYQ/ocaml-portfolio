(* Animation Implementation Examples for OCaml/Bonsai Portfolio *)
(* This file provides ready-to-use animation patterns *)

open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom

(* ========================================================================= *)
(* 1. Core Animation Styles Module *)
(* ========================================================================= *)

module CoreAnimations = [%css stylesheet {|
  /* === Entrance Animations === */
  @keyframes fadeIn {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  @keyframes slideInLeft {
    from {
      opacity: 0;
      transform: translateX(-30px);
    }
    to {
      opacity: 1;
      transform: translateX(0);
    }
  }
  
  @keyframes slideInRight {
    from {
      opacity: 0;
      transform: translateX(30px);
    }
    to {
      opacity: 1;
      transform: translateX(0);
    }
  }
  
  @keyframes scaleIn {
    from {
      opacity: 0;
      transform: scale(0.95);
    }
    to {
      opacity: 1;
      transform: scale(1);
    }
  }
  
  /* === Loading Animations === */
  @keyframes spin {
    to { transform: rotate(360deg); }
  }
  
  @keyframes pulse {
    0%, 100% {
      opacity: 0.6;
    }
    50% {
      opacity: 1;
    }
  }
  
  @keyframes shimmer {
    0% {
      background-position: -200% 0;
    }
    100% {
      background-position: 200% 0;
    }
  }
  
  /* === Interactive Animations === */
  @keyframes bounce {
    0%, 100% {
      transform: translateY(0);
    }
    50% {
      transform: translateY(-10px);
    }
  }
  
  @keyframes shake {
    0%, 100% { transform: translateX(0); }
    25% { transform: translateX(-5px); }
    75% { transform: translateX(5px); }
  }
  
  /* === Base Classes === */
  .fade-in {
    animation: fadeIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }
  
  .slide-in-left {
    animation: slideInLeft 0.5s ease-out forwards;
  }
  
  .slide-in-right {
    animation: slideInRight 0.5s ease-out forwards;
  }
  
  .scale-in {
    animation: scaleIn 0.4s ease-out forwards;
  }
  
  .spinner {
    animation: spin 1s linear infinite;
  }
  
  .pulse {
    animation: pulse 2s ease-in-out infinite;
  }
  
  .skeleton-loader {
    background: linear-gradient(
      90deg,
      #f0f0f0 25%,
      #e8e8e8 50%,
      #f0f0f0 75%
    );
    background-size: 200% 100%;
    animation: shimmer 1.5s infinite;
  }
  
  /* === Staggered Animations === */
  .stagger-item {
    opacity: 0;
    animation: fadeIn 0.5s ease-out forwards;
    animation-delay: calc(var(--index, 0) * 100ms);
  }
  
  /* === Hover Effects === */
  .hover-lift {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    cursor: pointer;
  }
  
  .hover-lift:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
  }
  
  .hover-scale {
    transition: transform 0.2s ease;
    cursor: pointer;
  }
  
  .hover-scale:hover {
    transform: scale(1.05);
  }
  
  .hover-glow {
    transition: box-shadow 0.3s ease;
    cursor: pointer;
  }
  
  .hover-glow:hover {
    box-shadow: 0 0 20px rgba(0, 122, 255, 0.3);
  }
  
  /* === Page Transitions === */
  @keyframes pageEnter {
    from {
      opacity: 0;
      transform: translateX(20px);
    }
    to {
      opacity: 1;
      transform: translateX(0);
    }
  }
  
  @keyframes pageExit {
    from {
      opacity: 1;
      transform: translateX(0);
    }
    to {
      opacity: 0;
      transform: translateX(-20px);
    }
  }
  
  .page-enter {
    animation: pageEnter 0.4s ease forwards;
  }
  
  .page-exit {
    animation: pageExit 0.3s ease forwards;
  }
  
  /* === Accessibility === */
  @media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
      animation-duration: 0.01ms !important;
      animation-iteration-count: 1 !important;
      transition-duration: 0.01ms !important;
      scroll-behavior: auto !important;
    }
    
    .fade-in,
    .slide-in-left,
    .slide-in-right,
    .scale-in,
    .stagger-item {
      opacity: 1 !important;
      transform: none !important;
      animation: none !important;
    }
  }
|}]

(* ========================================================================= *)
(* 2. Portfolio-Specific Animation Styles *)
(* ========================================================================= *)

module PortfolioAnimations = [%css stylesheet {|
  /* === Hero Section === */
  @keyframes heroTitleReveal {
    0% {
      opacity: 0;
      transform: translateY(30px);
      filter: blur(10px);
    }
    100% {
      opacity: 1;
      transform: translateY(0);
      filter: blur(0);
    }
  }
  
  @keyframes heroSubtitleReveal {
    0% {
      opacity: 0;
      transform: translateY(20px);
    }
    100% {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  @keyframes typewriter {
    from {
      width: 0;
    }
    to {
      width: 100%;
    }
  }
  
  @keyframes blinkCursor {
    50% {
      border-color: transparent;
    }
  }
  
  .hero-title {
    animation: heroTitleReveal 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }
  
  .hero-subtitle {
    opacity: 0;
    animation: heroSubtitleReveal 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.3s forwards;
  }
  
  .typewriter-text {
    overflow: hidden;
    white-space: nowrap;
    border-right: 3px solid #007AFF;
    animation: 
      typewriter 2s steps(30) 1s forwards,
      blinkCursor 0.75s step-end infinite;
  }
  
  /* === Project Cards === */
  @keyframes projectCardReveal {
    from {
      opacity: 0;
      transform: translateY(50px) scale(0.95);
    }
    to {
      opacity: 1;
      transform: translateY(0) scale(1);
    }
  }
  
  .project-card {
    opacity: 0;
    animation: projectCardReveal 0.6s ease-out forwards;
    animation-delay: calc(var(--index) * 150ms);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
  }
  
  .project-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(
      90deg,
      transparent,
      rgba(255, 255, 255, 0.3),
      transparent
    );
    transition: left 0.6s ease;
  }
  
  .project-card:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
  }
  
  .project-card:hover::before {
    left: 100%;
  }
  
  /* === Skills Section === */
  @keyframes skillBarFill {
    from {
      width: 0;
    }
    to {
      width: var(--skill-level);
    }
  }
  
  @keyframes skillGlow {
    0%, 100% {
      box-shadow: 0 0 5px rgba(0, 122, 255, 0.5);
    }
    50% {
      box-shadow: 0 0 20px rgba(0, 122, 255, 0.8);
    }
  }
  
  .skill-bar {
    position: relative;
    height: 8px;
    background: #f0f0f0;
    border-radius: 4px;
    overflow: hidden;
  }
  
  .skill-progress {
    height: 100%;
    background: linear-gradient(90deg, #007AFF, #00D4FF);
    animation: 
      skillBarFill 1.5s ease-out forwards,
      skillGlow 2s ease-in-out infinite;
    animation-delay: calc(var(--index) * 200ms);
  }
  
  /* === Contact Form === */
  @keyframes formFieldFocus {
    from {
      box-shadow: 0 0 0 0 rgba(0, 122, 255, 0.2);
    }
    to {
      box-shadow: 0 0 0 4px rgba(0, 122, 255, 0.2);
    }
  }
  
  .form-field {
    transition: all 0.3s ease;
  }
  
  .form-field:focus {
    animation: formFieldFocus 0.3s ease forwards;
    border-color: #007AFF;
  }
  
  .submit-button {
    position: relative;
    overflow: hidden;
    transition: all 0.3s ease;
  }
  
  .submit-button::after {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 0;
    height: 0;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.5);
    transform: translate(-50%, -50%);
    transition: width 0.6s, height 0.6s;
  }
  
  .submit-button:active::after {
    width: 300px;
    height: 300px;
  }
  
  /* === Navigation === */
  @keyframes navLinkUnderline {
    from {
      width: 0;
      opacity: 0;
    }
    to {
      width: 100%;
      opacity: 1;
    }
  }
  
  .nav-link {
    position: relative;
    transition: color 0.3s ease;
  }
  
  .nav-link::after {
    content: '';
    position: absolute;
    bottom: -3px;
    left: 0;
    width: 0;
    height: 2px;
    background: linear-gradient(90deg, #007AFF, #00D4FF);
    transition: width 0.3s ease;
  }
  
  .nav-link:hover::after,
  .nav-link.active::after {
    width: 100%;
  }
|}]

(* ========================================================================= *)
(* 3. Animation Helper Functions *)
(* ========================================================================= *)

module AnimationHelpers = struct
  (* Create staggered animation delays *)
  let stagger_delay ~base_delay ~increment index =
    Css_gen.animation_delay (`Ms (base_delay + (increment * index)))
  
  (* Create CSS variable for animation *)
  let css_var name value =
    Css_gen.create ~field:(sprintf "--%s" name) ~value
  
  (* Combine multiple animation classes *)
  let combine_classes classes =
    Vdom.Attr.classes (List.filter_opt classes)
  
  (* Animation duration helper *)
  let duration_ms ms =
    Css_gen.animation_duration (`Ms ms)
  
  (* Animation timing function *)
  let timing_function = function
    | `Ease -> Css_gen.animation_timing_function "ease"
    | `EaseIn -> Css_gen.animation_timing_function "ease-in"
    | `EaseOut -> Css_gen.animation_timing_function "ease-out"
    | `EaseInOut -> Css_gen.animation_timing_function "ease-in-out"
    | `Linear -> Css_gen.animation_timing_function "linear"
    | `CubicBezier (x1, y1, x2, y2) ->
        Css_gen.animation_timing_function 
          (sprintf "cubic-bezier(%f, %f, %f, %f)" x1 y1 x2 y2)
end

(* ========================================================================= *)
(* 4. Animated Components *)
(* ========================================================================= *)

module AnimatedComponents = struct
  
  (* Fade in component with customizable delay *)
  let fade_in_component ?(delay_ms = 0) content =
    let%arr content = content in
    Vdom.Node.div
      ~attrs:[
        Vdom.Attr.class_ CoreAnimations.fade_in;
        Vdom.Attr.style (
          if delay_ms > 0 then
            AnimationHelpers.stagger_delay ~base_delay:0 ~increment:0 delay_ms
          else Css_gen.empty
        )
      ]
      [content]
  
  (* Loading spinner component *)
  let loading_spinner ?(size = 24) () =
    Bonsai.const (
      Vdom.Node.div
        ~attrs:[
          Vdom.Attr.class_ CoreAnimations.spinner;
          Vdom.Attr.style (
            Css_gen.concat [
              Css_gen.width (`Px size);
              Css_gen.height (`Px size);
              Css_gen.border ~style:`Solid ~color:(`Name "transparent") ~width:(`Px 2) ();
              Css_gen.border_top ~style:`Solid ~color:(`Hex "#007AFF") ~width:(`Px 2) ();
              Css_gen.border_radius (`Percent 50)
            ]
          )
        ]
        []
    )
  
  (* Skeleton loader component *)
  let skeleton_loader ~width ~height () =
    Bonsai.const (
      Vdom.Node.div
        ~attrs:[
          Vdom.Attr.class_ CoreAnimations.skeleton_loader;
          Vdom.Attr.style (
            Css_gen.concat [
              width;
              height;
              Css_gen.border_radius (`Px 4)
            ]
          )
        ]
        []
    )
  
  (* Animated list with staggered items *)
  let staggered_list items ~render_item =
    let%arr items = items in
    List.mapi items ~f:(fun index item ->
      Vdom.Node.div
        ~attrs:[
          Vdom.Attr.class_ CoreAnimations.stagger_item;
          Vdom.Attr.style (
            AnimationHelpers.css_var "index" (Int.to_string index)
          )
        ]
        [render_item item]
    )
  
  (* Project card with hover effects *)
  let project_card ~title ~description ~index =
    let%arr title = title
    and description = description
    and index = index in
    Vdom.Node.div
      ~attrs:[
        Vdom.Attr.classes [
          PortfolioAnimations.project_card;
          CoreAnimations.hover_lift
        ];
        Vdom.Attr.style (
          AnimationHelpers.css_var "index" (Int.to_string index)
        )
      ]
      [
        Vdom.Node.h3 [Vdom.Node.text title];
        Vdom.Node.p [Vdom.Node.text description]
      ]
  
  (* Animated skill bar *)
  let skill_bar ~skill ~level ~index =
    let%arr skill = skill
    and level = level
    and index = index in
    Vdom.Node.div
      ~attrs:[Vdom.Attr.class_ PortfolioAnimations.skill_bar]
      [
        Vdom.Node.div
          ~attrs:[
            Vdom.Attr.class_ PortfolioAnimations.skill_progress;
            Vdom.Attr.style (
              Css_gen.concat [
                AnimationHelpers.css_var "skill-level" (sprintf "%d%%" level);
                AnimationHelpers.css_var "index" (Int.to_string index)
              ]
            )
          ]
          []
      ]
  
  (* Page transition wrapper *)
  let page_transition_wrapper ~entering content =
    let%arr entering = entering
    and content = content in
    Vdom.Node.div
      ~attrs:[
        Vdom.Attr.class_ (
          if entering then CoreAnimations.page_enter
          else CoreAnimations.page_exit
        )
      ]
      [content]
  
  (* Hero section with animated text *)
  let hero_section ~title ~subtitle =
    let%arr title = title
    and subtitle = subtitle in
    Vdom.Node.section
      [
        Vdom.Node.h1
          ~attrs:[Vdom.Attr.class_ PortfolioAnimations.hero_title]
          [Vdom.Node.text title];
        Vdom.Node.p
          ~attrs:[Vdom.Attr.class_ PortfolioAnimations.hero_subtitle]
          [Vdom.Node.text subtitle]
      ]
  
  (* Interactive button with ripple effect *)
  let ripple_button ~label ~on_click =
    let%sub rippling = Bonsai.state false in
    let%arr label = label
    and on_click = on_click
    and rippling, set_rippling = rippling in
    Vdom.Node.button
      ~attrs:[
        Vdom.Attr.class_ PortfolioAnimations.submit_button;
        Vdom.Attr.on_click (fun _ ->
          Effect.Many [
            set_rippling true;
            Effect.of_sync_fun (fun () ->
              Async_js.init ();
              don't_wait_for (
                let%bind () = Async_js.sleep 0.6 in
                Effect.Expert.handle (set_rippling false);
                return ()
              )
            ) ();
            on_click
          ]
        )
      ]
      [Vdom.Node.text label]
end

(* ========================================================================= *)
(* 5. Animation State Management *)
(* ========================================================================= *)

module AnimationState = struct
  type animation_state = 
    | Idle
    | Entering
    | Active  
    | Exiting
    | Complete
  [@@deriving equal, sexp]
  
  let animation_machine =
    let%sub state = Bonsai.state_machine0 
      ~default_model:Idle
      ~apply_action:(fun _ model action ->
        match action with
        | `Start -> Entering
        | `Activate -> Active
        | `Exit -> Exiting
        | `Complete -> Complete
        | `Reset -> Idle
      ) in
    state
  
  (* Visibility detector for scroll animations *)
  let visibility_detector element_id =
    let%sub is_visible = Bonsai.state false in
    let%sub check_visibility = 
      let%arr is_visible, set_visible = is_visible in
      fun () ->
        (* This would use IntersectionObserver in real implementation *)
        (* For now, simplified version *)
        set_visible true
    in
    is_visible
end

(* ========================================================================= *)
(* 6. Accessibility Helpers *)
(* ========================================================================= *)

module AccessibilityHelpers = struct
  (* Check if user prefers reduced motion *)
  let prefers_reduced_motion () =
    Js_of_ocaml.Js.Unsafe.js_expr 
      "window.matchMedia('(prefers-reduced-motion: reduce)').matches"
    |> Js_of_ocaml.Js.to_bool
  
  (* Animation toggle component *)
  let animation_toggle =
    let%sub enabled = 
      Bonsai.state ~default_model:(not (prefers_reduced_motion ())) in
    let%arr enabled, set_enabled = enabled in
    Vdom.Node.button
      ~attrs:[
        Vdom.Attr.on_click (fun _ -> set_enabled (not enabled));
        Vdom.Attr.(
          @ aria "label" "Toggle animations"
          @ aria "pressed" (Bool.to_string enabled)
          @ role "switch"
        )
      ]
      [
        Vdom.Node.text (
          if enabled then "Animations: On" else "Animations: Off"
        )
      ]
end

(* ========================================================================= *)
(* 7. Example Usage *)
(* ========================================================================= *)

module ExampleUsage = struct
  open AnimatedComponents
  
  let example_portfolio_page =
    let%sub projects = Bonsai.const [
      ("Project 1", "Description 1");
      ("Project 2", "Description 2");
      ("Project 3", "Description 3")
    ] in
    
    let%sub skills = Bonsai.const [
      ("OCaml", 95);
      ("Bonsai", 90);
      ("Dream", 85);
      ("ppx_css", 88)
    ] in
    
    let%arr projects = projects
    and skills = skills in
    
    Vdom.Node.div
      [
        (* Hero section *)
        Vdom.Node.div
          ~attrs:[Vdom.Attr.class_ PortfolioAnimations.hero_title]
          [Vdom.Node.text "Welcome to My Portfolio"];
        
        (* Projects section with staggered cards *)
        Vdom.Node.section
          [
            Vdom.Node.h2 [Vdom.Node.text "Projects"];
            Vdom.Node.div
              (List.mapi projects ~f:(fun index (title, desc) ->
                Vdom.Node.div
                  ~attrs:[
                    Vdom.Attr.classes [
                      PortfolioAnimations.project_card;
                      CoreAnimations.hover_lift
                    ];
                    Vdom.Attr.style (
                      AnimationHelpers.css_var "index" (Int.to_string index)
                    )
                  ]
                  [
                    Vdom.Node.h3 [Vdom.Node.text title];
                    Vdom.Node.p [Vdom.Node.text desc]
                  ]
              ))
          ];
        
        (* Skills section with animated bars *)
        Vdom.Node.section
          [
            Vdom.Node.h2 [Vdom.Node.text "Skills"];
            Vdom.Node.div
              (List.mapi skills ~f:(fun index (skill, level) ->
                Vdom.Node.div
                  [
                    Vdom.Node.label [Vdom.Node.text skill];
                    Vdom.Node.div
                      ~attrs:[Vdom.Attr.class_ PortfolioAnimations.skill_bar]
                      [
                        Vdom.Node.div
                          ~attrs:[
                            Vdom.Attr.class_ PortfolioAnimations.skill_progress;
                            Vdom.Attr.style (
                              Css_gen.concat [
                                AnimationHelpers.css_var "skill-level" 
                                  (sprintf "%d%%" level);
                                AnimationHelpers.css_var "index" 
                                  (Int.to_string index)
                              ]
                            )
                          ]
                          []
                      ]
                  ]
              ))
          ]
      ]
end