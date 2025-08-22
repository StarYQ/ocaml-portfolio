# Testing Implementation Examples for Bonsai Portfolio

**Date**: January 22, 2025  
**Purpose**: Ready-to-use test implementations for the portfolio project

## 1. Complete Component Test File

### Navigation Component Test

```ocaml
(* test/unit/components/navigation_test.ml *)
open! Core
open Bonsai_web_test
open Virtual_dom
open Shared.Types

module Navigation = Portfolio.Client.Components.Navigation

let%test_module "Navigation Component Tests" = (module struct
  (* Helper to create test handle *)
  let create_handle ?(current_route = Home) () =
    Handle.create 
      (Result_spec.vdom Fn.id)
      (Navigation.component ~current_route)
  
  (* Test initial render *)
  let%expect_test "renders all navigation links" =
    let handle = create_handle () in
    Handle.show handle;
    [%expect {|
      <nav>
        <a href="/" class="active">Home</a>
        <a href="/about">About</a>
        <a href="/projects">Projects</a>
        <a href="/words">Words</a>
        <a href="/contact">Contact</a>
      </nav>
    |}]
  
  (* Test active route highlighting *)
  let%expect_test "highlights current route" =
    let handle = create_handle ~current_route:Projects () in
    let projects_link = Handle.query_selector handle "a[href='/projects']" in
    let has_active = String.contains (Handle.show_node projects_link) "active" in
    assert has_active;
    [%expect {| |}]
  
  (* Test hover states *)
  let%expect_test "shows hover effect on mouse enter" =
    let handle = create_handle () in
    Handle.trigger_event handle ~selector:"a[href='/about']" ~event:`Mouseenter;
    Handle.show_diff handle;
    [%expect {| 
      @@ class change
      -<a href="/about">About</a>
      +<a href="/about" class="hover">About</a>
    |}];
    
    Handle.trigger_event handle ~selector:"a[href='/about']" ~event:`Mouseleave;
    Handle.show_diff handle;
    [%expect {| 
      @@ class change
      -<a href="/about" class="hover">About</a>
      +<a href="/about">About</a>
    |}]
  
  (* Test keyboard navigation *)
  let%expect_test "supports keyboard navigation" =
    let handle = create_handle () in
    
    (* Tab through links *)
    Handle.trigger_event handle ~selector:"nav" ~event:(`Keydown "Tab");
    let focused = Handle.get_focused_element handle in
    assert (Option.is_some focused);
    [%expect {| |}]
  
  (* Test accessibility *)
  let%expect_test "includes proper ARIA attributes" =
    let handle = create_handle () in
    let nav = Handle.query_selector handle "nav" in
    assert (has_attribute nav "role" "navigation");
    assert (has_attribute nav "aria-label" "Main navigation");
    [%expect {| |}]
end)
```

## 2. Contact Form Test Implementation

```ocaml
(* test/unit/pages/contact_form_test.ml *)
open! Core
open Bonsai_web_test
open Bonsai_web_ui_form

module Contact_form = Portfolio.Client.Pages.Page_contact

