open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom
open Components

module Ui = Styles.Editorial_styles.Styles

module Styles = [%css
  stylesheet
    {|
      .hero {
        min-height: calc(100vh - 4.4rem);
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

      @media (min-width: 768px) {
        .hero {
          padding: 3.5rem 2rem 3rem;
        }

        .hero_body {
          grid-template-columns: minmax(0, 1fr) auto;
          align-items: end;
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
  let profile_path = Router.get_base_path () ^ "/static/profile.png" in
  Vdom.Node.div
    ~attrs:[ Ui.page ]
    [ Vdom.Node.section
        ~attrs:[ Styles.hero ]
        [ Vdom.Node.div
            ~attrs:[ Styles.hero_inner ]
            [ Vdom.Node.div
                ~attrs:[ Styles.hero_top ]
                [ Vdom.Node.p
                    ~attrs:[ Ui.eyebrow ]
                    [ Vdom.Node.text "001 — SOFTWARE ENGINEER" ]
                ; Vdom.Node.div
                    ~attrs:[ Ui.photo_frame ]
                    [ Vdom.Node.create "img"
                        ~attrs:
                          [ Ui.photo_image
                          ; Vdom.Attr.src profile_path
                          ; Vdom.Attr.alt "Arnab Bhowmik portrait"
                          ]
                        []
                    ]
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
                        "CS @ Stony Brook University. Building high-performance systems, trading infrastructure, cloud tooling, and developer-facing software. Previously at GSK, incoming at CoreWeave."
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
            ~attrs:[ Ui.container; Ui.stats_board ]
            [ Vdom.Node.div
                ~attrs:[ Ui.stat_cell ]
                [ Vdom.Node.p ~attrs:[ Ui.stat_value ] [ Vdom.Node.text "$100K+" ]
                ; Vdom.Node.p ~attrs:[ Ui.stat_label ] [ Vdom.Node.text "TRADING PROFIT" ]
                ]
            ; Vdom.Node.div
                ~attrs:[ Ui.stat_cell ]
                [ Vdom.Node.p ~attrs:[ Ui.stat_value ] [ Vdom.Node.text "3.83" ]
                ; Vdom.Node.p ~attrs:[ Ui.stat_label ] [ Vdom.Node.text "GPA" ]
                ]
            ; Vdom.Node.div
                ~attrs:[ Ui.stat_cell ]
                [ Vdom.Node.p ~attrs:[ Ui.stat_value ] [ Vdom.Node.text "8.5M+" ]
                ; Vdom.Node.p ~attrs:[ Ui.stat_label ] [ Vdom.Node.text "CONTRACTS TRADED" ]
                ]
            ; Vdom.Node.div
                ~attrs:[ Ui.stat_cell ]
                [ Vdom.Node.p ~attrs:[ Ui.stat_value ] [ Vdom.Node.text "2027" ]
                ; Vdom.Node.p ~attrs:[ Ui.stat_label ] [ Vdom.Node.text "GRADUATING" ]
                ]
            ]
        ]
    ; footer ()
    ]
