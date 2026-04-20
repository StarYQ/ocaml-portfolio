open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom
open Shared.Data
open Shared.Types
open Components

module Ui = Styles.Editorial_styles.Styles

module Styles = [%css
  stylesheet
    {|
      .featured_row {
        display: grid;
        grid-template-columns: 1fr;
        gap: 2rem;
      }

      .featured_header {
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
      }

      .featured_title {
        margin: 0;
        font-size: clamp(2rem, 5vw, 3.8rem);
        line-height: 0.94;
        letter-spacing: -0.05em;
      }

      .summary {
        margin: 0;
        color: inherit;
        opacity: 0.76;
        line-height: 1.8;
      }

      .stack_row {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
      }

      .stats_grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 1rem;
      }

      .stat_block {
        display: flex;
        flex-direction: column;
        gap: 0.2rem;
      }

      .stat_value {
        margin: 0;
        font-size: clamp(1.5rem, 3vw, 2.25rem);
        line-height: 1;
        letter-spacing: -0.04em;
      }

      .stat_label {
        margin: 0;
        opacity: 0.6;
        font-size: 0.72rem;
        letter-spacing: 0.22em;
        text-transform: uppercase;
      }

      .secondary_title {
        margin: 0 0 1rem;
      }

      @media (min-width: 768px) {
        .featured_row {
          grid-template-columns: minmax(0, 1fr) auto;
          align-items: start;
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
            [ Vdom.Node.text "SELECTED PROJECTS AND EXPERIMENTS" ]
        ; Vdom.Node.div
            ~attrs:[ Ui.footer_links ]
            [ Nav_link.create'
                ~route:Home
                ~attrs:[ Ui.subtle_link ]
                [ Vdom.Node.text "BACK HOME" ]
            ]
        ]
    ]

let project_link route attrs children =
  Nav_link.create' ~route ~attrs children

let featured_project (project : project) =
  project_link
    (Project_detail project.slug)
    [ Ui.list_link ]
    [ Vdom.Node.div
        ~attrs:[ Ui.container; Styles.featured_row ]
        [ Vdom.Node.div
            ~attrs:[ Styles.featured_header ]
            [ Vdom.Node.p ~attrs:[ Ui.muted_text ] [ Vdom.Node.text project.id ]
            ; Vdom.Node.h2 ~attrs:[ Styles.featured_title ] [ Vdom.Node.text project.title ]
            ; Vdom.Node.p ~attrs:[ Styles.summary ] [ Vdom.Node.text project.summary ]
            ; Vdom.Node.div
                ~attrs:[ Styles.stack_row ]
                (List.map project.tech_stack ~f:(fun tech ->
                     Vdom.Node.span ~attrs:[ Ui.badge ] [ Vdom.Node.text tech ]))
            ]
        ; (if List.is_empty project.stats
           then Vdom.Node.none
           else
             Vdom.Node.div
               ~attrs:[ Styles.stats_grid ]
               (List.map project.stats ~f:(fun stat ->
                    Vdom.Node.div
                      ~attrs:[ Styles.stat_block ]
                      [ Vdom.Node.p ~attrs:[ Styles.stat_value ] [ Vdom.Node.text stat.value ]
                      ; Vdom.Node.p ~attrs:[ Styles.stat_label ] [ Vdom.Node.text stat.label ]
                      ])))
        ]
    ; Vdom.Node.div
        ~attrs:[ Ui.container ]
        [ Vdom.Node.p ~attrs:[ Ui.muted_text ] [ Vdom.Node.text project.year ] ]
    ]

let secondary_project (project : project) =
  project_link
    (Project_detail project.slug)
    [ Ui.secondary_card ]
    [ Vdom.Node.p ~attrs:[ Ui.muted_text ] [ Vdom.Node.text project.id ]
    ; Vdom.Node.h3 ~attrs:[ Styles.secondary_title ] [ Vdom.Node.text project.title ]
    ; Vdom.Node.p ~attrs:[ Ui.body_text ] [ Vdom.Node.text project.subtitle ]
    ; Vdom.Node.div
        ~attrs:[ Styles.stack_row ]
        (List.map (List.take project.tech_stack (Int.min 3 (List.length project.tech_stack))) ~f:(fun tech ->
             Vdom.Node.span ~attrs:[ Ui.muted_text ] [ Vdom.Node.text tech ]))
    ; Vdom.Node.p ~attrs:[ Ui.muted_text ] [ Vdom.Node.text project.year ]
    ]

let component ?(theme = Bonsai.Value.return Theme.Light) () =
  let%arr _theme = theme in
  Vdom.Node.div
    ~attrs:[ Ui.page ]
    [ Vdom.Node.section
        ~attrs:[ Ui.header_section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container ]
            [ Vdom.Node.p ~attrs:[ Ui.eyebrow ] [ Vdom.Node.text "003 — PROJECTS" ]
            ; Vdom.Node.h1
                ~attrs:[ Ui.page_title ]
                [ Vdom.Node.text "SELECTED"
                ; Vdom.Node.create "br" []
                ; Vdom.Node.text "WORKS"
                ]
            ]
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Ui.list_block ]
            (List.map featured_projects ~f:featured_project)
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container ]
            [ Vdom.Node.p ~attrs:[ Ui.eyebrow ] [ Vdom.Node.text "OTHER PROJECTS" ]
            ; Vdom.Node.div
                ~attrs:[ Ui.secondary_grid ]
                (List.map secondary_projects ~f:secondary_project)
            ]
        ]
    ; footer ()
    ]
