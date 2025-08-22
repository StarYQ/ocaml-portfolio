# Comprehensive Testing Strategy for Bonsai Portfolio Applications

**Date**: January 22, 2025  
**Project**: OCaml Portfolio with Bonsai Web  
**Scope**: Complete testing framework and strategies for portfolio applications

## Executive Summary

This document outlines a comprehensive testing strategy for Bonsai portfolio applications, covering unit testing with `bonsai_web_test`, integration testing with Playwright, visual regression testing, and CI/CD integration. The strategy ensures portfolio quality through systematic testing of components, navigation, forms, and visual presentation.

## 1. Testing Framework Overview

### 1.1 Core Testing Tools

| Tool | Purpose | Usage |
|------|---------|-------|
| **bonsai_web_test** | Unit testing Bonsai components | Component behavior, state management |
| **Playwright MCP** | E2E and visual testing | UI interactions, screenshots |
| **ppx_expect** | Snapshot testing | Expected output validation |
| **ppx_inline_test** | Inline unit tests | Quick component verification |
| **dune test** | Test runner | Execute all test suites |

### 1.2 Testing Architecture

```
test/
├── unit/                  # Unit tests for components
│   ├── components/       # Individual component tests
│   ├── pages/           # Page component tests
│   └── shared/          # Shared logic tests
├── integration/          # Integration tests
│   ├── navigation/      # Navigation flow tests
│   ├── forms/          # Form submission tests
│   └── api/            # API endpoint tests
├── visual/              # Visual regression tests
│   ├── screenshots/    # Reference screenshots
│   └── diffs/         # Visual differences
└── fixtures/           # Test data and mocks
```

## 2. Component Testing Strategy

### 2.1 Unit Testing with bonsai_web_test

#### Test Structure Pattern
```ocaml
open! Core
open Bonsai_web_test

let%test_module "Component_name tests" = (module struct
  (* Test setup *)
  let create_handle ?(initial_props = default_props) () =
    Handle.create 
      (Result_spec.vdom Fn.id)
      (Component_name.component initial_props)
  
  (* State management tests *)
  let%expect_test "initial state" =
    let handle = create_handle () in
    Handle.show handle;
    [%expect {| <expected initial DOM> |}]
  
  (* Interaction tests *)
  let%expect_test "user interaction" =
    let handle = create_handle () in
    Handle.click_on handle ~selector:".button";
    Handle.show_diff handle;
    [%expect {| +class="active" |}]
  
  (* Props validation *)
  let%expect_test "prop changes" =
    let handle = create_handle ~initial_props:special_props () in
    Handle.show handle;
    [%expect {| <expected DOM with special props> |}]
end)
```

#### Component Test Coverage Areas

1. **State Management**
   - Initial state rendering
   - State transitions
   - Effect handling
   - Cleanup on unmount

2. **User Interactions**
   - Click events
   - Form inputs
   - Keyboard navigation
   - Mouse hover/leave

3. **Props and Data Flow**
   - Required props validation
   - Optional props defaults
   - Prop type checking
   - Child component communication

4. **Error Handling**
   - Invalid input handling
   - Network error simulation
   - Loading states
   - Error boundaries

### 2.2 Testing Patterns for Common Components

#### Navigation Component Testing
```ocaml
let%test_module "Navigation tests" = (module struct
  open Bonsai_web_test
  
  let%expect_test "active link highlighting" =
    let handle = Handle.create 
      (Result_spec.vdom Fn.id)
      (Navigation.component ~current_route:Home) in
    
    (* Verify home link is active *)
    let home_link = Handle.query_selector handle "a[href='/']" in
    assert (has_class home_link "active");
    
    (* Click another link *)
    Handle.click_on handle ~selector:"a[href='/about']";
    Handle.show_diff handle;
    [%expect {| 
      -<a href="/" class="active">Home</a>
      +<a href="/">Home</a>
      -<a href="/about">About</a>
      +<a href="/about" class="active">About</a>
    |}]
end)
```

