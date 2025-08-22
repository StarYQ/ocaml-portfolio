# Testing Quick Start Guide for Bonsai Portfolio

**Date**: January 22, 2025  
**Purpose**: Step-by-step guide to implement testing in your Bonsai portfolio

## Prerequisites

Ensure you have the following installed:
- OCaml 4.14+ with opam
- Dune 3.15+
- Node.js (for Playwright)

## Step 1: Add Testing Dependencies

### Update dune-project

```dune
(package
 (name portfolio20240602)
 (depends
  ; Existing dependencies...
  
  ; Testing dependencies
  (bonsai_web_test :with-test)
  (ppx_expect :with-test)
  (ppx_inline_test :with-test)
  (expect_test_helpers_core :with-test)
  (bisect_ppx :with-test)))
```

### Install Dependencies

```bash
opam install bonsai_web_test ppx_expect ppx_inline_test expect_test_helpers_core bisect_ppx
npm install -g @playwright/test
```

## Step 2: Create Test Directory Structure

```bash
mkdir -p test/{unit,integration,visual,helpers,fixtures}
mkdir -p test/unit/{components,pages,shared}
mkdir -p test/visual/screenshots
```

## Step 3: Create Your First Component Test

### test/unit/components/first_test.ml

```ocaml
open! Core
open Bonsai_web_test

(* Import your component *)
module MyComponent = Portfolio.Client.Components.Navigation

(* Create a simple test *)
let%test_module "My First Test" = (module struct
  let%expect_test "component renders" =
    let handle = Handle.create 
      (Result_spec.vdom Fn.id)
      (MyComponent.component ()) in
    
    Handle.show handle;
    [%expect {| <nav>...</nav> |}]
end)
```

### test/dune

```dune
(test
 (name first_test)
 (libraries
  portfolio
  bonsai_web_test
  ppx_expect)
 (preprocess (pps ppx_jane ppx_expect)))
```

## Step 4: Run Your First Test

```bash
# Run the test
dune test test/unit/components/first_test.ml

# If expect test output differs, auto-promote the changes
dune test --auto-promote
```

## Step 5: Add Form Testing

### test/unit/pages/contact_test.ml

```ocaml
open! Core
open Bonsai_web_test

module Contact = Portfolio.Client.Pages.Page_contact

let%test_module "Contact Form" = (module struct
  let%expect_test "validates email" =
    let handle = Handle.create 
      (Result_spec.vdom Fn.id)
      Contact.component in
    
    (* Enter invalid email *)
    Handle.input_text handle 
      ~selector:"input[name=email]" 
      ~text:"invalid";
    
    (* Submit form *)
    Handle.click_on handle ~selector:"button[type=submit]";
    
    (* Check for error *)
    Handle.show handle;
    [%expect {| ...<span class="error">Invalid email</span>... |}]
end)
```

## Step 6: Add Integration Testing with Playwright

### test/integration/navigation_test.ml

```ocaml
let test_navigation () =
  (* Start browser *)
  mcp__playwright__browser_navigate 
    ~url:"http://localhost:8080";
  
  (* Click navigation link *)
  mcp__playwright__browser_click 
    ~element:"About link"
    ~ref:"a[href='/about']";
  
  (* Verify navigation *)
  mcp__playwright__browser_wait_for ~text:"About Me";
  
  (* Take screenshot *)
  mcp__playwright__browser_take_screenshot 
    ~filename:"navigation-test.png"
```

## Step 7: Create Test Helper Functions

### test/helpers/dom_helpers.ml

```ocaml
open! Core
open Bonsai_web_test

let has_class element class_name =
  String.contains (Handle.show_node element) class_name

let fill_form handle fields =
  List.iter fields ~f:(fun (selector, value) ->
    Handle.input_text handle ~selector ~text:value)

let submit_form handle =
  Handle.click_on handle ~selector:"button[type=submit]"
```

## Step 8: Add Test Scripts

### scripts/test.sh

```bash
#!/bin/bash
set -e

echo "Running Portfolio Tests"
echo "======================"

# Run unit tests
echo "→ Unit tests..."
dune test test/unit

# Start server
echo "→ Starting server..."
dune exec bin/server/main.exe &
PID=$!
sleep 2

# Run integration tests
echo "→ Integration tests..."
dune test test/integration

# Cleanup
kill $PID

echo "✅ All tests passed!"
```

