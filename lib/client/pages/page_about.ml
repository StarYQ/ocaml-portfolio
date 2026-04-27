open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom
open Components

module Ui = Styles.Editorial_styles.Styles

module Styles = [%css
  stylesheet
    {|
      .group {
        display: flex;
        flex-direction: column;
        gap: 1rem;
      }

      .education_title,
      .contact_link {
        margin: 0;
        font-size: clamp(1.2rem, 3vw, 1.8rem);
        line-height: 1.15;
        text-decoration: none;
      }

      .contact_link {
        display: inline-block;
        width: fit-content;
      }

      .coursework,
      .skills_row {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
      }
    |}]

let footer () =
  Vdom.Node.footer
    ~attrs:[ Ui.footer ]
    [ Vdom.Node.div
        ~attrs:[ Ui.footer_inner ]
        [ Vdom.Node.p
            ~attrs:[ Ui.muted_text ]
            [ Vdom.Node.text "CONTACT / EDUCATION / SKILLS" ]
        ; Vdom.Node.div
            ~attrs:[ Ui.footer_links ]
            [ Nav_link.create'
                ~route:Resume
                ~attrs:[ Ui.subtle_link ]
                [ Vdom.Node.text "OPEN RESUME" ]
            ]
        ]
    ]

let skill_group label items =
  Vdom.Node.div
    ~attrs:[ Styles.group ]
    [ Vdom.Node.p ~attrs:[ Ui.muted_text ] [ Vdom.Node.text label ]
    ; Vdom.Node.div
        ~attrs:[ Styles.skills_row ]
        (List.map items ~f:(fun item ->
             Vdom.Node.span ~attrs:[ Ui.badge ] [ Vdom.Node.text item ]))
    ]

let component ?(theme = Bonsai.Value.return Theme.Light) () =
  let skills =
    [ ("LANGUAGES", [ "Java"; "Python"; "SQL"; "Bash"; "C"; "OCaml"; "JavaScript"; "PHP"; "Swift" ])
    ; ("FRAMEWORKS", [ "NumPy"; "pandas"; "React"; "Vue"; "LangChain"; "PyTorch"; "scikit-learn"; "Next.js"; "Express.js"; "Node.js"; "FastAPI" ])
    ; ("TOOLS", [ "PostgreSQL"; "MySQL"; "SQLite"; "MongoDB"; "Redis"; "Pinecone"; "Git"; "Docker"; "Kubernetes"; "GitHub Actions"; "Ansible"; "Terraform"; "PM2"; "Jira"; "Slurm"; "GCP"; "AWS" ])
    ; ("CONCEPTS", [ "Distributed Systems"; "RESTful APIs"; "Agile Development"; "Machine Learning"; "NLP"; "HPC"; "Linux/Unix"; "LLMs"; "MCP" ])
    ]
  in
  let coursework =
    [ "Software Development"
    ; "Software Engineering"
    ; "Theory of Computation: Honors"
    ; "Analysis of Algorithms: Honors"
    ; "Data Structures"
    ; "Object-Oriented Programming"
    ; "Systems Programming"
    ; "Programming Abstractions"
    ; "Machine Learning"
    ]
  in
  let%arr _theme = theme in
  Vdom.Node.div
    ~attrs:[ Ui.page ]
    [ Vdom.Node.section
        ~attrs:[ Ui.header_section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container ]
            [ Vdom.Node.p ~attrs:[ Ui.eyebrow ] [ Vdom.Node.text "004 — ABOUT" ]
            ; Vdom.Node.h1 ~attrs:[ Ui.page_title ] [ Vdom.Node.text "ABOUT" ]
            ]
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Ui.section_grid ]
            [ Vdom.Node.p ~attrs:[ Ui.section_label ] [ Vdom.Node.text "BIO" ]
            ; Vdom.Node.div
                ~attrs:[ Ui.section_content ]
                [ Vdom.Node.p
                    ~attrs:[ Ui.body_text ]
                    [ Vdom.Node.text
                        "Software engineer based in Bronx, NY. Currently pursuing a Bachelor of Science with Honors in Computer Science at Stony Brook University (GPA: 3.83), graduating May 2027."
                    ]
                ; Vdom.Node.p
                    ~attrs:[ Ui.body_text ]
                    [ Vdom.Node.text
                        "My work spans cloud infrastructure, high-performance computing, trading systems, and full-stack development. I've built systems that process millions of contracts, optimized HPC workflows for thousands of scientists, and shipped platforms used by real students and educators."
                    ]
                ; Vdom.Node.p
                    ~attrs:[ Ui.body_text ]
                    [ Vdom.Node.text
                        "Incoming Software Engineering Intern at CoreWeave for Summer 2026. Previously at GlaxoSmithKline working on compute platform engineering."
                    ]
                ]
            ]
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Ui.section_grid ]
            [ Vdom.Node.p ~attrs:[ Ui.section_label ] [ Vdom.Node.text "EDUCATION" ]
            ; Vdom.Node.div
                ~attrs:[ Ui.section_content ]
                [ Vdom.Node.h2
                    ~attrs:[ Styles.education_title ]
                    [ Vdom.Node.text "STONY BROOK UNIVERSITY" ]
                ; Vdom.Node.p
                    ~attrs:[ Ui.body_text ]
                    [ Vdom.Node.text "Bachelor of Science with Honors in Computer Science" ]
                ; Vdom.Node.div
                    ~attrs:[ Ui.footer_links ]
                    [ Vdom.Node.p ~attrs:[ Ui.muted_text ] [ Vdom.Node.text "GPA: 3.83" ]
                    ; Vdom.Node.p ~attrs:[ Ui.muted_text ] [ Vdom.Node.text "MAY 2027" ]
                    ]
                ; Vdom.Node.p ~attrs:[ Ui.muted_text ] [ Vdom.Node.text "RELEVANT COURSEWORK" ]
                ; Vdom.Node.div
                    ~attrs:[ Styles.coursework ]
                    (List.map coursework ~f:(fun course ->
                         Vdom.Node.span ~attrs:[ Ui.badge ] [ Vdom.Node.text course ]))
                ]
            ]
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Ui.section_grid ]
            [ Vdom.Node.p ~attrs:[ Ui.section_label ] [ Vdom.Node.text "SKILLS" ]
            ; Vdom.Node.div
                ~attrs:[ Ui.section_content ]
                (List.map skills ~f:(fun (label, items) -> skill_group label items))
            ]
        ]
    ; Vdom.Node.section
        ~attrs:[ Ui.section ]
        [ Vdom.Node.div
            ~attrs:[ Ui.container; Ui.section_grid ]
            [ Vdom.Node.p ~attrs:[ Ui.section_label ] [ Vdom.Node.text "CONTACT" ]
            ; Vdom.Node.div
                ~attrs:[ Ui.section_content ]
                [ Vdom.Node.p
                    ~attrs:[ Styles.contact_link; Ui.body_text ]
                    [ Vdom.Node.text "arnab.bhowmik@stonybrook.edu" ]
                ; Vdom.Node.p ~attrs:[ Ui.body_text ] [ Vdom.Node.text "929-452-9190" ]
                ; Vdom.Node.div
                    ~attrs:[ Ui.footer_links ]
                    [ Vdom.Node.a
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
                    ; Nav_link.create'
                        ~route:Resume
                        ~attrs:[ Ui.subtle_link ]
                        [ Vdom.Node.text "RESUME" ]
                    ]
                ]
            ]
        ]
    ; footer ()
    ]