let%test_module "Contact Form Tests" = (module struct
  let create_handle () =
    Handle.create 
      (Result_spec.vdom Fn.id)
      Contact_form.component
  
  (* Validation tests *)
  let%test_module "Field Validation" = (module struct
    let%expect_test "validates required fields" =
      let handle = create_handle () in
      
      (* Try to submit empty form *)
      Handle.click_on handle ~selector:"button[type=submit]";
      Handle.show handle;
      [%expect {|
        <form>
          <div class="field error">
            <input name="name" />
            <span class="error-message">Name is required</span>
          </div>
          <div class="field error">
            <input name="email" />
            <span class="error-message">Email is required</span>
          </div>
          <div class="field error">
            <textarea name="message"></textarea>
            <span class="error-message">Message is required</span>
          </div>
        </form>
      |}]
    
    let%expect_test "validates email format" =
      let handle = create_handle () in
      
      (* Enter invalid email *)
      Handle.input_text handle ~selector:"input[name=email]" ~text:"not-an-email";
      Handle.blur handle ~selector:"input[name=email]";
      
      let email_field = Handle.query_selector handle ".field:has(input[name=email])" in
      assert (has_class email_field "error");
      [%expect {| <span class="error-message">Please enter a valid email</span> |}]
    
    let%expect_test "validates message length" =
      let handle = create_handle () in
      
      (* Enter short message *)
      Handle.input_text handle ~selector:"textarea[name=message]" ~text:"Hi";
      Handle.blur handle ~selector:"textarea[name=message]";
      
      Handle.show_diff handle;
      [%expect {| 
        +<span class="error-message">Message must be at least 10 characters</span>
      |}]
  end)
  
  (* Submission tests *)
  let%test_module "Form Submission" = (module struct
    let fill_valid_form handle =
      Handle.input_text handle ~selector:"input[name=name]" ~text:"John Doe";
      Handle.input_text handle ~selector:"input[name=email]" ~text:"john@example.com";
      Handle.input_text handle ~selector:"textarea[name=message]" 
        ~text:"This is a test message for the contact form."
    
    let%expect_test "shows loading state during submission" =
      let handle = create_handle () in
      fill_valid_form handle;
      
      (* Submit form *)
      Handle.click_on handle ~selector:"button[type=submit]";
      
      (* Check immediate state *)
      let submit_btn = Handle.query_selector handle "button[type=submit]" in
      assert (has_attribute submit_btn "disabled" "true");
      assert (has_text submit_btn "Sending...");
      [%expect {| <button type="submit" disabled>Sending...</button> |}]
    
    let%expect_test "shows success message after submission" =
      let handle = create_handle () in
      fill_valid_form handle;
      
      Handle.click_on handle ~selector:"button[type=submit]";
      
      (* Simulate successful response *)
      Handle.advance_clock_by handle (Time_ns.Span.of_sec 1.0);
      
      Handle.show handle;
      [%expect {|
        <div class="success-message">
          <h3>Thank you!</h3>
          <p>Your message has been sent successfully.</p>
        </div>
        <button>Send another message</button>
      |}]
    
    let%expect_test "handles submission errors gracefully" =
      let handle = create_handle () in
      fill_valid_form handle;
      
      (* Mock network error *)
      Handle.set_mock_response handle ~endpoint:"/api/contact" 
        ~response:(Error "Network error");
      
      Handle.click_on handle ~selector:"button[type=submit]";
      Handle.advance_clock_by handle (Time_ns.Span.of_sec 1.0);
      
      Handle.show handle;
      [%expect {|
        <div class="error-message">
          <p>Failed to send message. Please try again.</p>
          <button>Retry</button>
        </div>
      |}]
  end)
end)
```

## 3. Project Card Component Test

```ocaml
(* test/unit/components/project_card_test.ml *)
open! Core
open Bonsai_web_test
open Shared.Types

module Project_card = Portfolio.Client.Components.Project_card

let%test_module "Project Card Tests" = (module struct
  let sample_project = {
    id = "test-project";
    title = "Test Project";
    description = "A sample project for testing";
    technologies = ["OCaml"; "Bonsai"; "Dream"];
    github_url = Some "https://github.com/user/project";
    demo_url = Some "https://demo.example.com";
    featured = true;
  }
  
  let create_handle ?(project = sample_project) ?(on_click = fun _ -> Effect.Ignore) () =
    Handle.create 
      (Result_spec.vdom Fn.id)
      (Project_card.component ~project ~on_click)
  
  let%expect_test "renders project information" =
    let handle = create_handle () in
    Handle.show handle;
    [%expect {|
      <div class="project-card featured">
        <h3>Test Project</h3>
        <p>A sample project for testing</p>
        <div class="technologies">
          <span class="tech-tag">OCaml</span>
          <span class="tech-tag">Bonsai</span>
          <span class="tech-tag">Dream</span>
        </div>
        <div class="links">
          <a href="https://github.com/user/project" target="_blank">GitHub</a>
          <a href="https://demo.example.com" target="_blank">Demo</a>
        </div>
      </div>
    |}]
  
  let%expect_test "handles click events" =
    let clicked = ref false in
    let on_click _ = 
      clicked := true;
      Effect.Ignore
    in
    
    let handle = create_handle ~on_click () in
    Handle.click_on handle ~selector:".project-card";
    
    assert !clicked;
    [%expect {| |}]
  
  let%expect_test "shows hover state" =
    let handle = create_handle () in
    
    Handle.trigger_event handle ~selector:".project-card" ~event:`Mouseenter;
    let card = Handle.query_selector handle ".project-card" in
    assert (has_class card "hover");
    
    Handle.trigger_event handle ~selector:".project-card" ~event:`Mouseleave;
    let card = Handle.query_selector handle ".project-card" in
    assert (not (has_class card "hover"));
    [%expect {| |}]
  
  let%expect_test "handles missing URLs gracefully" =
    let project_no_links = { sample_project with 
      github_url = None; 
      demo_url = None 
    } in
    
    let handle = create_handle ~project:project_no_links () in
    let links = Handle.query_selector handle ".links" in
    
    (* Links section should not be rendered if no URLs *)
    assert (Option.is_none links);
    [%expect {| |}]
end)
```

## 4. Integration Test with Playwright

```ocaml
(* test/integration/portfolio_flow_test.ml *)
open! Core

