# Animation Implementation Guide for OCaml Portfolio

**Date**: January 22, 2025  
**Purpose**: Step-by-step guide for implementing animations in the existing portfolio

## Quick Start

### 1. Add Animation Module to Your Project

Create `lib/client/components/Animations.ml`:

```ocaml
open! Core
open Bonsai_web
open Virtual_dom

(* Core animation styles using ppx_css *)
module Styles = [%css stylesheet {|
  /* Entrance animations */
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }
  
  .fade-in {
    animation: fadeIn 0.6s ease-out forwards;
  }
  
  /* Hover effects */
  .hover-lift {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  
  .hover-lift:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(0,0,0,0.15);
  }
  
  /* Accessibility */
  @media (prefers-reduced-motion: reduce) {
    * {
      animation: none !important;
      transition: none !important;
    }
  }
|}]
```

### 2. Update Dune File

Add ppx_css to `lib/client/components/dune`:

```dune
(library
 (name components)
 (libraries 
   bonsai
   bonsai.web
   virtual_dom
   ppx_css)
 (preprocess (pps ppx_jane ppx_css bonsai.ppx_bonsai)))
```

---

## Integration Examples

### Example 1: Animate Existing Home Page

Update `lib/client/pages/page_home.ml`:

```ocaml
open! Core
open Bonsai_web
open Bonsai.Let_syntax

module Styles = [%css stylesheet {|
  @keyframes heroReveal {
    from {
      opacity: 0;
      transform: translateY(30px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  .hero-title {
    animation: heroReveal 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }
  
  .hero-subtitle {
    opacity: 0;
    animation: heroReveal 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.2s forwards;
  }
  
  .cta-button {
    opacity: 0;
    animation: heroReveal 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.4s forwards;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  
  .cta-button:hover {
    transform: scale(1.05);
    box-shadow: 0 5px 15px rgba(0,122,255,0.3);
  }
|}]

let component () =
  Bonsai.const (
    Vdom.Node.div
      [
        Vdom.Node.h1
          ~attrs:[Vdom.Attr.class_ Styles.hero_title]
          [Vdom.Node.text "OCaml Developer"];
        Vdom.Node.p
          ~attrs:[Vdom.Attr.class_ Styles.hero_subtitle]
          [Vdom.Node.text "Building type-safe, functional web applications"];
        Vdom.Node.button
          ~attrs:[Vdom.Attr.class_ Styles.cta_button]
          [Vdom.Node.text "View Projects"]
      ]
  )
```

### Example 2: Animate Project Cards

Update `lib/client/pages/page_projects_simple.ml`:

```ocaml
module Styles = [%css stylesheet {|
  @keyframes cardReveal {
    from {
      opacity: 0;
      transform: translateY(40px) scale(0.95);
    }
    to {
      opacity: 1;
      transform: translateY(0) scale(1);
    }
  }
  
  .project-card {
    opacity: 0;
    animation: cardReveal 0.6s ease-out forwards;
    animation-delay: calc(var(--index) * 150ms);
    transition: all 0.3s ease;
    cursor: pointer;
  }
  
  .project-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 20px 40px rgba(0,0,0,0.12);
  }
  
  /* Shimmer effect on hover */
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
      rgba(255,255,255,0.2),
      transparent
    );
    transition: left 0.7s;
  }
  
  .project-card:hover::before {
    left: 100%;
  }
|}]

let project_card (title, description, technologies) index =
  Vdom.Node.div
    ~attrs:[
      Vdom.Attr.class_ Styles.project_card;
      Vdom.Attr.style (
        Css_gen.create ~field:"--index" ~value:(Int.to_string index)
      );
      Vdom.Attr.style (Css_gen.position `Relative);
      Vdom.Attr.style (Css_gen.overflow `Hidden)
    ]
    [
      Vdom.Node.h3 [Vdom.Node.text title];
      Vdom.Node.p [Vdom.Node.text description];
      (* Rest of card content *)
    ]
```

### Example 3: Add Loading States

Create `lib/client/components/Loading.ml`:

```ocaml
module Styles = [%css stylesheet {|
  @keyframes spin {
    to { transform: rotate(360deg); }
  }
  
  @keyframes pulse {
    0%, 100% { opacity: 0.6; }
    50% { opacity: 1; }
  }
  
  @keyframes shimmer {
    0% { background-position: -200% 0; }
    100% { background-position: 200% 0; }
  }
  
  .spinner {
    width: 40px;
    height: 40px;
    border: 3px solid #f0f0f0;
    border-top-color: #007AFF;
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }
  
  .skeleton {
    background: linear-gradient(
      90deg,
      #f0f0f0 25%,
      #e8e8e8 50%,
      #f0f0f0 75%
    );
    background-size: 200% 100%;
    animation: shimmer 1.5s infinite;
    border-radius: 4px;
  }
  
  .dots {
    display: inline-block;
  }
  
  .dots::after {
    content: '...';
    animation: pulse 1.5s infinite;
  }
|}]

let spinner () =
  Vdom.Node.div
    ~attrs:[Vdom.Attr.class_ Styles.spinner]
    []

let skeleton ~width ~height =
  Vdom.Node.div
    ~attrs:[
      Vdom.Attr.class_ Styles.skeleton;
      Vdom.Attr.style (
        Css_gen.concat [
          Css_gen.width width;
          Css_gen.height height
        ]
      )
    ]
    []

let loading_text text =
  Vdom.Node.span
    [
      Vdom.Node.text text;
      Vdom.Node.span ~attrs:[Vdom.Attr.class_ Styles.dots] []
    ]
```

---

## State-Driven Animations

### Managing Animation States

```ocaml
(* lib/client/components/AnimationState.ml *)

type state = 
  | Idle
  | Entering
  | Active
  | Exiting
[@@deriving equal, sexp]

let create_animated_component content =
  let%sub animation_state = Bonsai.state Idle in
  let%sub () = 
    (* Trigger enter animation on mount *)
    Bonsai.Edge.on_mount (
      let%arr _, set_state = animation_state in
      set_state Entering
    )
  in
  
  let%arr state, set_state = animation_state
  and content = content in
  
  let animation_class = 
    match state with
    | Idle -> ""
    | Entering -> Styles.fade_in
    | Active -> Styles.active
    | Exiting -> Styles.fade_out
  in
  
  Vdom.Node.div
    ~attrs:[
      Vdom.Attr.class_ animation_class;
      Vdom.Attr.on "animationend" (fun _ ->
        match state with
        | Entering -> set_state Active
        | Exiting -> set_state Idle
        | _ -> Effect.Ignore
      )
    ]
    [content]
```

---

## Scroll-Based Animations

### Intersection Observer Integration

```ocaml
(* lib/client/components/ScrollReveal.ml *)

let use_scroll_reveal element_id =
  let%sub is_visible = Bonsai.state false in
  
  let%sub () = 
    Bonsai.Edge.on_mount (
      let%arr _, set_visible = is_visible in
      Effect.of_sync_fun (fun () ->
        (* Set up IntersectionObserver *)
        let callback entries _ =
          Js_of_ocaml.Js.array_iter (fun entry ->
            if Js_of_ocaml.Js.Unsafe.get entry "isIntersecting" 
               |> Js_of_ocaml.Js.to_bool then
              Effect.Expert.handle (set_visible true)
          ) entries
        in
        let observer = 
          Js_of_ocaml.Js.Unsafe.new_obj 
            (Js_of_ocaml.Js.Unsafe.global##.IntersectionObserver)
            [| Js_of_ocaml.Js.wrap_callback callback;
               Js_of_ocaml.Js.Unsafe.obj [|
                 ("threshold", Js_of_ocaml.Js.Unsafe.inject 0.1)
               |]
            |]
        in
        let element = 
          Js_of_ocaml.Dom_html.getElementById element_id in
        Js_of_ocaml.Js.Unsafe.meth_call observer "observe" 
          [| Js_of_ocaml.Js.Unsafe.inject element |]
      ) ()
    )
  in
  
  is_visible
```

---

## Performance Tips

### 1. Use CSS Transform & Opacity

```ocaml
module PerformantStyles = [%css stylesheet {|
  /* Good - GPU accelerated */
  .good-animation {
    transform: translateX(100px);
    opacity: 0.5;
  }
  
  /* Bad - triggers layout */
  .bad-animation {
    left: 100px;
    width: 200px;
  }
  
  /* Force GPU layer */
  .gpu-layer {
    will-change: transform;
    transform: translateZ(0);
  }
|}]
```

### 2. Debounce Scroll Handlers

```ocaml
let debounced_scroll_handler =
  let%sub last_call = Bonsai.state None in
  let%arr last_call, set_last_call = last_call in
  fun event ->
    match last_call with
    | Some time when Time_ns.diff (Time_ns.now ()) time 
                     < Time_ns.Span.of_ms 16. ->
        Effect.Ignore
    | _ ->
        Effect.Many [
          handle_scroll event;
          set_last_call (Some (Time_ns.now ()))
        ]
```

### 3. Use CSS Containment

```ocaml
module ContainmentStyles = [%css stylesheet {|
  .animation-container {
    contain: layout style paint;
  }
  
  .heavy-animation {
    contain: strict;
  }
|}]
```

---

## Accessibility Implementation

### 1. Respect User Preferences

```ocaml
module AccessibleAnimations = [%css stylesheet {|
  /* Normal animations */
  .animated {
    animation: slideIn 0.5s ease;
    transition: all 0.3s ease;
  }
  
  /* Reduced motion fallback */
  @media (prefers-reduced-motion: reduce) {
    .animated {
      animation: none !important;
      transition: opacity 0.01ms !important;
    }
  }
  
  /* High contrast mode */
  @media (prefers-contrast: high) {
    .subtle-shadow {
      box-shadow: none;
      border: 2px solid currentColor;
    }
  }
|}]
```

### 2. Animation Toggle Component

```ocaml
let animation_preferences =
  let%sub enabled = 
    Bonsai.state ~default_model:true in
  
  let%arr enabled, set_enabled = enabled in
  Vdom.Node.div
    ~attrs:[Vdom.Attr.class_ "animation-controls"]
    [
      Vdom.Node.label
        [
          Vdom.Node.input
            ~attrs:[
              Vdom.Attr.type_ "checkbox";
              Vdom.Attr.checked enabled;
              Vdom.Attr.on_change (fun _ ->
                set_enabled (not enabled)
              );
              Vdom.Attr.(
                @ aria "label" "Enable animations"
                @ role "switch"
              )
            ]
            [];
          Vdom.Node.text " Enable animations"
        ]
    ]
```

---

## Testing Animations

### Browser Testing with Playwright

```ocaml
(* test/test_animations.ml *)

let test_project_card_animation () =
  (* Navigate to projects page *)
  mcp__playwright__browser_navigate "/projects";
  
  (* Wait for animation to complete *)
  mcp__playwright__browser_wait_for ~time:1.0;
  
  (* Take screenshot *)
  mcp__playwright__browser_take_screenshot 
    ~filename:"project-cards-animated.png"
    ~fullPage:true;
  
  (* Test hover effect *)
  mcp__playwright__browser_hover
    ~element:"First project card"
    ~ref:".project-card:first-child";
  
  (* Verify transform applied *)
  mcp__playwright__browser_evaluate
    ~element:"First project card"
    ~ref:".project-card:first-child"
    ~function:"(el) => getComputedStyle(el).transform"
```

---

## Common Patterns

### 1. Staggered List Animation

```ocaml
let staggered_list items =
  List.mapi items ~f:(fun index item ->
    Vdom.Node.div
      ~attrs:[
        Vdom.Attr.class_ Styles.stagger_item;
        Vdom.Attr.style (
          Css_gen.animation_delay (`Ms (index * 100))
        )
      ]
      [render_item item]
  )