#### Form Component Testing
```ocaml
let%test_module "Contact Form tests" = (module struct
  open Bonsai_web_test
  
  let%expect_test "validation errors" =
    let handle = Handle.create 
      (Result_spec.vdom Fn.id)
      Contact_form.component in
    
    (* Submit empty form *)
    Handle.click_on handle ~selector:"button[type=submit]";
    Handle.show handle;
    [%expect {| 
      <div class="error">Name is required</div>
      <div class="error">Email is required</div>
    |}];
    
    (* Fill invalid email *)
    Handle.input_text handle ~selector:"input[name=name]" ~text:"John";
    Handle.input_text handle ~selector:"input[name=email]" ~text:"invalid";
    Handle.click_on handle ~selector:"button[type=submit]";
    Handle.show handle;
    [%expect {| <div class="error">Invalid email format</div> |}]
  
  let%expect_test "successful submission" =
    let handle = Handle.create 
      (Result_spec.vdom Fn.id)
      Contact_form.component in
    
    (* Fill valid form *)
    Handle.input_text handle ~selector:"input[name=name]" ~text:"John Doe";
    Handle.input_text handle ~selector:"input[name=email]" ~text:"john@example.com";
    Handle.input_text handle ~selector:"textarea[name=message]" ~text:"Hello!";
    
    (* Submit *)
    Handle.click_on handle ~selector:"button[type=submit]";
    Handle.show handle;
    [%expect {| <div class="success">Message sent successfully!</div> |}]
end)
```

## 3. Navigation Testing Strategy

### 3.1 Route Testing

```ocaml
let%test_module "Routing tests" = (module struct
  let%expect_test "route parsing" =
    let test_route path =
      let route = Router.parse_route path in
      printf "%s -> %s\n" path (Route.to_string route)
    in
    
    test_route "/";
    test_route "/about";
    test_route "/projects";
    test_route "/contact";
    test_route "/invalid";
    
    [%expect {|
      / -> Home
      /about -> About
      /projects -> Projects
      /contact -> Contact
      /invalid -> Home
    |}]
  
  let%expect_test "deep linking" =
    let handle = Handle.create 
      (Result_spec.vdom Fn.id)
      (App.component ~initial_route:"/projects/ocaml-portfolio") in
    
    Handle.show handle;
    [%expect {| <div class="project-detail">OCaml Portfolio</div> |}]
end)
```

### 3.2 Navigation Flow Testing with Playwright

```ocaml
(* test/integration/navigation_test.ml *)
let test_navigation_flow () =
  (* Start test *)
  mcp__playwright__browser_navigate ~url:"http://localhost:8080";
  
  (* Verify initial state *)
  let snapshot = mcp__playwright__browser_snapshot () in
  assert (contains snapshot "Home");
  
  (* Test navigation *)
  mcp__playwright__browser_click 
    ~element:"About navigation link"
    ~ref:"a[href='/about']";
  
  (* Verify URL change without reload *)
  wait_for ~text:"About Me";
  assert_url_contains "/about";
  
  (* Test browser back button *)
  mcp__playwright__browser_navigate_back ();
  wait_for ~text:"Welcome";
  assert_url_equals "/";
  
  (* Screenshot for visual verification *)
  mcp__playwright__browser_take_screenshot 
    ~filename:"navigation-test.png"
```

## 4. Form Testing Strategy

### 4.1 Form Validation Testing

```ocaml
module Form_validation_tests = struct
  (* Email validation *)
  let test_email_validation () =
    let valid_emails = [
      "user@example.com";
      "name.surname@company.co.uk";
      "user+tag@domain.org"
    ] in
    
    let invalid_emails = [
      "invalid";
      "@example.com";
      "user@";
      "user..name@example.com"
    ] in
    
    List.iter valid_emails ~f:(fun email ->
      assert (Validation.is_valid_email email));
    
    List.iter invalid_emails ~f:(fun email ->
      assert (not (Validation.is_valid_email email)))
  
  (* Phone validation *)
  let test_phone_validation () =
    let valid_phones = [
      "+1-555-555-5555";
      "(555) 555-5555";
      "555.555.5555"
    ] in
    
    List.iter valid_phones ~f:(fun phone ->
      assert (Validation.is_valid_phone phone))
end
```

### 4.2 Form Submission Testing

```ocaml
let%test_module "Form submission" = (module struct
  let%expect_test "network error handling" =
    let handle = Handle.create 
      (Result_spec.vdom Fn.id)
      (Contact_form.component ~api_endpoint:failing_endpoint) in
    
    (* Fill and submit form *)
    fill_form handle valid_data;
    Handle.click_on handle ~selector:"button[type=submit]";
    
    (* Check loading state *)
    Handle.show handle;
    [%expect {| <button disabled>Sending...</button> |}];
    
    (* Wait for error *)
    Handle.advance_clock_by handle (Time_ns.Span.of_sec 1.0);
    Handle.show handle;
    [%expect {| <div class="error">Failed to send message. Please try again.</div> |}]
  
  let%expect_test "success flow" =
    let handle = Handle.create 
      (Result_spec.vdom Fn.id)
      (Contact_form.component ~api_endpoint:success_endpoint) in
    
    fill_form handle valid_data;
    Handle.click_on handle ~selector:"button[type=submit]";
    
    Handle.advance_clock_by handle (Time_ns.Span.of_sec 0.5);
    Handle.show handle;
    [%expect {| 
      <div class="success">Thank you! Your message has been sent.</div>
      <form class="reset">...</form>
    |}]
end)
```

