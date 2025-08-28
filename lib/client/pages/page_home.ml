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
      
      .contact_links {
        display: flex;
        gap: 1.5rem;
        justify-content: center;
        margin-top: 2rem;
        animation: fadeIn 1s ease-out 0.8s both;
      }
      
      .contact_link {
        width: 50px;
        height: 50px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(255, 255, 255, 0.2);
        border-radius: 50%;
        color: white;
        text-decoration: none;
        transition: all 0.3s ease;
        font-size: 1.5rem;
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.3);
      }
      
      .contact_link:hover {
        background: rgba(255, 255, 255, 0.3);
        transform: translateY(-3px) scale(1.1);
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
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
      
      .feature_subtitle {
        /* Color will be set inline based on theme */
        font-weight: bold;
        margin-bottom: 0.5rem;
      }
      
      .feature_description {
        /* Color will be set inline based on theme */
        line-height: 1.6;
      }
      
      .feature_bullets {
        margin-top: 1rem;
        padding-left: 0;
        list-style: none;
      }
      
      .feature_bullet {
        position: relative;
        padding-left: 1.5rem;
        margin-bottom: 0.5rem;
        line-height: 1.6;
      }
      
      .feature_bullet:before {
        content: "•";
        position: absolute;
        left: 0;
        color: #667eea;
        font-weight: bold;
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

(* SVG Icon helpers *)
let github_icon () =
  let open Vdom in
  let open Vdom.Attr in
  Node.create_svg "svg"
    ~attrs:[
      create "viewBox" "0 0 24 24";
      create "width" "24";
      create "height" "24";
      create "fill" "currentColor";
    ]
    [ Node.create_svg "path"
        ~attrs:[
          create "d" "M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
        ]
        []
    ]

let linkedin_icon () =
  let open Vdom in
  let open Vdom.Attr in
  Node.create_svg "svg"
    ~attrs:[
      create "viewBox" "0 0 24 24";
      create "width" "24";
      create "height" "24";
      create "fill" "currentColor";
    ]
    [ Node.create_svg "path"
        ~attrs:[
          create "d" "M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"
        ]
        []
    ]

let email_icon () =
  let open Vdom in
  let open Vdom.Attr in
  Node.create_svg "svg"
    ~attrs:[
      create "viewBox" "0 0 24 24";
      create "width" "24";
      create "height" "24";
      create "fill" "currentColor";
    ]
    [ Node.create_svg "path"
        ~attrs:[
          create "d" "M0 3v18h24v-18h-24zm6.623 7.929l-4.623 5.712v-9.458l4.623 3.746zm-4.141-5.929h19.035l-9.517 7.713-9.518-7.713zm5.694 7.188l3.824 3.099 3.83-3.104 5.612 6.817h-18.779l5.513-6.812zm9.208-1.264l4.616-3.741v9.348l-4.616-5.607z"
        ]
        []
    ]

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
            ]
        ; Vdom.Node.div
            ~attrs:[ Styles.contact_links ]
            [ Vdom.Node.a
                ~attrs:[
                  Styles.contact_link;
                  Vdom.Attr.href "https://github.com/StarYQ";
                  Vdom.Attr.target "_blank";
                  Vdom.Attr.create "aria-label" "GitHub Profile"
                ]
                [ github_icon () ]
            ; Vdom.Node.a
                ~attrs:[
                  Styles.contact_link;
                  Vdom.Attr.href "https://www.linkedin.com/in/arnab-bhowmik-12422426b/";
                  Vdom.Attr.target "_blank";
                  Vdom.Attr.create "aria-label" "LinkedIn Profile"
                ]
                [ linkedin_icon () ]
            ; Vdom.Node.a
                ~attrs:[
                  Styles.contact_link;
                  Vdom.Attr.href "mailto:arnab.bhowmik@stonybrook.edu";
                  Vdom.Attr.create "aria-label" "Email: arnab.bhowmik@stonybrook.edu";
                  Vdom.Attr.create "title" "Email: arnab.bhowmik@stonybrook.edu (Click to open mail client or copy address)"
                ]
                [ email_icon () ]
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
      , [ "BS in Computer Science (Honors)"
        ; "GPA: 3.79"
        ; "Aug 2023 - May 2027"
        ]
      )
    ; ( "Current Roles"
      , "Teaching Assistant & Researcher"
      , [ "TA for Software Development (CSE 316)"
        ; "Student Software Developer for Healthbyte, under the VIP BEAR team"
        ]
      )
    ; ( "Experience"
      , "Professional Background"
      , [ "Prev Compute Platform Engineering Intern @ GlaxoSmithKline"
        ; "Prev Full Stack Developer @ QuattronKids"
        ]
      )
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
        (List.map features ~f:(fun (title, subtitle, bullets) ->
           Vdom.Node.div
             ~attrs:[ Styles.feature_card; card_style ]
             [ Vdom.Node.h3 
                 ~attrs:[ Styles.feature_title; title_style ] 
                 [ Vdom.Node.text title ]
             ; Vdom.Node.p
                 ~attrs:[ Styles.feature_subtitle; text_style ]
                 [ Vdom.Node.text subtitle ]
             ; Vdom.Node.ul
                 ~attrs:[ Styles.feature_bullets; text_style ]
                 (List.map bullets ~f:(fun bullet ->
                   Vdom.Node.li
                     ~attrs:[ Styles.feature_bullet ]
                     [ Vdom.Node.text bullet ]
                 ))
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