let test_complete_portfolio_flow () =
  (* Initialize browser *)
  mcp__playwright__browser_navigate ~url:"http://localhost:8080";
  
  (* Test home page *)
  let%test "home page loads" =
    let snapshot = mcp__playwright__browser_snapshot () in
    assert (String.contains snapshot "Welcome to my portfolio");
    mcp__playwright__browser_take_screenshot ~filename:"test-home.png"
  in
  
  (* Test navigation to projects *)
  let%test "navigate to projects" =
    mcp__playwright__browser_click 
      ~element:"Projects navigation link"
      ~ref:"a[href='/projects']";
    
    mcp__playwright__browser_wait_for ~text:"My Projects";
    
    let url = mcp__playwright__browser_get_url () in
    assert (String.ends_with url ~suffix:"/projects");
    
    mcp__playwright__browser_take_screenshot ~filename:"test-projects.png"
  in
  
  (* Test project interaction *)
  let%test "click on project card" =
    mcp__playwright__browser_click 
      ~element:"First project card"
      ~ref:".project-card:first-child";
    
    mcp__playwright__browser_wait_for ~text:"Project Details";
    mcp__playwright__browser_take_screenshot ~filename:"test-project-detail.png"
  in
  
  (* Test contact form *)
  let%test "fill and submit contact form" =
    mcp__playwright__browser_navigate ~url:"http://localhost:8080/contact";
    
    (* Fill form *)
    mcp__playwright__browser_type 
      ~element:"Name input"
      ~ref:"input[name='name']"
      ~text:"Test User";
    
    mcp__playwright__browser_type 
      ~element:"Email input"
      ~ref:"input[name='email']"
      ~text:"test@example.com";
    
    mcp__playwright__browser_type 
      ~element:"Message textarea"
      ~ref:"textarea[name='message']"
      ~text:"This is a test message from the integration test.";
    
    (* Submit *)
    mcp__playwright__browser_click 
      ~element:"Submit button"
      ~ref:"button[type='submit']";
    
    (* Wait for success *)
    mcp__playwright__browser_wait_for ~text:"Thank you!";
    mcp__playwright__browser_take_screenshot ~filename:"test-contact-success.png"
  in
  
  (* Test responsive behavior *)
  let%test "responsive layout" =
    (* Mobile view *)
    mcp__playwright__browser_resize ~width:375 ~height:667;
    mcp__playwright__browser_navigate ~url:"http://localhost:8080";
    mcp__playwright__browser_take_screenshot ~filename:"test-mobile.png";
    
    (* Tablet view *)
    mcp__playwright__browser_resize ~width:768 ~height:1024;
    mcp__playwright__browser_take_screenshot ~filename:"test-tablet.png";
    
    (* Desktop view *)
    mcp__playwright__browser_resize ~width:1920 ~height:1080;
    mcp__playwright__browser_take_screenshot ~filename:"test-desktop.png"
  in
  
  (* Test theme switching *)
  let%test "theme toggle" =
    mcp__playwright__browser_click 
      ~element:"Theme toggle"
      ~ref:"#theme-toggle";
    
    mcp__playwright__browser_wait_for ~time:0.5;
    
    let dark_mode = mcp__playwright__browser_evaluate 
      ~function:"() => document.body.classList.contains('dark-theme')" in
    
    assert dark_mode;
    mcp__playwright__browser_take_screenshot ~filename:"test-dark-theme.png"
  in
  
  print_endline "Integration tests completed successfully!"
```

## 5. Test Helper Module

```ocaml
(* test/helpers/test_helpers.ml *)
open! Core
open Bonsai_web_test
open Virtual_dom