## 5. Visual Testing Strategy

### 5.1 Component Visual Testing

```ocaml
(* test/visual/component_visual_test.ml *)
let test_component_visual_states () =
  let test_states = [
    ("default", default_props);
    ("hover", hover_props);
    ("active", active_props);
    ("disabled", disabled_props);
    ("error", error_props);
  ] in
  
  List.iter test_states ~f:(fun (name, props) ->
    (* Render component *)
    render_component props;
    
    (* Take screenshot *)
    mcp__playwright__browser_take_screenshot 
      ~filename:(sprintf "component-%s.png" name)
      ~element:"Component container"
      ~ref:".component-container";
    
    (* Compare with baseline *)
    assert_visual_match (sprintf "component-%s.png" name))
```

### 5.2 Responsive Testing

```ocaml
let test_responsive_layouts () =
  let viewports = [
    ("mobile", 375, 667);
    ("tablet", 768, 1024);
    ("desktop", 1920, 1080);
  ] in
  
  List.iter viewports ~f:(fun (name, width, height) ->
    (* Resize viewport *)
    mcp__playwright__browser_resize ~width ~height;
    
    (* Navigate to page *)
    mcp__playwright__browser_navigate ~url:"http://localhost:8080";
    
    (* Take screenshot *)
    mcp__playwright__browser_take_screenshot 
      ~filename:(sprintf "home-%s.png" name)
      ~fullPage:true;
    
    (* Verify layout *)
    verify_responsive_layout name)
```

### 5.3 Theme Testing

```ocaml
let test_theme_switching () =
  (* Test light theme *)
  mcp__playwright__browser_navigate ~url:"http://localhost:8080";
  mcp__playwright__browser_take_screenshot ~filename:"light-theme.png";
  
  (* Switch to dark theme *)
  mcp__playwright__browser_click 
    ~element:"Theme toggle button"
    ~ref:"#theme-toggle";
  
  mcp__playwright__browser_wait_for ~time:0.5;
  mcp__playwright__browser_take_screenshot ~filename:"dark-theme.png";
  
  (* Verify CSS variables changed *)
  let dark_bg = mcp__playwright__browser_evaluate 
    ~function:"() => getComputedStyle(document.body).getPropertyValue('--background-color')" in
  assert (dark_bg = "#1a1a1a")
```

## 6. Testing Tools and Infrastructure

### 6.1 Test Helper Modules

```ocaml
(* test/helpers/test_helpers.ml *)
module Test_helpers = struct
  (* Create test fixtures *)
  let sample_project () = {
    id = "test-project";
    title = "Test Project";
    description = "A test project";
    technologies = ["OCaml"; "Bonsai"];
    github_url = Some "https://github.com/test/project";
    demo_url = None;
  }
  
  (* Mock API responses *)
  let mock_api_success data =
    Effect.return (Ok data)
  
  let mock_api_error error =
    Effect.return (Error error)
  
  (* DOM helpers *)
  let has_class element class_name =
    String.contains (Vdom.Node.to_string element) class_name
  
  let find_by_text handle text =
    Handle.query_selector handle 
      (sprintf "//*[contains(text(), '%s')]" text)
end
```

### 6.2 Test Data Builders

```ocaml
module Test_data = struct
  (* Form data builders *)
  let valid_contact_form = {
    name = "John Doe";
    email = "john@example.com";
    subject = "General Inquiry";
    message = "This is a test message";
  }
  
  let invalid_contact_form = {
    name = "";
    email = "invalid-email";
    subject = "";
    message = "";
  }
  
  (* Route data *)
  let all_routes = [
    Home;
    About;
    Projects;
    Words;
    Contact;
  ]
end
```

## 7. CI/CD Integration

### 7.1 GitHub Actions Workflow

```yaml
# .github/workflows/test.yml
name: Test Suite

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup OCaml
      uses: ocaml/setup-ocaml@v2
      with:
        ocaml-compiler: 4.14.x
    
    - name: Install dependencies
      run: |
        opam install . --deps-only --with-test
        opam install bonsai_web_test playwright
    
    - name: Build project
      run: dune build
    
    - name: Run unit tests
      run: dune test test/unit
    
    - name: Start server
      run: |
        dune exec bin/server/main.exe &
        sleep 5
    
    - name: Run integration tests
      run: dune test test/integration
    
    - name: Run visual tests
      run: |
        npm install -g @playwright/test
        dune test test/visual
    
    - name: Upload test artifacts
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: test-results
        path: |
          test-reports/
          test/visual/screenshots/
```

