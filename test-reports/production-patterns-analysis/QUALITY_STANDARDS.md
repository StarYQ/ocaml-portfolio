# Bonsai Production Quality Standards

**Date**: January 22, 2025  
**Purpose**: Define quality benchmarks for production Bonsai applications  
**Scope**: Code quality, performance, UX, testing, and architectural standards

## Executive Summary

This document establishes comprehensive quality standards for production Bonsai applications, based on analysis of Jane Street's examples, community best practices, and modern web development standards. These standards serve as a checklist for ensuring portfolio projects meet professional expectations.

---

## 1. Code Quality Standards

### 1.1 Type Safety Requirements

✅ **MUST HAVE**
- 100% type coverage - no `Obj.magic` or unsafe casts
- All external data validated with typed decoders
- Explicit error types (no string errors)
- Comprehensive use of phantom types where applicable

```ocaml
(* GOOD: Type-safe error handling *)
type form_error = 
  | Email_invalid of string
  | Name_too_short of int * int  (* actual * minimum *)
  | Message_empty
  [@@deriving sexp, equal]

(* BAD: String-based errors *)
type error = string  (* Never do this *)
```

### 1.2 Module Structure Standards

✅ **Required Module Pattern**
```ocaml
module type COMPONENT = sig
  (** Public types *)
  type input
  type state  
  type action
  
  (** Component interface *)
  val component 
    : input:input Value.t
    -> (Vdom.Node.t * (action -> unit Effect.t)) Computation.t
    
  (** Testing interface *)
  module For_testing : sig
    val get_state : Handle.t -> state
    val trigger_action : Handle.t -> action -> unit
  end
end
```

### 1.3 Documentation Standards

Every module must include:
- Module-level documentation with purpose
- Function documentation with examples
- Type definitions with invariants
- Test examples in documentation

```ocaml
(** [Contact_form] provides a validated contact form component.
    
    This component handles:
    - Email validation with proper regex
    - Spam prevention via honeypot
    - Rate limiting (1 submission per minute)
    - Graceful error recovery
    
    Example:
    {[
      let%sub form = Contact_form.component graph in
      let%arr view, submit = form in
      view
    ]}
    
    @since 1.0.0
*)
```

---

## 2. Component Standards

### 2.1 Component Checklist

Every production component MUST:

- [ ] Return `(view, interface)` tuple
- [ ] Handle all error states
- [ ] Include loading states
- [ ] Support theming
- [ ] Be fully accessible
- [ ] Have comprehensive tests
- [ ] Include performance optimizations
- [ ] Document all props

### 2.2 State Management Standards

```ocaml
(* Every stateful component must handle these states *)
type 'a component_state =
  | Initial           (* Before any interaction *)
  | Loading          (* Fetching data *)
  | Loaded of 'a     (* Success state *)
  | Error of Error.t (* Error state *)
  | Refreshing of 'a (* Updating while showing old data *)
```

### 2.3 Effect Standards

All effects must:
- Be cancellable
- Include error handling
- Have timeouts where appropriate
- Be tested independently

```ocaml
let fetch_with_timeout ~timeout_ms endpoint =
  Effect.any [
    Api.fetch endpoint;
    (let%bind.Effect () = 
       Effect.Time_ns.sleep (Time_ns.Span.of_ms timeout_ms) in
     Effect.return (Error `Timeout))
  ]
```

---

## 3. Performance Standards

### 3.1 Rendering Performance

| Metric | Standard | Measurement |
|--------|----------|-------------|
| Initial render | < 100ms | Time to first paint |
| Re-render | < 16ms | Frame time |
| Bundle size | < 200KB gzipped | Production bundle |
| Memory usage | < 50MB | Chrome DevTools |

### 3.2 Required Optimizations

✅ **Must Implement**
```ocaml
(* 1. Memoization for expensive computations *)
let%sub filtered = 
  Bonsai.memo (module String) ~f:expensive_filter data

(* 2. Cutoff for preventing updates *)
let%sub stable = 
  Value.cutoff ~equal:[%equal: t] frequently_changing

(* 3. Lazy loading for heavy components *)
match%sub should_load with
| false -> Bonsai.const placeholder
| true -> Heavy_component.component graph

(* 4. Virtual lists for large datasets *)
let%sub visible_items = 
  Virtual_list.component ~items ~viewport_height
```

### 3.3 Performance Testing

```ocaml
let%test "renders large list efficiently" =
  let items = List.init 10000 ~f:(fun i -> sprintf "Item %d" i) in
  let start_time = Time_ns.now () in
  let handle = Handle.create (Result_spec.vdom Fn.id) 
    (Large_list.component ~items) in
  let render_time = Time_ns.diff (Time_ns.now ()) start_time in
  (* Must render in under 100ms *)
  assert (Time_ns.Span.to_ms render_time < 100.0)
