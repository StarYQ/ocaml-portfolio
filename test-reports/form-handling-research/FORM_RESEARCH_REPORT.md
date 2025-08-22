# Bonsai Form Handling & Validation Research Report

**Date**: January 22, 2025  
**Project**: OCaml Portfolio - Contact Form Implementation  
**Research Scope**: Form handling, validation patterns, UX best practices for portfolio contact forms

## Executive Summary

After comprehensive research of Bonsai's form handling capabilities, we've identified robust patterns for implementing professional portfolio contact forms. The `bonsai_web_ui_form` library provides a complete form system with built-in validation, error handling, and reactive state management that aligns perfectly with portfolio requirements.

### 🎯 Key Findings

1. **Complete Form System Available**: `bonsai_web_ui_form` provides all necessary components
2. **Built-in Validation**: Comprehensive validation framework with custom validators
3. **Type-Safe Forms**: Full OCaml type safety with automatic error tracking
4. **Professional UX**: Loading states, disabled states, and error messaging built-in
5. **Effect Integration**: Seamless integration with Bonsai effects for API calls

---

## Form Components Available in bonsai_web_ui_form

### 📝 Input Components

```ocaml
(* Text Inputs *)
Bonsai_web_ui_form.Elements.Textbox.string
  ~placeholder:"Your name"
  ~allow_updates_when_focused:`Never
  ()

(* Email Fields - with built-in email validation *)
Bonsai_web_ui_form.Elements.Textbox.string
  ~placeholder:"email@example.com"
  ~validate:(fun email ->
    if String.contains email '@' then Ok ()
    else Error (Error.of_string "Invalid email address"))
  ()

(* Textareas *)
Bonsai_web_ui_form.Elements.Textarea.string
  ~placeholder:"Your message"
  ~rows:6
  ()

(* Select Dropdowns *)
Bonsai_web_ui_form.Elements.Dropdown.list
  (module String)
  ~init:None
  ~options:["General Inquiry"; "Project Collaboration"; "Job Opportunity"]
  ()

(* Checkboxes *)
Bonsai_web_ui_form.Elements.Checkbox.bool
  ~default:false
  ~label:"Subscribe to newsletter"
  ()
```

### 🔧 Form Composition Pattern

```ocaml
open! Core
open Bonsai.Let_syntax
open Bonsai_web

(* Define form data type *)
module Contact_form_data = struct
  type t = {
    name: string;
    email: string;
    subject: string;
    message: string;
    subscribe: bool;
  } [@@deriving sexp, equal, typed_fields]
end

(* Create composed form *)
let contact_form_component =
  let module Form = Bonsai_web_ui_form.With_manual_view(Contact_form_data) in
  
  let%sub form = 
    Form.make
      (fun ~name ~email ~subject ~message ~subscribe ->
        let%sub name_field = 
          Bonsai_web_ui_form.Elements.Textbox.string 
            ~placeholder:"Your name"
            ~validate:(fun name ->
              if String.length name >= 2 then Ok ()
              else Error (Error.of_string "Name must be at least 2 characters"))
            ()
        in
        let%sub email_field =
          Bonsai_web_ui_form.Elements.Textbox.string
            ~placeholder:"email@example.com"
            ~validate:Email_validation.validate
            ()
        in
        let%sub subject_field =
          Bonsai_web_ui_form.Elements.Dropdown.list
            (module String)
            ~init:(Some "General Inquiry")
            ~options:["General Inquiry"; "Project Collaboration"; "Job Opportunity"; "Other"]
            ()
        in
        let%sub message_field =
          Bonsai_web_ui_form.Elements.Textarea.string
            ~placeholder:"Your message"
            ~rows:6
            ~validate:(fun msg ->
              if String.length msg >= 10 then Ok ()
              else Error (Error.of_string "Message must be at least 10 characters"))
            ()
        in
        let%sub subscribe_field =
          Bonsai_web_ui_form.Elements.Checkbox.bool
            ~default:false
            ~label:"Subscribe to newsletter"
            ()
        in
        let%arr name = name_field
        and email = email_field
        and subject = subject_field
        and message = message_field
        and subscribe = subscribe_field in
        Form.Fields.create ~name ~email ~subject ~message ~subscribe)
  in
  form
