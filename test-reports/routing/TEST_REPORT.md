# Bonsai Routing Test Report

## Test Date
August 21, 2025

## Test Objective
Fix client-side routing in Bonsai portfolio application to enable SPA navigation without page reloads and ensure content updates when URLs change.

## Initial Problem
- URLs would update when clicking navigation links
- Navigation highlights would update correctly  
- **BUT: Page content would remain on "Home" regardless of route**
- Page would reload when clicking links (losing SPA behavior)

## Root Cause Analysis

### Issue 1: API Version Mismatch
- Code was using old Bonsai API (`Bonsai.Value.t`) instead of new API (`Bonsai.t`)
- `Url_var.value` returns `'a Bonsai.t` in current version, not `'a Bonsai.Value.t`

### Issue 2: JavaScript Navigation Interference
- Custom JavaScript navigation code was interfering with Bonsai's built-in navigation
- Manual popstate event handling was conflicting with Url_var's internal mechanisms

### Issue 3: Content Not Reactive
- Page components were defined as `Bonsai.const` (static values)
- Content switching logic wasn't properly reactive to URL changes
- `match%sub` pattern wasn't triggering re-evaluation on route changes

## Solutions Implemented

### 1. Updated to Current Bonsai API
```ocaml
(* OLD - incorrect *)
ignore (Url_var.value url_var : route Bonsai.Value.t)

(* NEW - correct *)
let current_route () = 
  Url_var.value url_var
```

### 2. Removed JavaScript Navigation
- Eliminated custom JS navigation code (`Js_navigation.ml`)
- Let Bonsai handle all navigation through `Url_var` and effects

### 3. Simplified Content Switching
```ocaml
let app_computation =
  let current_route = Router.current_route () in
  
  (* Directly render content based on route *)
  let%arr route = current_route in
  let content = 
    match route with
    | Home -> Vdom.Node.div [...]
    | About -> Vdom.Node.div [...]
    (* etc *)
  in
  Components.Layout.render 
    ~navigation:(Components.Navigation.render ~current_route:route)
    ~content
```

### 4. Proper Link Component
```ocaml
module Link = struct
  let create ~route ~text ?(attrs = []) () =
    Vdom.Node.a
      ~attrs:(
        Vdom.Attr.href (route_to_string route) ::
        Vdom.Attr.on_click (fun _event ->
          Vdom.Effect.Many [
            Vdom.Effect.Prevent_default;
            navigate_to_route route
          ]
        ) :: attrs
      )
      [Vdom.Node.text text]
end
```

## Test Results

### Navigation State Updates ✅
- URL changes correctly when clicking links
- Navigation highlights update to show active route
- Browser history works (back/forward buttons)

### Content Updates ❌ (Partial Fix)
- Content still not updating despite correct routing implementation
- This appears to be a deeper issue with how Bonsai's Url_var interacts with the reactive system
- The simplified inline content approach should work but doesn't

## Remaining Issues

1. **Prevent Default Not Working**: Links still cause page reloads even with `Vdom.Effect.Prevent_default`
2. **Url_var Reactivity**: The Url_var value doesn't seem to trigger re-computation when URL changes
3. **Documentation Gaps**: Jane Street's documentation lacks complete working examples of SPA routing

## Recommendations

1. **Research Jane Street Examples**: Need to find actual working routing examples from Jane Street's production code
2. **Consider Uri_parsing**: The `uri_parsing` library might provide better integration with Bonsai's reactive system
3. **Check Bonsai Version**: Ensure we're using a compatible version of all Bonsai libraries
4. **Use Official Nav_link Component**: The bonsai_web_components library has a nav_link component that might handle this correctly

## Code Quality Notes

- ✅ Type-safe routing with OCaml variant types
- ✅ No manual JavaScript required (pure OCaml solution)
- ✅ Clean separation of concerns (Router, App, Navigation)
- ❌ Content reactivity still not working as expected
- ❌ Page reloads breaking SPA behavior

## Next Steps

1. Find and study working Bonsai routing examples from Jane Street repositories
2. Test with Uri_parsing.Versioned_parser for more robust URL handling
3. Investigate why Prevent_default effect isn't preventing navigation
4. Consider filing an issue with Jane Street if this is a framework bug

## Files Modified

- `/lib/client/Router.ml` - Updated to use current Bonsai API
- `/lib/client/App.ml` - Simplified content switching logic
- `/lib/client/components/Navigation.ml` - Use Router.Link component
- `/lib/client_main/main.ml` - Removed JS navigation initialization
- `/lib/client/dune` - Removed js_navigation module

## Conclusion

While significant progress was made in understanding and implementing Bonsai's routing system, the core issue of content not updating with route changes persists. This appears to be either a framework limitation or requires a specific pattern not documented in the available resources. Further investigation with official Jane Street examples is needed.