```

---

## 4. User Experience Standards

### 4.1 Loading State Requirements

Every async operation must show:
1. Immediate feedback (< 100ms)
2. Progress indicator (> 1s)
3. Estimated time (> 3s)
4. Cancel option (> 5s)

```ocaml
module Loading_standards = struct
  let standard_loading_component ~operation graph =
    let%sub elapsed = Timer.elapsed graph in
    let%arr elapsed = elapsed in
    match Time_ns.Span.to_sec elapsed with
    | t when t < 0.1 -> Vdom.Node.none  (* No indicator yet *)
    | t when t < 1.0 -> render_spinner ()
    | t when t < 3.0 -> render_progress_bar ()
    | t when t < 5.0 -> render_with_estimate ()
    | _ -> render_with_cancel_option ()
end
```

### 4.2 Error Handling Standards

All errors must:
- Be user-friendly (no technical jargon)
- Provide recovery actions
- Be dismissible
- Log to monitoring service

```ocaml
let standard_error_handler error =
  let user_message = 
    match error with
    | Network_error -> "Connection issue. Please check your internet."
    | Server_error -> "Something went wrong. Please try again."
    | Validation_error msg -> sprintf "Please correct: %s" msg
    | _ -> "An unexpected error occurred."
  in
  let recovery_action = suggest_recovery error in
  let%bind.Effect () = Log.error error in
  let%bind.Effect () = Monitoring.report error in
  show_error_ui user_message recovery_action
```

### 4.3 Form Standards

All forms must include:
- [ ] Real-time validation
- [ ] Clear error messages
- [ ] Loading states during submission
- [ ] Success confirmation
- [ ] Prevent double submission
- [ ] Accessible labels
- [ ] Keyboard navigation

---

## 5. Accessibility Standards

### 5.1 WCAG 2.1 AA Compliance

Required for all components:

```ocaml
module Accessibility = struct
  let standards = {
    (* Color contrast *)
    text_contrast_ratio = 4.5;
    large_text_contrast_ratio = 3.0;
    
    (* Keyboard navigation *)
    all_interactive_keyboard_accessible = true;
    focus_visible = true;
    skip_links_provided = true;
    
    (* Screen readers *)
    aria_labels_complete = true;
    aria_live_regions = true;
    semantic_html = true;
    
    (* Responsive *)
    mobile_touch_targets = "44x44px minimum";
    zoom_to_200_percent = true;
  }
end
```

### 5.2 Implementation Checklist

```ocaml
let accessible_button ~label ~action =
  Vdom.Node.button
    ~attrs:[
      (* Semantic *)
      Attr.type_ "button";
      
      (* ARIA *)
      Attr.create "aria-label" label;
      Attr.create "role" "button";
      
      (* Keyboard *)
      Attr.tabindex 0;
      Attr.on_keydown (fun evt ->
        match evt##.key with
        | "Enter" | " " -> action ()
        | _ -> Effect.Ignore);
      
      (* Visual *)
      Attr.class_ "focus-visible";
      
      (* State *)
      Attr.create "aria-pressed" "false";
    ]
```

---

## 6. Testing Standards

### 6.1 Coverage Requirements

| Type | Minimum Coverage | Target |
|------|-----------------|--------|
| Unit tests | 80% | 95% |
| Integration tests | 60% | 80% |
| E2E tests | Critical paths | All paths |
| Visual regression | Key components | All components |

### 6.2 Test Structure

```ocaml
let%test_module "Component_name" = (module struct
  (* Setup *)
  let create_handle ?(input=default_input) () =
    Handle.create 
      (Result_spec.vdom Fn.id)
      (Component.component ~input)
  
  (* State tests *)
  let%expect_test "initial state" = ...
  let%expect_test "state transitions" = ...
  
  (* Interaction tests *)
  let%expect_test "user interactions" = ...
  let%expect_test "keyboard navigation" = ...
  
  (* Error tests *)
  let%expect_test "handles errors gracefully" = ...
  let%expect_test "recovery from errors" = ...
  
  (* Performance tests *)
  let%test "renders efficiently" = ...
  let%test "memoizes correctly" = ...
  
  (* Accessibility tests *)
  let%test "meets ARIA requirements" = ...
  let%test "keyboard accessible" = ...
end)
```

### 6.3 E2E Test Requirements

```ocaml
(* Required E2E test scenarios *)
module E2e_requirements = struct
  let critical_user_journeys = [
    "Navigate through all pages";
    "Submit contact form successfully";
    "Filter and view projects";
    "Handle network failures gracefully";
    "Work on mobile devices";
    "Support keyboard-only navigation";
    "Maintain state through navigation";
  ]