```

### 2. Typewriter Effect

```ocaml
module TypewriterStyles = [%css stylesheet {|
  @keyframes typing {
    from { width: 0; }
    to { width: 100%; }
  }
  
  @keyframes blink {
    50% { border-color: transparent; }
  }
  
  .typewriter {
    overflow: hidden;
    white-space: nowrap;
    border-right: 3px solid;
    animation: 
      typing 3s steps(30),
      blink 0.75s step-end infinite;
  }
|}]
```

### 3. Ripple Effect

```ocaml
module RippleStyles = [%css stylesheet {|
  @keyframes ripple {
    to {
      transform: scale(4);
      opacity: 0;
    }
  }
  
  .ripple {
    position: absolute;
    border-radius: 50%;
    background: rgba(255,255,255,0.5);
    transform: scale(0);
    animation: ripple 0.6s ease-out;
  }
|}]
```

---

## Migration Checklist

- [ ] Add ppx_css to dependencies
- [ ] Create animation module
- [ ] Update page components with animations
- [ ] Add loading states
- [ ] Implement accessibility features
- [ ] Test with reduced motion preference
- [ ] Verify 60fps performance
- [ ] Test on mobile devices
- [ ] Document animation patterns used

---

## Resources

- [ppx_css Documentation](https://github.com/janestreet/ppx_css)
- [MDN Animation Guide](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Animations)
- [Web.dev Performance](https://web.dev/animations-guide)
- [WCAG Animation Guidelines](https://www.w3.org/WAI/WCAG21/Understanding/animation-from-interactions)