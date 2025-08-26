open! Core
open Bonsai_web
open Virtual_dom
open Shared.Types
open Components
open Theme

(* Styles module using ppx_css - Note: Cannot use CSS variables with ppx_css due to hashing *)
module Styles = [%css
  stylesheet
    {|
      .hero {
        min-height: 100vh;
        /* Background gradient will be set inline based on theme */
        display: flex;
        align-items: center;
        justify-content: center;
        position: relative;
        overflow: hidden;
        padding: 2rem;
      }
      
      .hero_content {
        text-align: center;
        color: white;
        z-index: 1;
        max-width: 1200px;
        animation: fadeInUp 1s ease-out;
      }
      
      @keyframes fadeInUp {
        from { 
          opacity: 0; 
          transform: translateY(30px);
        }
        to { 
          opacity: 1; 
          transform: translateY(0);
        }
      }
      
      .hero_title {
        font-size: 4rem;
        font-weight: 700;
        margin-bottom: 1rem;
        animation: slideIn 1s ease-out 0.2s both;
        line-height: 1.2;
      }
      
      @keyframes slideIn {
        from {
          opacity: 0;
          transform: translateX(-50px);
        }
        to {
          opacity: 1;
          transform: translateX(0);
        }
      }
      
      .hero_subtitle {
        font-size: 1.5rem;
        font-weight: 300;
        margin-bottom: 2rem;
        opacity: 0.95;
        animation: fadeIn 1s ease-out 0.4s both;
      }
      
      @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
      }
      
      .cta_container {
        display: flex;
        gap: 1rem;
        justify-content: center;
        flex-wrap: wrap;
        animation: fadeIn 1s ease-out 0.6s both;
      }
      
      .cta_button {
        padding: 1rem 2rem;
        background: white;
        color: #667eea;
        border-radius: 50px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.3s ease;
        display: inline-block;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
      }
      
      .cta_button:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
      }
      
      .cta_secondary {
        background: transparent;
        color: white;
        border: 2px solid white;
      }
      
      .cta_secondary:hover {
        background: white;
        color: #667eea;
      }
      
      .section {
        padding: 5rem 2rem;
        max-width: 1200px;
        margin: 0 auto;
      }
      
      .section_title {
        font-size: 2.5rem;
        font-weight: 700;
        margin-bottom: 1rem;
        /* Color will be set inline based on theme */
        text-align: center;
      }
      
      .section_subtitle {
        font-size: 1.2rem;
        /* Color will be set inline based on theme */
        text-align: center;
        margin-bottom: 3rem;
        max-width: 800px;
        margin-left: auto;
        margin-right: auto;
      }
      
      .features_grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 2rem;
        margin-top: 3rem;
      }
      
      .feature_card {
        padding: 2rem;
        /* Background will be set inline based on theme */
        border-radius: 12px;
        transition: all 0.3s ease;
      }
      
      .feature_card:hover {
        transform: translateY(-5px);
        /* Shadow will be enhanced on hover */
      }
      
      .feature_icon {
        font-size: 3rem;
        margin-bottom: 1rem;
      }
      
      .feature_title {
        font-size: 1.5rem;
        font-weight: 600;
        margin-bottom: 0.5rem;
        /* Color will be set inline based on theme */
      }
      
      .feature_description {
        /* Color will be set inline based on theme */
        line-height: 1.6;
      }
      
      .tech_stack {
        /* Background will be set inline based on theme */
        padding: 4rem 2rem;
      }
      
      .tech_list {
        display: flex;
        flex-wrap: wrap;
        gap: 1rem;
        justify-content: center;
        margin-top: 2rem;
      }
      
      .tech_badge {
        padding: 0.75rem 1.5rem;
        /* Background and color will be set inline based on theme */
        border-radius: 25px;
        font-weight: 600;
        transition: all 0.2s ease;
      }
      
      .tech_badge:hover {
        transform: scale(1.05);
        /* Hover styles will be handled via inline styles */
      }
      
      @media (max-width: 768px) {
        .hero_title {
          font-size: 2.5rem;
        }
        
        .hero_subtitle {
          font-size: 1.2rem;
        }
        
        .cta_container {
          flex-direction: column;
          align-items: center;
        }
        
        .cta_button {
          width: 200px;
          text-align: center;
        }
      }
    |}]

let hero_section theme =
  let gradient_style = 
    match theme with
    | Light -> 
        Vdom.Attr.create "style" 
          "background: linear-gradient(135deg, #667eea 0%, #764ba2 100%)"
    | Dark -> 
        Vdom.Attr.create "style" 
          "background: linear-gradient(135deg, #4c51bf 0%, #553c9a 100%)"
  in
    Vdom.Node.section
    ~attrs:[ Styles.hero; gradient_style ]
    [ Vdom.Node.div
        ~attrs:[ Styles.hero_content ]
        [ Vdom.Node.h1
            ~attrs:[ Styles.hero_title ]
            [ Vdom.Node.text "Hi, I'm Arnab!" ]
        ; Vdom.Node.p
            ~attrs:[ Styles.hero_subtitle ]
            [ Vdom.Node.text
                "Honors CS @ SBU"
            ]
        ; Vdom.Node.div
            ~attrs:[ Styles.cta_container ]
            [ Nav_link.create'
                ~route:Projects
                ~attrs:[ Styles.cta_button ]
                [ Vdom.Node.text "View Projects" ]
            ; Nav_link.create'
                ~route:Contact
                ~attrs:[ Styles.cta_button; Styles.cta_secondary ]
                [ Vdom.Node.text "Get in Touch" ]
            ]
        ]
    ]