end
```

---

## 7. Build & Deployment Standards

### 7.1 Build Requirements

- [ ] Zero warnings in production build
- [ ] Bundle size < 200KB gzipped
- [ ] Source maps for debugging
- [ ] Tree shaking enabled
- [ ] Code splitting where appropriate

### 7.2 CI/CD Checklist

```yaml
# Required CI checks
ci_requirements:
  - name: Type checking
    command: dune build @check
    required: true
    
  - name: Unit tests
    command: dune test
    required: true
    coverage_threshold: 80%
    
  - name: Lint
    command: dune build @fmt
    required: true
    
  - name: Bundle size
    command: check_bundle_size
    max_size: 200KB
    
  - name: Performance
    command: lighthouse_ci
    performance_score: 90
    
  - name: Accessibility
    command: pa11y_ci
    standard: WCAG2AA
```

---

## 8. Security Standards

### 8.1 Client-Side Security

```ocaml
module Security = struct
  (* XSS Prevention *)
  let sanitize_user_input input =
    input
    |> String.filter ~f:(fun c -> 
         Char.is_alphanum c || Char.is_whitespace c)
    |> String.substr_replace_all ~pattern:"<" ~with_:"&lt;"
    |> String.substr_replace_all ~pattern:">" ~with_:"&gt;"
  
  (* CSRF Protection *)
  let validate_csrf_token token =
    match Session.get_csrf_token () with
    | None -> Error `No_session
    | Some expected when String.equal token expected -> Ok ()
    | Some _ -> Error `Invalid_token
  
  (* Content Security Policy *)
  let csp_headers = [
    "default-src 'self'";
    "script-src 'self' 'unsafe-inline'";  (* For Bonsai *)
    "style-src 'self' 'unsafe-inline'";   (* For ppx_css *)
    "img-src 'self' data: https:";
    "connect-src 'self'";
  ]
end
```

### 8.2 API Security

- [ ] Rate limiting on all endpoints
- [ ] Input validation before processing
- [ ] Sanitize all user content
- [ ] Use HTTPS only
- [ ] Implement CORS properly

---

## 9. Monitoring Standards

### 9.1 Required Metrics

```ocaml
module Monitoring = struct
  type metrics = {
    (* Performance *)
    page_load_time: Time_ns.Span.t;
    time_to_interactive: Time_ns.Span.t;
    bundle_parse_time: Time_ns.Span.t;
    
    (* Errors *)
    js_errors: int;
    failed_requests: int;
    
    (* User metrics *)
    bounce_rate: Percent.t;
    session_duration: Time_ns.Span.t;
    
    (* Business metrics *)
    form_submissions: int;
    conversion_rate: Percent.t;
  }
  
  let track_metric metric value =
    Analytics.track ~event:metric ~value
end
```

### 9.2 Error Tracking

All production apps must:
- Log errors to centralized service
- Include stack traces
- Capture user context
- Alert on error spikes

---

## 10. Documentation Standards

### 10.1 Required Documentation

- [ ] README with setup instructions
- [ ] Architecture decision records (ADRs)
- [ ] Component documentation
- [ ] API documentation
- [ ] Deployment guide
- [ ] Performance benchmarks
- [ ] Accessibility audit results

### 10.2 Code Documentation Template

```ocaml
(** [module_name] brief description.
    
    Detailed description of purpose and usage.
    
    {2 Features}
    - Feature 1
    - Feature 2
    
    {2 Example}
    {[
      let example = ...
    ]}
    
    {2 Performance}
    O(n) complexity where n is...
    
    {2 Testing}
    See tests in test/test_module_name.ml
    
    @since version
    @deprecated Use [other_module] instead
*)
```

---

## Quality Checklist Summary

### Pre-Production Checklist

**Code Quality**
- [ ] 100% type coverage
- [ ] Zero compiler warnings
- [ ] All functions documented
- [ ] Module interfaces defined

**Performance**
- [ ] < 100ms initial render
- [ ] < 200KB bundle size
- [ ] Memoization implemented
- [ ] Virtual scrolling for lists

**User Experience**
- [ ] Loading states for all async
- [ ] Error recovery paths
- [ ] Mobile responsive
- [ ] Offline capability

**Testing**
- [ ] 80%+ test coverage
- [ ] E2E tests for critical paths
- [ ] Performance benchmarks
- [ ] Accessibility audit passed

**Security**
- [ ] Input sanitization
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Rate limiting

**Monitoring**
- [ ] Error tracking configured
- [ ] Performance monitoring
- [ ] Analytics integrated
- [ ] Alerting setup

---

## Conclusion

These quality standards represent the minimum bar for production Bonsai applications. Meeting these standards ensures that portfolio projects demonstrate not just technical capability, but also professional software engineering practices.

Every standard listed here is achievable with current Bonsai tooling and should be considered mandatory for any application intended for production use or portfolio demonstration.

**Remember**: Quality is not negotiable in production software.