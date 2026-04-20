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
      .top_bar {
        padding: 1rem 1.5rem;
        border-bottom: 1px solid var(--border-color);
      }

      .top_bar_inner {
        width: min(100%, 72rem);
        margin: 0 auto;
      }

      .links_row {
        display: flex;
        flex-wrap: wrap;
        gap: 0.75rem;
      }

      .not_found {
        padding: 4rem 0;
      }
    |}]

let external_links (project : project) =
  List.filter_opt
    [ Option.map project.github_url ~f:(fun href -> ("GITHUB", href))
    ; Option.map project.demo_url ~f:(fun href -> ("LIVE", href))
    ]

let footer () =
  Vdom.Node.footer
    ~attrs:[ Ui.footer ]
    [ Vdom.Node.div
        ~attrs:[ Ui.footer_inner ]
        [ Vdom.Node.div
            ~attrs:[ Ui.footer_links ]
            [ Nav_link.create'
                ~route:Projects
                ~attrs:[ Ui.subtle_link ]
                [ Vdom.Node.text "ALL PROJECTS" ]
            ]
        ]
    ]

let project_view (project : project) =
  Vdom.Node.div
    ~attrs:[ Ui.page ]
    [ Vdom.Node.div
        ~attrs:[ Styles.top_bar ]
        [ Vdom.Node.div
            ~attrs:[ Styles.top_bar_inner ]
            [ Nav_link.create'
                ~route:Projects
                ~attrs:[ Ui.back_link ]
                [ Vdom.Node.text "← BACK TO PROJECTS" ]
            ]
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.header_section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container ]
            [ Vdom.Node.p ~attrs:[ Ui.eyebrow ] [ Vdom.Node.text project.id ]
            ; Vdom.Node.h1 ~attrs:[ Ui.page_title ] [ Vdom.Node.text project.title ]
            ; Vdom.Node.p ~attrs:[ Ui.body_text ] [ Vdom.Node.text project.subtitle ]
            ; Vdom.Node.p ~attrs:[ Ui.muted_text ] [ Vdom.Node.text project.year ]
            ]
        ]
    ; (if List.is_empty project.stats
       then Vdom.Node.none
       else
         Vdom.Node.section
           ~attrs:[ Ui.section ]
           [ Vdom.Node.div
               ~attrs:[ Ui.container; Ui.stats_board ]
               (List.map project.stats ~f:(fun stat ->
                    Vdom.Node.div
                      ~attrs:[ Ui.stat_cell ]
                      [ Vdom.Node.p ~attrs:[ Ui.stat_value ] [ Vdom.Node.text stat.value ]
                      ; Vdom.Node.p ~attrs:[ Ui.stat_label ] [ Vdom.Node.text stat.label ]
                      ]))
           ])
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Ui.section_grid ]
            [ Vdom.Node.div
                ~attrs:[ Ui.section_content ]
                [ Vdom.Node.p ~attrs:[ Ui.section_label ] [ Vdom.Node.text "OVERVIEW" ] ]
            ; Vdom.Node.div
                ~attrs:[ Ui.section_content ]
                (List.map project.overview ~f:(fun paragraph ->
                     Vdom.Node.p ~attrs:[ Ui.body_text ] [ Vdom.Node.text paragraph ]))
            ]
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Ui.section_grid ]
            [ Vdom.Node.div
                ~attrs:[ Ui.section_content ]
                [ Vdom.Node.p ~attrs:[ Ui.section_label ] [ Vdom.Node.text "STACK" ] ]
            ; Vdom.Node.div
                ~attrs:[ Ui.section_content ]
                [ Vdom.Node.div
                    ~attrs:[ Ui.stack_list ]
                    (List.map project.tech_stack ~f:(fun tech ->
                         Vdom.Node.span ~attrs:[ Ui.badge ] [ Vdom.Node.text tech ]))
                ; (let links = external_links project in
                   if List.is_empty links
                   then Vdom.Node.none
                   else
                     Vdom.Node.div
                       ~attrs:[ Styles.links_row ]
                       (List.map links ~f:(fun (label, href) ->
                            Vdom.Node.a
                              ~attrs:
                                [ Ui.button_secondary
                                ; Vdom.Attr.href href
                                ; Vdom.Attr.target "_blank"
                                ; Vdom.Attr.create "rel" "noopener noreferrer"
                                ]
                              [ Vdom.Node.text label ])))
                ]
            ]
        ]
    ; footer ()
    ]

let not_found_view slug =
  Vdom.Node.div
    ~attrs:[ Ui.page ]
    [ Vdom.Node.div
        ~attrs:[ Styles.top_bar ]
        [ Vdom.Node.div
            ~attrs:[ Styles.top_bar_inner ]
            [ Nav_link.create'
                ~route:Projects
                ~attrs:[ Ui.back_link ]
                [ Vdom.Node.text "← BACK TO PROJECTS" ]
            ]
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Styles.not_found ]
            [ Vdom.Node.p ~attrs:[ Ui.eyebrow ] [ Vdom.Node.text "PROJECT NOT FOUND" ]
            ; Vdom.Node.h1 ~attrs:[ Ui.page_title ] [ Vdom.Node.text "MISSING ENTRY" ]
            ; Vdom.Node.p
                ~attrs:[ Ui.body_text ]
                [ Vdom.Node.text ("No project entry exists for slug: " ^ slug) ]
            ]
        ]
    ; footer ()
    ]

let component ?(theme = Bonsai.Value.return Theme.Light) ~slug () =
  let%arr _theme = theme
  and slug = slug in
  match find_project_by_slug slug with
  | Some project -> project_view project
  | None -> not_found_view slug
