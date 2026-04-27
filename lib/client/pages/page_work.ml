open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom
open Shared.Data
open Shared.Types

module Ui = Styles.Editorial_styles.Styles

module Styles = [%css
  stylesheet ~dont_hash_prefixes:[ "--" ]
    {|
      .experience_list {
        display: flex;
        flex-direction: column;
      }

      .experience_item {
        padding: 2rem 0;
      }

      .experience_header {
        display: flex;
        flex-direction: column;
        gap: 0.4rem;
      }

      .company_row {
        display: flex;
        align-items: flex-start;
        gap: 1rem;
        flex-wrap: wrap;
      }

      .logo_frame {
        width: clamp(5.5rem, 11vw, 7rem);
        min-width: clamp(5.5rem, 11vw, 7rem);
        height: clamp(3.5rem, 7vw, 4.5rem);
        padding: 0.7rem 0.85rem;
        border: 1px solid var(--border-color);
        background: var(--surface-elevated);
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
      }

      .logo {
        width: 100%;
        height: 100%;
        object-fit: contain;
      }

      .company_block {
        display: flex;
        flex-direction: column;
        gap: 0.4rem;
        min-width: min(100%, 16rem);
        flex: 1;
      }

      .company {
        margin: 0;
        font-size: clamp(1.35rem, 3vw, 2rem);
        letter-spacing: -0.04em;
      }

      .role {
        margin: 0;
        color: var(--text-secondary);
      }

      .meta_row {
        display: flex;
        flex-wrap: wrap;
        gap: 0.75rem 1rem;
        align-items: center;
      }

      .bullet_list {
        margin: 0;
        padding: 0;
        list-style: none;
        display: flex;
        flex-direction: column;
        gap: 0.9rem;
      }

      .bullet_item {
        display: flex;
        gap: 0.8rem;
        color: var(--text-secondary);
        line-height: 1.75;
      }

      .bullet_marker {
        color: var(--text-tertiary);
      }

      @media (max-width: 640px) {
        .company_row {
          gap: 0.85rem;
        }

        .logo_frame {
          width: 5rem;
          min-width: 5rem;
          height: 3.25rem;
          padding: 0.55rem 0.7rem;
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
            [ Vdom.Node.text "FULL RESUME AVAILABLE ON SITE" ]
        ; Vdom.Node.div
            ~attrs:[ Ui.footer_links ]
            [ Components.Nav_link.create'
                ~route:Resume
                ~attrs:[ Ui.subtle_link ]
                [ Vdom.Node.text "OPEN RESUME" ]
            ]
        ]
    ]

let logo_node (entry : experience) =
  match entry.logo_file with
  | None -> Vdom.Node.none
  | Some filename ->
    let logo_src = Components.Router.get_base_path () ^ "/static/" ^ filename in
    Vdom.Node.div
      ~attrs:[ Styles.logo_frame ]
      [ Vdom.Node.create "img"
          ~attrs:
            [ Styles.logo
            ; Vdom.Attr.src logo_src
            ; Vdom.Attr.alt (entry.company ^ " logo")
            ; Vdom.Attr.create "loading" "lazy"
            ; Vdom.Attr.create "decoding" "async"
            ]
          []
      ]

let experience_entry (entry : experience) =
  let status_attrs =
    if List.mem [ "INCOMING"; "ACTIVE" ] entry.status ~equal:String.equal
    then [ Ui.badge; Ui.badge_strong ]
    else [ Ui.badge ]
  in
  Vdom.Node.section
    ~attrs:[ Ui.section ]
    [ Vdom.Node.div
        ~attrs:[ Ui.container; Ui.section_grid ]
        [ Vdom.Node.div
            ~attrs:[ Ui.section_content ]
            [ Vdom.Node.p ~attrs:[ Ui.section_label ] [ Vdom.Node.text entry.id ]
            ; Vdom.Node.div
                ~attrs:[ Styles.experience_header ]
                [ Vdom.Node.div
                    ~attrs:[ Styles.company_row ]
                    [ logo_node entry
                    ; Vdom.Node.div
                        ~attrs:[ Styles.company_block ]
                        [ Vdom.Node.h2
                            ~attrs:[ Styles.company ]
                            [ Vdom.Node.text entry.company ]
                        ; Vdom.Node.p ~attrs:[ Styles.role ] [ Vdom.Node.text entry.role ]
                        ; Vdom.Node.p ~attrs:[ Ui.muted_text ] [ Vdom.Node.text entry.team ]
                        ]
                    ]
                ]
            ]
        ; Vdom.Node.div
            ~attrs:[ Ui.section_content ]
            [ Vdom.Node.div
                ~attrs:[ Styles.meta_row ]
                [ Vdom.Node.p ~attrs:[ Ui.muted_text ] [ Vdom.Node.text entry.period ]
                ; Vdom.Node.p ~attrs:[ Ui.muted_text ] [ Vdom.Node.text entry.location ]
                ; Vdom.Node.span ~attrs:status_attrs [ Vdom.Node.text entry.status ]
                ]
            ; (if List.is_empty entry.bullets
               then Vdom.Node.none
               else
                 Vdom.Node.ul
                   ~attrs:[ Styles.bullet_list ]
                   (List.map entry.bullets ~f:(fun bullet ->
                        Vdom.Node.li
                          ~attrs:[ Styles.bullet_item ]
                          [ Vdom.Node.span
                              ~attrs:[ Styles.bullet_marker ]
                              [ Vdom.Node.text "—" ]
                          ; Vdom.Node.span [ Vdom.Node.text bullet ]
                          ])))
            ]
        ]
    ]

let component ?(theme = Bonsai.Value.return Theme.Light) () =
  let%arr _theme = theme in
  let children =
    [ Vdom.Node.section
        ~attrs:[ Ui.header_section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container ]
            [ Vdom.Node.p ~attrs:[ Ui.eyebrow ] [ Vdom.Node.text "002 — EXPERIENCE" ]
            ; Vdom.Node.h1 ~attrs:[ Ui.page_title ] [ Vdom.Node.text "WORK" ]
            ; Vdom.Node.p
                ~attrs:[ Ui.body_text ]
                [ Vdom.Node.text
                    "Internships, teaching, and software engineering across cloud infrastructure, high-performance computing, ed tech, and full-stack software."
                ]
            ]
        ]
    ]
    @ List.map work_experiences ~f:experience_entry
    @ [ footer () ]
  in
  Vdom.Node.div
    ~attrs:[ Ui.page ]
    children
