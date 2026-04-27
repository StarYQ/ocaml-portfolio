open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom
open Components

module Ui = Styles.Editorial_styles.Styles

module Styles = [%css
  stylesheet ~dont_hash_prefixes:[ "--" ]
    {|
      .page_shell {
        display: flex;
        flex-direction: column;
        min-height: calc(100vh - 4.4rem);
      }

      .hero {
        flex: 1 1 auto;
        display: flex;
        align-items: center;
        padding: 3rem 1.5rem 2.5rem;
        border-bottom: 1px solid var(--border-color);
      }

      .hero_inner {
        width: min(100%, 72rem);
        margin: 0 auto;
      }

      .hero_top {
        display: flex;
        align-items: flex-start;
        justify-content: space-between;
        gap: 1.25rem;
      }

      .hero_body {
        margin-top: 2rem;
        display: grid;
        grid-template-columns: 1fr;
        gap: 2rem;
      }

      .description {
        margin: 0;
        max-width: 32rem;
        color: var(--text-secondary);
        line-height: 1.8;
      }

      .trading_panel {
        display: flex;
        flex-direction: column;
        gap: 1rem;
      }

      .trading_links {
        display: grid;
        grid-template-columns: 1fr;
        border-top: 1px solid var(--border-color);
        border-left: 1px solid var(--border-color);
      }

      .trading_link {
        display: block;
        padding: 1.25rem;
        border-right: 1px solid var(--border-color);
        border-bottom: 1px solid var(--border-color);
        color: inherit;
        text-decoration: none;
        transition: background-color 0.2s ease, color 0.2s ease;
      }

      .trading_link:hover {
        background: var(--text-primary);
        color: var(--bg-primary);
      }

      .trading_value {
        margin: 0;
        font-size: clamp(1.2rem, 2vw, 1.75rem);
        line-height: 1.15;
        letter-spacing: -0.03em;
        font-weight: 500;
        word-break: break-word;
      }

      @media (min-width: 768px) {
        .hero {
          padding: 3.5rem 2rem 3rem;
        }

        .hero_body {
          grid-template-columns: minmax(0, 1fr) auto;
          align-items: end;
        }

        .trading_links {
          grid-template-columns: repeat(2, minmax(0, 1fr));
        }

      }

      @media (max-width: 767px) {
        .page_shell {
          min-height: calc(100vh - 7rem);
        }
      }
    |}]

let footer () =
  Vdom.Node.footer
    ~attrs:[ Ui.footer ]
    [ Vdom.Node.div
        ~attrs:[ Ui.footer_inner ]
        [ Vdom.Node.p
            ~attrs:[ Ui.muted_text ]
            [ Vdom.Node.text "BRONX, NY" ]
        ; Vdom.Node.div
            ~attrs:[ Ui.footer_links ]
            [ Vdom.Node.a
                ~attrs:
                  [ Ui.subtle_link
                  ; Vdom.Attr.href "mailto:arnab.bhowmik@stonybrook.edu"
                  ]
                [ Vdom.Node.text "EMAIL" ]
            ; Vdom.Node.a
                ~attrs:
                  [ Ui.subtle_link
                  ; Vdom.Attr.href "https://github.com/StarYQ"
                  ; Vdom.Attr.target "_blank"
                  ; Vdom.Attr.create "rel" "noopener noreferrer"
                  ]
                [ Vdom.Node.text "GITHUB" ]
            ; Vdom.Node.a
                ~attrs:
                  [ Ui.subtle_link
                  ; Vdom.Attr.href "https://linkedin.com/in/arnabbhowmik"
                  ; Vdom.Attr.target "_blank"
                  ; Vdom.Attr.create "rel" "noopener noreferrer"
                  ]
                [ Vdom.Node.text "LINKEDIN" ]
            ]
        ]
    ]

let component ?(theme = Bonsai.Value.return Theme.Light) () =
  let%arr _theme = theme in
  Vdom.Node.div
    ~attrs:[ Ui.page; Styles.page_shell ]
    [ Vdom.Node.section
        ~attrs:[ Styles.hero ]
        [ Vdom.Node.div
            ~attrs:[ Styles.hero_inner ]
            [ Vdom.Node.div
                ~attrs:[ Styles.hero_top ]
                [ Vdom.Node.p
                    ~attrs:[ Ui.eyebrow ]
                    [ Vdom.Node.text "001 — SOFTWARE ENGINEER" ]
                ]
            ; Vdom.Node.h1
                ~attrs:[ Ui.display_title ]
                [ Vdom.Node.text "ARNAB"
                ; Vdom.Node.create "br" []
                ; Vdom.Node.text "BHOWMIK"
                ]
            ; Vdom.Node.div
                ~attrs:[ Styles.hero_body ]
                [ Vdom.Node.p
                    ~attrs:[ Styles.description ]
                    [ Vdom.Node.text
                        "CS @ Stony Brook University. Interested in HPC infrastructure, cloud tooling, distributed systems, and agentic AI. Prev SWE Intern @ GSK, incoming @ CoreWeave."
                    ]
                ; Vdom.Node.div
                    ~attrs:[ Ui.button_row ]
                    [ Nav_link.create'
                        ~route:Projects
                        ~attrs:[ Ui.button_primary ]
                        [ Vdom.Node.text "VIEW PROJECTS" ]
                    ; Nav_link.create'
                        ~route:Work
                        ~attrs:[ Ui.button_secondary ]
                        [ Vdom.Node.text "EXPERIENCE" ]
                    ; Nav_link.create'
                        ~route:Resume
                        ~attrs:[ Ui.button_secondary ]
                        [ Vdom.Node.text "RESUME" ]
                    ]
                ]
            ]
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Styles.trading_panel ]
            [ Vdom.Node.p ~attrs:[ Ui.eyebrow ] [ Vdom.Node.text "For LB Trading:" ]
            ; Vdom.Node.div
                ~attrs:[ Styles.trading_links ]
                [ Vdom.Node.a
                    ~attrs:
                      [ Styles.trading_link
                      ; Vdom.Attr.href "https://lbtrading.com"
                      ; Vdom.Attr.target "_blank"
                      ; Vdom.Attr.create "rel" "noopener noreferrer"
                      ]
                    [ Vdom.Node.p ~attrs:[ Styles.trading_value ] [ Vdom.Node.text "lbtrading.com" ] ]
                ; Vdom.Node.a
                    ~attrs:
                      [ Styles.trading_link
                      ; Vdom.Attr.href "mailto:arnab@lbtrading.com"
                      ]
                    [ Vdom.Node.p
                        ~attrs:[ Styles.trading_value ]
                        [ Vdom.Node.text "arnab@lbtrading.com" ]
                    ]
                ]
            ]
        ]
    ; footer ()
    ]
