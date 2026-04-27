open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom
open Components

module Ui = Styles.Editorial_styles.Styles

module Styles = [%css
  stylesheet ~dont_hash_prefixes:[ "--" ]
    {|
      .viewer {
        width: 100%;
        min-height: 75vh;
        border: 1px solid var(--border-color);
        background: var(--surface-elevated);
      }

      .action_row {
        display: flex;
        flex-wrap: wrap;
        gap: 0.75rem;
      }
    |}]

let footer () =
  Vdom.Node.footer
    ~attrs:[ Ui.footer ]
    [ Vdom.Node.div
        ~attrs:[ Ui.footer_inner ]
        [ Vdom.Node.div
            ~attrs:[ Ui.footer_links ]
            [ Nav_link.create'
                ~route:Work
                ~attrs:[ Ui.subtle_link ]
                [ Vdom.Node.text "WORK" ]
            ; Nav_link.create'
                ~route:About
                ~attrs:[ Ui.subtle_link ]
                [ Vdom.Node.text "ABOUT" ]
            ]
        ]
    ]

let component ?(theme = Bonsai.Value.return Theme.Light) () =
  let%arr _theme = theme in
  let pdf_path = Router.get_base_path () ^ "/static/resume.pdf" in
  Vdom.Node.div
    ~attrs:[ Ui.page ]
    [ Vdom.Node.section
        ~attrs:[ Ui.header_section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container ]
            [ Vdom.Node.p ~attrs:[ Ui.eyebrow ] [ Vdom.Node.text "005 — RESUME" ]
            ; Vdom.Node.h1 ~attrs:[ Ui.page_title ] [ Vdom.Node.text "RESUME" ]
            ; Vdom.Node.p
                ~attrs:[ Ui.body_text ]
                [ Vdom.Node.text "Download the latest PDF below." ]
            ]
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Ui.section_content ]
            [ Vdom.Node.div
                ~attrs:[ Styles.action_row ]
                [ Vdom.Node.a
                    ~attrs:
                      [ Ui.button_primary
                      ; Vdom.Attr.href pdf_path
                      ; Vdom.Attr.create "download" "Arnab_Bhowmik_Resume.pdf"
                      ]
                    [ Vdom.Node.text "DOWNLOAD PDF" ]
                ; Nav_link.create'
                    ~route:Work
                    ~attrs:[ Ui.button_secondary ]
                    [ Vdom.Node.text "VIEW EXPERIENCE" ]
                ]
            ; Vdom.Node.create "iframe"
                ~attrs:
                  [ Styles.viewer
                  ; Vdom.Attr.create "src" pdf_path
                  ; Vdom.Attr.create "title" "Resume PDF Viewer"
                  ; Vdom.Attr.create "loading" "lazy"
                  ; Vdom.Attr.create "allowfullscreen" "true"
                  ]
                []
            ]
        ]
    ; footer ()
    ]