### 7.2 Local Testing Script

```bash
#!/bin/bash
# scripts/test.sh

echo "Running Bonsai Portfolio Test Suite"
echo "===================================="

# Clean and build
echo "Building project..."
dune clean
dune build

# Run unit tests
echo "Running unit tests..."
dune test test/unit

# Start server for integration tests
echo "Starting server..."
dune exec bin/server/main.exe &
SERVER_PID=$!
sleep 3

# Run integration tests
echo "Running integration tests..."
dune test test/integration

# Run visual tests
echo "Running visual tests..."
dune test test/visual

# Kill server
kill $SERVER_PID

# Generate coverage report
echo "Generating coverage report..."
dune test --instrument-with bisect_ppx
bisect-ppx-report html

echo "Test suite complete!"
echo "Coverage report: _coverage/index.html"
echo "Test reports: test-reports/"
```

## 8. Test Organization Best Practices

### 8.1 Test File Structure

```ocaml
(* test/unit/components/navigation_test.ml *)
open! Core
open Bonsai_web_test
open Test_helpers

(* Module under test *)
module Navigation = Portfolio.Client.Components.Navigation

(* Test module *)
let%test_module "Navigation Component" = (module struct
  (* Setup *)
  let create_handle ?current_route () =
    Handle.create 
      (Result_spec.vdom Fn.id)
      (Navigation.component ?current_route)
  
  (* Group related tests *)
  let%test_module "Rendering" = (module struct
    let%expect_test "default state" = ...
    let%expect_test "with current route" = ...
  end)
  
  let%test_module "Interactions" = (module struct
    let%expect_test "link clicks" = ...
    let%expect_test "keyboard navigation" = ...
  end)
  
  let%test_module "Accessibility" = (module struct
    let%expect_test "aria labels" = ...
    let%expect_test "keyboard focus" = ...
  end)
end)
```

### 8.2 Test Naming Conventions

```ocaml
(* Good test names *)
let%expect_test "renders error message when email is invalid" = ...
let%expect_test "disables submit button during API call" = ...
let%expect_test "navigates to project detail on card click" = ...

(* Avoid generic names *)
let%expect_test "test1" = ... (* Bad *)
let%expect_test "works" = ... (* Bad *)
```

## 9. Testing Checklist

### Component Testing Checklist
- [ ] Initial render test
- [ ] Props validation
- [ ] State changes
- [ ] User interactions
- [ ] Error states
- [ ] Loading states
- [ ] Edge cases
- [ ] Accessibility

### Integration Testing Checklist
- [ ] Navigation flows
- [ ] Form submissions
- [ ] API interactions
- [ ] Error handling
- [ ] Authentication flows
- [ ] Data persistence

### Visual Testing Checklist
- [ ] Component states
- [ ] Responsive layouts
- [ ] Theme variations
- [ ] Animation states
- [ ] Cross-browser rendering
- [ ] Print styles

### Performance Testing Checklist
- [ ] Component render time
- [ ] Large data sets
- [ ] Memory leaks
- [ ] Bundle size
- [ ] Network requests

## 10. Example Test Suite for Portfolio

### Complete Test Suite Structure

```dune
; test/dune
(tests
 (names 
  unit_test_suite
  integration_test_suite
  visual_test_suite)
 (libraries
  portfolio
  bonsai_web_test
  ppx_expect
  test_helpers)
 (preprocess (pps ppx_jane ppx_expect)))
```

### Sample Test Execution

```ocaml
(* test/unit_test_suite.ml *)
open! Core

let () =
  (* Component tests *)
  Navigation_test.run ();
  Contact_form_test.run ();
  Project_card_test.run ();
  Layout_test.run ();
  
  (* Page tests *)
  Home_page_test.run ();
  About_page_test.run ();
  Projects_page_test.run ();
  
  (* Utility tests *)
  Validation_test.run ();
  Router_test.run ();
  
  printf "Unit tests completed: %d passed, %d failed\n"
    (Test_results.passed ())
    (Test_results.failed ())
```

## Conclusion

This comprehensive testing strategy ensures high-quality Bonsai portfolio applications through:

1. **Systematic component testing** with bonsai_web_test
2. **End-to-end testing** with Playwright integration
3. **Visual regression testing** for UI consistency
4. **Automated CI/CD** for continuous quality assurance
5. **Clear organization** and best practices

By following this strategy, portfolio applications will be robust, maintainable, and showcase professional development practices alongside OCaml/Bonsai expertise.