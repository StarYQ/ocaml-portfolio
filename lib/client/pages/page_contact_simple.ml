open! Core
open Bonsai.Let_syntax
open Virtual_dom

let contact_form_component =
  let%sub name_form = Bonsai_web_ui_form.Elements.Textbox.string ~placeholder:"Your name" () in
  let%sub email_form = Bonsai_web_ui_form.Elements.Textbox.string ~placeholder:"Your email" () in  
  let%sub message_form = Bonsai_web_ui_form.Elements.Textarea.string ~placeholder:"Your message" () in
  
  let%arr name_form = name_form
  and email_form = email_form
  and message_form = message_form in
  
  Vdom.Node.div
    [ Vdom.Node.h1 [Vdom.Node.text "Contact"]
    ; Vdom.Node.p [Vdom.Node.text "Get in touch with me."]
    ; Vdom.Node.div
        [ Vdom.Node.h3 [Vdom.Node.text "Send me a message"]
        ; Bonsai_web_ui_form.view_as_vdom name_form
        ; Bonsai_web_ui_form.view_as_vdom email_form
        ; Bonsai_web_ui_form.view_as_vdom message_form
        ]
    ]

let component () = contact_form_component