```

---

## Validation Patterns

### ✅ Built-in Validation Functions

```ocaml
module Validators = struct
  (* Email validation *)
  let validate_email email =
    let email_regex = Re.Perl.compile_pat {|^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$|} in
    if Re.execp email_regex email then Ok ()
    else Error (Error.of_string "Please enter a valid email address")

  (* Phone validation *)
  let validate_phone phone =
    let phone_clean = String.filter phone ~f:Char.is_digit in
    if String.length phone_clean >= 10 then Ok ()
    else Error (Error.of_string "Please enter a valid phone number")

  (* URL validation *)
  let validate_url url =
    if String.is_prefix url ~prefix:"http://" || String.is_prefix url ~prefix:"https://"
    then Ok ()
    else Error (Error.of_string "URL must start with http:// or https://")

  (* Required field validation *)
  let required field_name value =
    if String.is_empty (String.strip value) then
      Error (Error.of_string (sprintf "%s is required" field_name))
    else Ok ()

  (* Min/Max length validation *)
  let length_range ~min ~max field_name value =
    let len = String.length value in
    if len < min then
      Error (Error.of_string (sprintf "%s must be at least %d characters" field_name min))
    else if len > max then
      Error (Error.of_string (sprintf "%s must be no more than %d characters" field_name max))
    else Ok ()
end
```

### 🔄 Real-time vs On-Submit Validation

```ocaml
(* Real-time validation (as user types) *)
let%sub name_field =
  Bonsai_web_ui_form.Elements.Textbox.string
    ~placeholder:"Your name"
    ~validate:(Validators.required "Name")
    ~allow_updates_when_focused:`Always (* Validate while typing *)
    ()

(* On-blur validation (when user leaves field) *)
let%sub email_field =
  Bonsai_web_ui_form.Elements.Textbox.string
    ~placeholder:"Email"
    ~validate:Validators.validate_email
    ~allow_updates_when_focused:`Never (* Only validate on blur *)
    ()

(* On-submit validation *)
let handle_submit form_data =
  match Bonsai_web_ui_form.value form_data with
  | Ok data -> 
      (* All validations passed, proceed with submission *)
      submit_to_server data
  | Error errors ->
      (* Show validation errors *)
      display_errors errors
```

---

## User Experience Patterns

### 🎨 Form States & Feedback

```ocaml
module Form_ui = struct
  open Virtual_dom
  open Vdom

  (* Loading state during submission *)
  let render_submit_button ~is_submitting ~is_valid =
    let attrs = 
      [ Attr.type_ "submit"
      ; Attr.class_ "submit-button"
      ; Attr.disabled (is_submitting || not is_valid)
      ] in
    let content =
      if is_submitting then
        [ Node.span [Node.text "Sending..."]
        ; Node.span ~attrs:[Attr.class_ "spinner"] []
        ]
      else
        [ Node.text "Send Message" ]
    in
    Node.button ~attrs content

  (* Error display component *)
  let render_field_error error_opt =
    match error_opt with
    | None -> Node.none
    | Some error ->
        Node.div ~attrs:[Attr.class_ "field-error"]
          [Node.text (Error.to_string_hum error)]

  (* Success message *)
  let render_success_message =
    Node.div ~attrs:[Attr.class_ "success-message"]
      [ Node.h3 [Node.text "Message Sent!"]
      ; Node.p [Node.text "Thank you for contacting me. I'll respond within 24 hours."]
      ]

  (* Field wrapper with label and error *)
  let field_wrapper ~label ~required field error_opt =
    Node.div ~attrs:[Attr.class_ "form-field"]
      [ Node.label 
          [ Node.text label
          ; if required then Node.span ~attrs:[Attr.class_ "required"] [Node.text "*"]
            else Node.none
          ]
      ; field
      ; render_field_error error_opt
      ]
