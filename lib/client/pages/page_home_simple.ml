open! Core
open Bonsai_web
open Virtual_dom
open Shared.Types
open Components

(* Styles module using ppx_css *)
module Styles = [%css
  stylesheet
    {|
      .hero {
        min-height: 100vh;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
      }
      
      .cta_button:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
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
        color: #1a202c;
        text-align: center;
      }
      
      .section_subtitle {
        font-size: 1.2rem;
        color: #718096;
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
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        transition: all 0.3s ease;
      }
      
      .feature_card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.15);
      }
      
      .feature_icon {
        font-size: 3rem;
        margin-bottom: 1rem;
      }
      
      .feature_title {
        font-size: 1.5rem;
        font-weight: 600;
        margin-bottom: 0.5rem;
        color: #2d3748;
      }
      
      .feature_description {
        color: #718096;
        line-height: 1.6;
      }
      
      .tech_stack {
        background: #f7fafc;
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
        background: white;
        border-radius: 25px;
        font-weight: 600;
        color: #4a5568;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        transition: all 0.2s ease;
      }
      
      .tech_badge:hover {
        transform: scale(1.05);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        background: #667eea;
        color: white;
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

let hero_section =
  Bonsai.const (
    Vdom.Node.section
    ~attrs:[ Styles.hero ]
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
  )

let features_section =
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
  Bonsai.const (
    Vdom.Node.section
    ~attrs:[ Styles.section ]
    [ Vdom.Node.h2
        ~attrs:[ Styles.section_title ]
        [ Vdom.Node.text "About" ]
    ; Vdom.Node.p
        ~attrs:[ Styles.section_subtitle ]
        [ Vdom.Node.text
            ""
        ]
    ; Vdom.Node.div
        ~attrs:[ Styles.features_grid ]
        (List.map features ~f:(fun (title, subtitle, description) ->
           Vdom.Node.div
             ~attrs:[ Styles.feature_card ]
             [ Vdom.Node.h3 ~attrs:[ Styles.feature_title ] [ Vdom.Node.text title ]
             ; Vdom.Node.p
                 ~attrs:[ Styles.feature_description; Vdom.Attr.style (Css_gen.font_weight `Bold) ]
                 [ Vdom.Node.text subtitle ]
             ; Vdom.Node.p
                 ~attrs:[ Styles.feature_description ]
                 [ Vdom.Node.text description ]
             ]))
    ]
  )

let tech_stack_section =
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
  Bonsai.const (
    Vdom.Node.section
    ~attrs:[ Styles.tech_stack ]
    [ Vdom.Node.div
        ~attrs:[ Styles.section ]
        [ Vdom.Node.h2
            ~attrs:[ Styles.section_title ]
            [ Vdom.Node.text "Tech Stack" ]
        ; Vdom.Node.p
            ~attrs:[ Styles.section_subtitle ]
            [ Vdom.Node.text
                "Languages, frameworks, and tools I use to build software"
            ]
        ; Vdom.Node.div
            ~attrs:[ Styles.tech_list ]
            (List.map technologies ~f:(fun tech ->
               Vdom.Node.div ~attrs:[ Styles.tech_badge ] [ Vdom.Node.text tech ]))
        ]
    ]
  )

let component () =
  let open Bonsai.Let_syntax in
  let%sub hero = hero_section in
  let%sub features = features_section in
  let%sub tech_stack = tech_stack_section in
  let%arr hero = hero
  and features = features
  and tech_stack = tech_stack in
  Vdom.Node.div [ hero; features; tech_stack ]