Make it executable:
```bash
chmod +x scripts/test.sh
```

## Step 9: Add Continuous Testing

### .github/workflows/test.yml

```yaml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: ocaml/setup-ocaml@v2
      with:
        ocaml-compiler: 4.14.x
    - run: opam install . --deps-only --with-test
    - run: dune build
    - run: dune test
```

## Step 10: Run Complete Test Suite

```bash
# Run all tests
./scripts/test.sh

# Run with coverage
dune test --instrument-with bisect_ppx
bisect-ppx-report html
open _coverage/index.html

# Watch mode for development
dune test --watch
```

## Common Testing Patterns

### Testing State Changes

```ocaml
let%expect_test "state updates on click" =
  let handle = create_handle () in
  
  (* Initial state *)
  Handle.show handle;
  [%expect {| <div>Count: 0</div> |}];
  
  (* Click button *)
  Handle.click_on handle ~selector:"button";
  
  (* Updated state *)
  Handle.show handle;
  [%expect {| <div>Count: 1</div> |}]
```

### Testing Async Operations

```ocaml
let%expect_test "async data loading" =
  let handle = create_handle () in
  
  (* Initial loading state *)
  Handle.show handle;
  [%expect {| <div>Loading...</div> |}];
  
  (* Advance time *)
  Handle.advance_clock_by handle 
    (Time_ns.Span.of_sec 1.0);
  
  (* Loaded state *)
  Handle.show handle;
  [%expect {| <div>Data loaded</div> |}]
```

### Testing Error States

```ocaml
let%expect_test "handles errors" =
  let handle = create_handle 
    ~api_endpoint:failing_endpoint () in
  
  Handle.click_on handle ~selector:"button";
  Handle.advance_clock_by handle 
    (Time_ns.Span.of_sec 1.0);
  
  Handle.show handle;
  [%expect {| <div class="error">Error occurred</div> |}]
```

## Debugging Tips

### 1. Show Full DOM
```ocaml
(* See complete rendered output *)
Handle.show handle |> print_endline
```

### 2. Show Differences
```ocaml
(* See what changed after an action *)
Handle.show_diff handle
```

### 3. Query Specific Elements
```ocaml
(* Find and inspect specific elements *)
let element = Handle.query_selector handle ".my-class" in
Option.iter element ~f:(fun e -> 
  Handle.show_node e |> print_endline)
```

### 4. Debug State
```ocaml
(* Print component state for debugging *)
let%expect_test "debug state" =
  let handle = create_handle () in
  Handle.print_state handle;
  [%expect {| State: { count: 0; active: false } |}]
```

## Troubleshooting

### Issue: Tests fail with "Element not found"
**Solution**: Use `Handle.show handle` to see actual DOM structure

### Issue: Expect tests keep failing
**Solution**: Run `dune test --auto-promote` to update expectations

### Issue: Async tests timeout
**Solution**: Use `Handle.advance_clock_by` to simulate time passing

### Issue: Can't find modules in tests
**Solution**: Check your dune file includes correct libraries

## Best Practices Checklist

- [ ] Test both happy and error paths
- [ ] Use descriptive test names
- [ ] Group related tests in modules
- [ ] Mock external dependencies
- [ ] Test accessibility features
- [ ] Include visual regression tests
- [ ] Run tests in CI/CD pipeline
- [ ] Maintain >80% code coverage
- [ ] Document complex test setups
- [ ] Keep tests fast and isolated

## Next Steps

1. **Expand test coverage** - Add tests for all components
2. **Add visual tests** - Implement screenshot comparisons
3. **Performance tests** - Measure render times
4. **Accessibility tests** - Verify ARIA attributes
5. **End-to-end flows** - Test complete user journeys

## Resources

- [Bonsai Testing Docs](https://bonsai.red/testing)
- [Expect Test Guide](https://github.com/janestreet/ppx_expect)
- [Playwright Documentation](https://playwright.dev)
- [Dune Testing](https://dune.readthedocs.io/en/stable/tests.html)

Start with Step 3 to create your first test, then gradually expand coverage following this guide!