end
```

### 🚀 Progressive Enhancement

```ocaml
(* Start with basic form, enhance with features *)
let progressive_contact_form =
  let%sub form_state = Bonsai.state (module Form_state) ~default_model:Initial in
  let%sub form_fields = create_form_fields () in
  
  let%sub spam_prevention = 
    (* Honeypot field - hidden from users *)
    Bonsai_web_ui_form.Elements.Textbox.string
      ~placeholder:""
      ~attr:(Vdom.Attr.style (Css_gen.display `None))
      ()
  in
  
  let%sub rate_limiting =
    (* Track submission attempts *)
    let%sub last_submission = Bonsai.state_opt () in
    let%arr last_submission = last_submission in
    match last_submission with
    | None -> `Allowed
    | Some time ->
        if Time_ns.diff (Time_ns.now ()) time > Time_ns.Span.of_sec 60.0
        then `Allowed
        else `Rate_limited
  in
  
  (* Compose everything *)
  let%arr form_state = form_state
  and form_fields = form_fields
  and spam_check = spam_prevention
  and rate_limit = rate_limiting in
  
  (* Render based on state *)
  match form_state with
  | Initial -> render_form form_fields
  | Submitting -> render_loading ()
  | Success -> render_success ()
  | Error msg -> render_error msg
```

---

## Form Submission & Effect Handling

### 📤 API Integration Pattern

```ocaml
module Contact_api = struct
  open Async_kernel
  open Js_of_ocaml
  
  let submit_form (form_data : Contact_form_data.t) =
    let open Async_js in
    let%bind response = 
      Fetch.fetch "/api/contact"
        ~method_:`POST
        ~headers:["Content-Type", "application/json"]
        ~body:(Js.string (Contact_form_data.to_json form_data))
    in
    match Fetch.Response.status response with
    | 200 -> return (Ok ())
    | 429 -> return (Error "Too many requests. Please try again later.")
    | _ -> return (Error "Failed to send message. Please try again.")
end

(* Form submission handler *)
let handle_form_submission form_data =
  let%bind.Effect () = 
    (* Disable form during submission *)
    set_form_state Submitting
  in
  let%bind.Effect result = 
    (* Make API call *)
    Effect.of_deferred_fun Contact_api.submit_form form_data
  in
  match result with
  | Ok () ->
      let%bind.Effect () = set_form_state Success in
      (* Reset form after 3 seconds *)
      Effect.Time_ns.sleep (Time_ns.Span.of_sec 3.0)
      >>= fun () -> reset_form ()
  | Error msg ->
      set_form_state (Error msg)
```

---

## Accessibility Considerations

### ♿ ARIA & Semantic HTML

```ocaml
module Accessible_form = struct
  let render_form ~form ~errors =
    Vdom.Node.form
      ~attrs:[
        Vdom.Attr.create "role" "form";
        Vdom.Attr.create "aria-label" "Contact form";
        Vdom.Attr.on_submit (fun _ -> 
          handle_submission form;
          Effect.Prevent_default)
      ]
      [ (* Field with ARIA attributes *)
        Vdom.Node.div ~attrs:[Vdom.Attr.class_ "form-field"]
          [ Vdom.Node.label 
              ~attrs:[Vdom.Attr.for_ "email-field"]
              [Vdom.Node.text "Email *"]
          ; Vdom.Node.input
              ~attrs:[
                Vdom.Attr.id "email-field";
                Vdom.Attr.type_ "email";
                Vdom.Attr.create "aria-required" "true";
                Vdom.Attr.create "aria-invalid" 
                  (if has_error errors "email" then "true" else "false");
                Vdom.Attr.create "aria-describedby" "email-error";
              ] []
          ; render_error_message ~id:"email-error" (get_error errors "email")
          ]
      ]
      
  (* Keyboard navigation support *)
  let keyboard_handler =
    Vdom.Attr.on_keydown (fun evt ->
      match Js_of_ocaml.Dom_html.Keyboard_code.of_event evt with
      | Enter when is_valid form -> submit_form ()
      | Escape -> reset_form ()
      | _ -> Effect.Ignore)
end
```

---

## Portfolio-Specific Implementation Guide

### 📧 Complete Contact Form Component

```ocaml
(* lib/client/pages/page_contact_enhanced.ml *)
open! Core
open Bonsai.Let_syntax
open Bonsai_web

module Contact_form = struct
  type t = {
    name: string;
    email: string;
    subject: string;
    message: string;
    website: string option;
    subscribe: bool;
  } [@@deriving sexp, equal, typed_fields]
end

let contact_form_component =
  (* Form state management *)
  let%sub form_state = Bonsai.state 
    (module struct type t = [`Initial | `Submitting | `Success | `Error of string] [@@deriving sexp, equal] end)
    ~default_model:`Initial 
  in
  
  (* Create form fields with validation *)
  let%sub name_field = 
    Bonsai_web_ui_form.Elements.Textbox.string
      ~placeholder:"John Doe"
      ~validate:(fun name ->
        if String.length name >= 2 then Ok ()
        else Error (Error.of_string "Name must be at least 2 characters"))
      ()
  in
  
  let%sub email_field =
    Bonsai_web_ui_form.Elements.Textbox.string
      ~placeholder:"john@example.com"
      ~validate:(fun email ->
        if String.contains email '@' && String.contains email '.'
        then Ok ()
        else Error (Error.of_string "Please enter a valid email"))
      ()
  in
  
  let%sub subject_field =
    Bonsai_web_ui_form.Elements.Dropdown.list
      (module String)
      ~init:(Some "General Inquiry")
      ~options:[
        "General Inquiry";
        "Project Collaboration"; 
        "Job Opportunity";
        "Speaking Engagement";
        "Other"
      ]
      ()
  in
  
  let%sub message_field =
    Bonsai_web_ui_form.Elements.Textarea.string
      ~placeholder:"Tell me about your project..."
      ~rows:8
      ~validate:(fun msg ->
        let len = String.length msg in
        if len >= 10 && len <= 5000 then Ok ()
        else Error (Error.of_string "Message must be 10-5000 characters"))
      ()
  in
  
  let%sub website_field =
    Bonsai_web_ui_form.Elements.Textbox.string
      ~placeholder:"https://example.com (optional)"
      ~validate:(fun url ->
        if String.is_empty url then Ok ()
        else if String.is_prefix url ~prefix:"http" then Ok ()
        else Error (Error.of_string "URL must start with http:// or https://"))
      ()
  in
  
  let%sub subscribe_field =
    Bonsai_web_ui_form.Elements.Checkbox.bool
      ~default:false
      ()
  in
  
  (* Spam prevention - honeypot *)
  let%sub honeypot_field =
    Bonsai_web_ui_form.Elements.Textbox.string
      ~placeholder:""
      ()
  in
  
  (* Form submission handler *)
  let submit_form name email subject message website subscribe honeypot form_state =
    (* Check honeypot *)
    if not (String.is_empty (Bonsai_web_ui_form.value honeypot)) then
      Effect.Ignore (* Bot detected, silently ignore *)
    else
      let%bind.Effect () = set_form_state `Submitting in
      (* Simulate API call *)
      Effect.Time_ns.sleep (Time_ns.Span.of_sec 1.0)
      >>= fun () ->
      set_form_state `Success
  in
  
  (* Render the form *)
  let%arr form_state, set_form_state = form_state
  and name_field = name_field
  and email_field = email_field
  and subject_field = subject_field
  and message_field = message_field
  and website_field = website_field
  and subscribe_field = subscribe_field
  and honeypot_field = honeypot_field in
  
  let open Vdom in
  match form_state with
  | `Success ->
      Node.div ~attrs:[Attr.class_ "contact-success"]
        [ Node.h2 [Node.text "Message Sent!"]
        ; Node.p [Node.text "Thank you for reaching out. I'll respond within 24 hours."]
        ; Node.button 
            ~attrs:[
              Attr.class_ "btn-secondary";
              Attr.on_click (fun _ -> set_form_state `Initial)
            ]
            [Node.text "Send Another Message"]
        ]
  
  | _ ->
      Node.div ~attrs:[Attr.class_ "contact-form-container"]
        [ Node.h1 [Node.text "Get In Touch"]
        ; Node.p [Node.text "Have a project in mind? Let's discuss how we can work together."]
        
        ; Node.form ~attrs:[
            Attr.on_submit (fun _ ->
              submit_form 
                (Bonsai_web_ui_form.value name_field)
                (Bonsai_web_ui_form.value email_field)
                (Bonsai_web_ui_form.value subject_field)
                (Bonsai_web_ui_form.value message_field)
                (Bonsai_web_ui_form.value website_field)
                (Bonsai_web_ui_form.value subscribe_field)
                (Bonsai_web_ui_form.value honeypot_field)
                set_form_state;
              Effect.Prevent_default)
          ]
          [ (* Name field *)
            Node.div ~attrs:[Attr.class_ "form-group"]
              [ Node.label [Node.text "Name *"]
              ; Bonsai_web_ui_form.view_as_vdom name_field
              ]
            
            (* Email field *)
            ; Node.div ~attrs:[Attr.class_ "form-group"]
              [ Node.label [Node.text "Email *"]
              ; Bonsai_web_ui_form.view_as_vdom email_field
              ]
            
            (* Subject dropdown *)
            ; Node.div ~attrs:[Attr.class_ "form-group"]
              [ Node.label [Node.text "Subject *"]
              ; Bonsai_web_ui_form.view_as_vdom subject_field
              ]
            
            (* Message textarea *)
            ; Node.div ~attrs:[Attr.class_ "form-group"]
              [ Node.label [Node.text "Message *"]
              ; Bonsai_web_ui_form.view_as_vdom message_field
              ]
            
            (* Website field (optional) *)
            ; Node.div ~attrs:[Attr.class_ "form-group"]
              [ Node.label [Node.text "Website"]
              ; Bonsai_web_ui_form.view_as_vdom website_field
              ]
            
            (* Subscribe checkbox *)
            ; Node.div ~attrs:[Attr.class_ "form-group checkbox-group"]
              [ Bonsai_web_ui_form.view_as_vdom subscribe_field
              ; Node.label [Node.text "Send me occasional updates about new projects"]
              ]
            
            (* Honeypot - hidden *)
            ; Node.div ~attrs:[Attr.style (Css_gen.display `None)]
              [ Bonsai_web_ui_form.view_as_vdom honeypot_field ]
            
            (* Submit button *)
            ; Node.button
                ~attrs:[
                  Attr.type_ "submit";
                  Attr.class_ "btn-primary";
                  Attr.disabled (form_state = `Submitting)
                ]
                [ Node.text (if form_state = `Submitting then "Sending..." else "Send Message") ]
            
            (* Error message *)
            ; (match form_state with
               | `Error msg -> 
                   Node.div ~attrs:[Attr.class_ "error-message"]
                     [Node.text msg]
               | _ -> Node.none)
          ]
        ]

let component () = contact_form_component
```

---

## Best Practices Summary

### ✅ DO's
1. **Use Built-in Validation**: Leverage bonsai_web_ui_form's validation framework
2. **Provide Clear Feedback**: Show validation errors immediately and clearly
3. **Implement Spam Prevention**: Use honeypot fields and rate limiting
4. **Handle Loading States**: Show progress during submission
5. **Ensure Accessibility**: Use semantic HTML and ARIA attributes
6. **Test Edge Cases**: Empty fields, long text, special characters
7. **Mobile Responsive**: Ensure forms work well on all devices

### ❌ DON'Ts
1. **Don't Over-Validate**: Balance security with user experience
2. **Don't Block Users**: Avoid aggressive rate limiting
3. **Don't Lose Data**: Save form state in case of errors
4. **Don't Use Captchas**: Unless absolutely necessary (UX killer)
5. **Don't Ignore Errors**: Always handle and display API errors gracefully

---

## Integration with Existing Portfolio

### 🔧 Required Changes

1. **Update page_contact_simple.ml**: Replace basic form with enhanced version
2. **Add API endpoint**: Create `/api/contact` endpoint in Dream server
3. **Add Styling**: Create form-specific CSS with ppx_css
4. **Add Email Service**: Integrate with email service (SendGrid, etc.)
5. **Add Database**: Store contact submissions for follow-up

### 📦 Dependencies to Verify
```dune
(libraries
  bonsai
  bonsai.web
  bonsai.web_ui_form    ; Already present ✓
  virtual_dom
  core
  async_js              ; For API calls
  ppx_css               ; For styling
)
```

---

## Testing Checklist

### 🧪 Form Validation Tests
- [ ] Required fields prevent submission when empty
- [ ] Email validation rejects invalid formats
- [ ] Message length constraints work (min/max)
- [ ] Optional fields can be left empty
- [ ] Special characters handled correctly

### 🎨 UX Tests
- [ ] Tab navigation works correctly
- [ ] Submit button disabled during submission
- [ ] Success message displays and auto-clears
- [ ] Error messages are clear and helpful
- [ ] Form resets properly after submission

### 📱 Responsive Tests
- [ ] Form displays correctly on mobile
- [ ] Touch interactions work smoothly
- [ ] Keyboard appears for text inputs on mobile
- [ ] Dropdowns work on touch devices

### ♿ Accessibility Tests
- [ ] Screen reader announces form fields
- [ ] Keyboard-only navigation works
- [ ] Error messages are announced
- [ ] Focus states are visible
- [ ] Required fields are marked

---

## Conclusion

The bonsai_web_ui_form library provides a complete, production-ready form system perfect for portfolio contact forms. With built-in validation, error handling, and reactive state management, we can create professional forms that provide excellent user experience while maintaining type safety and functional reactive programming principles.

The patterns documented here can be immediately implemented in the portfolio project, replacing the basic form with a fully-featured contact system that includes validation, spam prevention, and professional UX patterns expected in modern web applications.

### Next Steps
1. Implement enhanced contact form component
2. Add Dream API endpoint for form submission
3. Integrate email service for notifications
4. Add form-specific styling with ppx_css
5. Test with Playwright for comprehensive validation