let features_section theme =
  let card_style = 
    match theme with
    | Light -> 
        Vdom.Attr.create "style"
          "background-color: #ffffff; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);"
    | Dark -> 
        Vdom.Attr.create "style"
          "background-color: #2d3748; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);"
  in
  let title_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #1a202c;"
    | Dark -> Vdom.Attr.create "style" "color: #f7fafc;"
  in
  let text_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #4a5568;"
    | Dark -> Vdom.Attr.create "style" "color: #cbd5e0;"
  in
  let features =
    [ ( "Education"
      , "Stony Brook University"
      , "BS Computer Science (Honors) • GPA: 3.79 • Aug 2023 - May 2027" )
    ; ( "Current Roles"
      , "Teaching Assistant & Researcher"
      , "TA for Programming Abstractions (CSE 216) & Software Development (CSE 316) • Undergraduate Researcher in OCaml/ML" )
    ; ( "Experience"
      , "Software Development"
      , "Building full-stack applications with modern frameworks and technologies" )
    ]
  in
    Vdom.Node.section
    ~attrs:[ Styles.section ]
    [ Vdom.Node.h2
        ~attrs:[ Styles.section_title; title_style ]
        [ Vdom.Node.text "About" ]
    ; Vdom.Node.p
        ~attrs:[ Styles.section_subtitle; text_style ]
        [ Vdom.Node.text
            ""
        ]
    ; Vdom.Node.div
        ~attrs:[ Styles.features_grid ]
        (List.map features ~f:(fun (title, subtitle, description) ->
           Vdom.Node.div
             ~attrs:[ Styles.feature_card; card_style ]
             [ Vdom.Node.h3 ~attrs:[ Styles.feature_title; title_style ] [ Vdom.Node.text title ]
             ; Vdom.Node.p
                 ~attrs:[ Styles.feature_description; text_style; Vdom.Attr.create "style" "font-weight: bold;" ]
                 [ Vdom.Node.text subtitle ]
             ; Vdom.Node.p
                 ~attrs:[ Styles.feature_description; text_style ]
                 [ Vdom.Node.text description ]
             ]))
    ]

let tech_stack_section theme =
  let bg_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "background-color: #f7fafc;"
    | Dark -> Vdom.Attr.create "style" "background-color: #2d3748;"
  in
  let title_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #1a202c;"
    | Dark -> Vdom.Attr.create "style" "color: #f7fafc;"
  in
  let text_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #4a5568;"
    | Dark -> Vdom.Attr.create "style" "color: #cbd5e0;"
  in
  let badge_style = 
    match theme with
    | Light -> 
        Vdom.Attr.create "style"
          "background-color: #ffffff; color: #4a5568; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);"
    | Dark -> 
        Vdom.Attr.create "style"
          "background-color: #1a202c; color: #cbd5e0; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);"
  in
  let technologies =
    [ "Java"
    ; "Python"
    ; "SQL"
    ; "MongoDB"
    ; "Pinecone"
    ; "Bash"
    ; "C"
    ; "OCaml"
    ; "JavaScript"
    ; "PHP"
    ; "Swift"
    ; "Next.js"
    ; "Express.js"
    ; "Node.js"
    ; "Playwright"
    ; "Flask"
    ; "Tailwind CSS"
    ; "Docker"
    ; "AWS"
    ; "Git"
    ; "PostgreSQL"
    ]
  in
    Vdom.Node.section
    ~attrs:[ Styles.tech_stack; bg_style ]
    [ Vdom.Node.div
        ~attrs:[ Styles.section ]
        [ Vdom.Node.h2
            ~attrs:[ Styles.section_title; title_style ]
            [ Vdom.Node.text "Tech Stack" ]
        ; Vdom.Node.p
            ~attrs:[ Styles.section_subtitle; text_style ]
            [ Vdom.Node.text
                "Languages, frameworks, and tools I use to build software"
            ]
        ; Vdom.Node.div
            ~attrs:[ Styles.tech_list ]
            (List.map technologies ~f:(fun tech ->
               Vdom.Node.div ~attrs:[ Styles.tech_badge; badge_style ] [ Vdom.Node.text tech ]))
        ]
    ]

let component ?(theme = Bonsai.Value.return Light) () =
  let open Bonsai.Let_syntax in
  let%arr theme = theme in
  Vdom.Node.div [ 
    hero_section theme; 
    features_section theme; 
    tech_stack_section theme 
  ]