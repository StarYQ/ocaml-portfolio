open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom
open Components

module Ui = Styles.Editorial_styles.Styles

module Styles = [%css
  stylesheet ~dont_hash_prefixes:[ "--" ]
    {|
      .intro {
        max-width: 48rem;
      }

      .interest_grid {
        display: grid;
        grid-template-columns: 1fr;
        border-top: 1px solid var(--border-color);
        border-left: 1px solid var(--border-color);
      }

      .interest_card {
        display: flex;
        flex-direction: column;
        border-right: 1px solid var(--border-color);
        border-bottom: 1px solid var(--border-color);
      }

      .image_frame {
        aspect-ratio: 4 / 3;
        border-bottom: 1px solid var(--border-color);
        background: var(--surface-muted);
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      .interest_image {
        width: 100%;
        height: 100%;
        object-fit: contain;
        filter: grayscale(1);
        transition: filter 0.35s ease;
      }

      .interest_card:hover .interest_image {
        filter: grayscale(0);
      }

      .interest_body {
        padding: 1rem;
        display: flex;
        flex-direction: column;
        gap: 0.65rem;
      }

      .caption {
        margin: 0;
        color: var(--text-secondary);
        font-size: 0.72rem;
        letter-spacing: 0.18em;
        text-transform: uppercase;
      }

      .reading_panel {
        display: grid;
        grid-template-columns: 1fr;
        border-top: 1px solid var(--border-color);
        border-left: 1px solid var(--border-color);
      }

      .reading_cell {
        padding: 1.25rem;
        border-right: 1px solid var(--border-color);
        border-bottom: 1px solid var(--border-color);
      }

      .reading_title {
        margin: 0;
        font-size: clamp(1.55rem, 4vw, 2.75rem);
        line-height: 1;
        font-weight: 500;
        text-transform: uppercase;
      }

      @media (min-width: 768px) {
        .interest_grid {
          grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .reading_panel {
          grid-template-columns: minmax(12rem, 16rem) minmax(0, 1fr);
        }
      }
    |}]

type interest =
  { image_file : string
  ; alt : string
  ; caption : string
  }

let interests =
  [ { image_file = "washington-dc.png"
    ; alt = "Traveling placeholder"
    ; caption = "Washington, DC group photo"
    }
  ; { image_file = "football.jpg"
    ; alt = "Playing football with friends"
    ; caption = "Weekend football with friends"
    }
  ]

let image_src file =
  Router.get_base_path () ^ "/static/" ^ file

let interest_card interest =
  Vdom.Node.create
    "article"
    ~attrs:[ Styles.interest_card ]
    [ Vdom.Node.div
        ~attrs:[ Styles.image_frame ]
        [ Vdom.Node.create "img"
            ~attrs:
              [ Styles.interest_image
              ; Vdom.Attr.src (image_src interest.image_file)
              ; Vdom.Attr.alt interest.alt
              ; Vdom.Attr.create "loading" "lazy"
              ; Vdom.Attr.create "decoding" "async"
              ]
            []
        ]
    ; Vdom.Node.div
        ~attrs:[ Styles.interest_body ]
        [ Vdom.Node.p ~attrs:[ Styles.caption ] [ Vdom.Node.text interest.caption ] ]
    ]

let footer () =
  Vdom.Node.footer
    ~attrs:[ Ui.footer ]
    [ Vdom.Node.div
        ~attrs:[ Ui.footer_inner ]
        [ Vdom.Node.p
            ~attrs:[ Ui.muted_text ]
            [ Vdom.Node.text "PERSONAL INTERESTS" ]
        ; Vdom.Node.div
            ~attrs:[ Ui.footer_links ]
            [ Nav_link.create'
                ~route:About
                ~attrs:[ Ui.subtle_link ]
                [ Vdom.Node.text "ABOUT" ]
            ; Nav_link.create'
                ~route:Work
                ~attrs:[ Ui.subtle_link ]
                [ Vdom.Node.text "WORK" ]
            ]
        ]
    ]

let component ?(theme = Bonsai.Value.return Theme.Light) () =
  let%arr _theme = theme in
  Vdom.Node.div
    ~attrs:[ Ui.page ]
    [ Vdom.Node.section
        ~attrs:[ Ui.header_section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container ]
            [ Vdom.Node.p ~attrs:[ Ui.eyebrow ] [ Vdom.Node.text "006 — ME" ]
            ; Vdom.Node.h1 ~attrs:[ Ui.page_title ] [ Vdom.Node.text "ME" ]
            ]
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Ui.section_grid ]
            [ Vdom.Node.p ~attrs:[ Ui.section_label ] [ Vdom.Node.text "CURRENTLY" ]
            ; Vdom.Node.div
                ~attrs:[ Ui.section_content ]
                [ Vdom.Node.p
                    ~attrs:[ Ui.body_text ]
                    [ Vdom.Node.text
                        "Currently most excited about: joining CoreWeave this summer."
                    ]
                ]
            ]
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Ui.section_grid ]
            [ Vdom.Node.p ~attrs:[ Ui.section_label ] [ Vdom.Node.text "HOBBIES" ]
            ; Vdom.Node.div
                ~attrs:[ Ui.section_content ]
                [ Vdom.Node.p
                    ~attrs:[ Ui.body_text ]
                    [ Vdom.Node.text
                        "When I'm not coding, I like to read manhwa, play badminton, play sports with friends, travel, sing karaoke, and do calisthenics."
                    ]
                ]
            ]
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Styles.interest_grid ]
            (List.map interests ~f:interest_card)
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Styles.reading_panel ]
            [ Vdom.Node.div
                ~attrs:[ Styles.reading_cell ]
                [ Vdom.Node.p ~attrs:[ Ui.section_label ] [ Vdom.Node.text "CURRENTLY READING" ] ]
            ; Vdom.Node.div
                ~attrs:[ Styles.reading_cell ]
                [ Vdom.Node.h2
                    ~attrs:[ Styles.reading_title ]
                    [ Vdom.Node.text "Omniscient Reader's Viewpoint" ]
                ]
            ]
        ]
    ; footer ()
    ]
