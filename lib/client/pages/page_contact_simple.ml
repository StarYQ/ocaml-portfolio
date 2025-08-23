open! Core
open Bonsai.Let_syntax
open Virtual_dom

(* Styles module using ppx_css *)
module Styles = [%css
  stylesheet
    {|
      .container {
        padding: 3rem 2rem;
        max-width: 800px;
        margin: 0 auto;
      }
      
      .page_title {
        font-size: 3rem;
        font-weight: 700;
        margin-bottom: 1rem;
        color: #1a202c;
        text-align: center;
      }
      
      .page_subtitle {
        font-size: 1.2rem;
        color: #718096;
        text-align: center;
        margin-bottom: 3rem;
        line-height: 1.6;
      }
      
      .form_container {
        background: white;
        border-radius: 12px;
        padding: 2.5rem;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
      }
      
      .form_title {
        font-size: 1.5rem;
        font-weight: 600;
        margin-bottom: 1.5rem;
        color: #2d3748;
      }
      
      .form_field {
        margin-bottom: 1.5rem;
      }
      
      .form_label {
        display: block;
        font-size: 1rem;
        font-weight: 500;
        color: #4a5568;
        margin-bottom: 0.5rem;
      }
      
      .contact_info {
        margin-top: 3rem;
        text-align: center;
      }
      
      .contact_methods {
        display: flex;
        justify-content: center;
        gap: 2rem;
        margin-top: 2rem;
        flex-wrap: wrap;
      }
      
      .contact_method {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.75rem 1.5rem;
        background: #f7fafc;
        border-radius: 8px;
        color: #4a5568;
        text-decoration: none;
        transition: all 0.3s ease;
      }
      
      .contact_method:hover {
        background: #667eea;
        color: white;
        transform: translateY(-2px);
      }
      
      .submit_button {
        padding: 1rem 2rem;
        background: #667eea;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 1.1rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        margin-top: 1rem;
      }
      
      .submit_button:hover {
        background: #5a67d8;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
      }
      
      @media (max-width: 768px) {
        .page_title {
          font-size: 2rem;
        }
        
        .contact_methods {
          flex-direction: column;
          align-items: center;
        }
      }
    |}]

let contact_form_component =
  let%sub name_form = 
    Bonsai_web_ui_form.Elements.Textbox.string 
      ~placeholder:"John Doe" 
      () 
  in
  let%sub email_form = 
    Bonsai_web_ui_form.Elements.Textbox.string 
      ~placeholder:"john.doe@example.com" 
      () 
  in  
  let%sub message_form = 
    Bonsai_web_ui_form.Elements.Textarea.string 
      ~placeholder:"Tell me about your project or opportunity..." 
      () 
  in
  
  let%arr name_form = name_form
  and email_form = email_form
  and message_form = message_form in
  
  Vdom.Node.div
    ~attrs:[ Styles.container ]
    [ Vdom.Node.h1 
        ~attrs:[ Styles.page_title ]
        [ Vdom.Node.text "Get In Touch" ]
    ; Vdom.Node.p 
        ~attrs:[ Styles.page_subtitle ]
        [ Vdom.Node.text 
            "I'm always interested in new opportunities and collaborations. \
             Whether you have a project in mind, need technical assistance, \
             or just want to connect, I'd love to hear from you." ]
    ; Vdom.Node.div
        ~attrs:[ Styles.form_container ]
        [ Vdom.Node.h3 
            ~attrs:[ Styles.form_title ]
            [ Vdom.Node.text "Send a Message" ]
        ; Vdom.Node.div
            ~attrs:[ Styles.form_field ]
            [ Vdom.Node.label
                ~attrs:[ Styles.form_label ]
                [ Vdom.Node.text "Name" ]
            ; Bonsai_web_ui_form.view_as_vdom name_form
            ]
        ; Vdom.Node.div
            ~attrs:[ Styles.form_field ]
            [ Vdom.Node.label
                ~attrs:[ Styles.form_label ]
                [ Vdom.Node.text "Email" ]
            ; Bonsai_web_ui_form.view_as_vdom email_form
            ]
        ; Vdom.Node.div
            ~attrs:[ Styles.form_field ]
            [ Vdom.Node.label
                ~attrs:[ Styles.form_label ]
                [ Vdom.Node.text "Message" ]
            ; Bonsai_web_ui_form.view_as_vdom message_form
            ]
        ; Vdom.Node.button
            ~attrs:[ Styles.submit_button ]
            [ Vdom.Node.text "Send Message" ]
        ]
    ; Vdom.Node.div
        ~attrs:[ Styles.contact_info ]
        [ Vdom.Node.p
            ~attrs:[ Vdom.Attr.style (Css_gen.create ~field:"color" ~value:"#718096") ]
            [ Vdom.Node.text "Or connect with me through:" ]
        ; Vdom.Node.div
            ~attrs:[ Styles.contact_methods ]
            [ Vdom.Node.a
                ~attrs:[ 
                  Styles.contact_method; 
                  Vdom.Attr.href "https://github.com/username";
                  Vdom.Attr.target "_blank"
                ]
                [ Vdom.Node.text "GitHub" ]
            ; Vdom.Node.a
                ~attrs:[ 
                  Styles.contact_method; 
                  Vdom.Attr.href "https://linkedin.com/in/username";
                  Vdom.Attr.target "_blank"
                ]
                [ Vdom.Node.text "LinkedIn" ]
            ; Vdom.Node.a
                ~attrs:[ 
                  Styles.contact_method; 
                  Vdom.Attr.href "mailto:email@example.com"
                ]
                [ Vdom.Node.text "Email" ]
            ]
        ]
    ]

let component () = contact_form_component