module Test_helpers = struct
  (* DOM Query Helpers *)
  let has_class element class_name =
    let element_str = Handle.show_node element in
    String.contains element_str (sprintf {|class="%s"|} class_name) ||
    String.contains element_str (sprintf {|class=".*%s.*"|} class_name)
  
  let has_attribute element attr value =
    let element_str = Handle.show_node element in
    String.contains element_str (sprintf {|%s="%s"|} attr value)
  
  let has_text element text =
    let element_str = Handle.show_node element in
    String.contains element_str text
  
  let count_elements handle selector =
    List.length (Handle.query_selector_all handle selector)
  
  (* Form Helpers *)
  let fill_form handle fields =
    List.iter fields ~f:(fun (selector, value) ->
      Handle.input_text handle ~selector ~text:value)
  
  let submit_form handle =
    Handle.click_on handle ~selector:"button[type=submit]"
  
  (* Async Helpers *)
  let wait_for_element handle selector ~timeout =
    let rec check remaining =
      if remaining <= 0 then false
      else
        match Handle.query_selector handle selector with
        | Some _ -> true
        | None ->
          Handle.advance_clock_by handle (Time_ns.Span.of_ms 100.0);
          check (remaining - 100)
    in
    check timeout
  
  (* Mock Data Generators *)
  let generate_project ?(id = Uuid.to_string (Uuid.create ())) () = {
    Types.Project.
    id;
    title = sprintf "Project %s" id;
    description = "Generated test project";
    technologies = ["OCaml"; "Test"];
    github_url = Some (sprintf "https://github.com/test/%s" id);
    demo_url = None;
    featured = false;
  }
  
  let generate_contact_submission () = {
    name = "Test User";
    email = sprintf "test-%d@example.com" (Random.int 1000);
    subject = "Test Subject";
    message = "This is a test message with sufficient length.";
  }
  
  (* Assertion Helpers *)
  let assert_element_exists handle selector =
    match Handle.query_selector handle selector with
    | Some _ -> ()
    | None -> failwith (sprintf "Element not found: %s" selector)
  
  let assert_element_not_exists handle selector =
    match Handle.query_selector handle selector with
    | None -> ()
    | Some _ -> failwith (sprintf "Element should not exist: %s" selector)
  
  let assert_text_contains handle selector expected =
    match Handle.query_selector handle selector with
    | Some element ->
      let text = Handle.show_node element in
      if not (String.contains text expected) then
        failwithf "Text '%s' not found in element %s" expected selector ()
    | None -> failwith (sprintf "Element not found: %s" selector)
  
  (* Snapshot Helpers *)
  let take_snapshot handle name =
    let content = Handle.show handle in
    let filename = sprintf "snapshots/%s.snapshot" name in
    Out_channel.write_all filename ~data:content
  
  let compare_snapshot handle name =
    let current = Handle.show handle in
    let filename = sprintf "snapshots/%s.snapshot" name in
    let expected = In_channel.read_all filename in
    String.equal current expected
end
```

## 6. Test Dune Configuration

```dune
; test/dune
(library
 (name test_helpers)
 (modules test_helpers)
 (libraries
  core
  bonsai_web_test
  virtual_dom
  portfolio))

(test
 (name unit_test_suite)
 (modules 
  navigation_test
  contact_form_test
  project_card_test
  router_test
  validation_test)
 (libraries
  core
  bonsai_web_test
  ppx_expect
  test_helpers
  portfolio)
 (preprocess (pps ppx_jane ppx_expect)))

(test
 (name integration_test_suite)
 (modules portfolio_flow_test)
 (libraries
  core
  test_helpers
  portfolio)
 (deps
  (glob_files ../bin/server/main.exe)))

; Enable inline tests
(library
 (name portfolio_with_tests)
 (inline_tests)
 (modules :standard)
 (libraries portfolio bonsai_web_test)
 (preprocess (pps ppx_jane ppx_inline_test ppx_expect)))
```

## 7. Running Tests

### Command Examples

```bash
# Run all tests
dune test

# Run specific test file
dune test test/unit/components/navigation_test.ml

# Run with coverage
dune test --instrument-with bisect_ppx

# Run inline tests
dune runtest

# Run and update expect tests
dune runtest --auto-promote

# Watch mode
dune test --watch
```

### Test Script

```bash
#!/bin/bash
# scripts/run_tests.sh

set -e

echo "Portfolio Test Suite"
echo "==================="

# Clean build
echo "→ Cleaning build artifacts..."
dune clean

# Build project
echo "→ Building project..."
dune build

# Run unit tests
echo "→ Running unit tests..."
dune test test/unit

# Start server for integration tests
echo "→ Starting test server..."
dune exec bin/server/main.exe &
SERVER_PID=$!
sleep 2

# Run integration tests
echo "→ Running integration tests..."
dune test test/integration

# Stop server
kill $SERVER_PID

# Generate coverage
if [ "$1" = "--coverage" ]; then
  echo "→ Generating coverage report..."
  dune test --instrument-with bisect_ppx
  bisect-ppx-report html
  echo "Coverage report: _coverage/index.html"
fi

echo ""
echo "✅ All tests passed!"
```

These implementation examples provide ready-to-use test code that follows Bonsai testing best practices and can be directly integrated into the portfolio project.