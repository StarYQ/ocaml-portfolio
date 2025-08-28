open! Core
open Bonsai_web
open Virtual_dom
open Theme

(* Styles module using ppx_css *)
module Styles = [%css
  stylesheet
    {|
      .container {
        padding: 3rem 2rem;
        max-width: 1200px;
        margin: 0 auto;
      }
      
      .page_title {
        font-size: 3rem;
        font-weight: 700;
        margin-bottom: 2rem;
        /* Color will be set inline based on theme */
        text-align: center;
      }
      
      .section {
        margin-bottom: 3rem;
        /* Background will be set inline based on theme */
        border-radius: 12px;
        padding: 2rem;
        /* Box-shadow will be set inline based on theme */
      }
      
      .section_title {
        font-size: 1.8rem;
        font-weight: 600;
        margin-bottom: 1.5rem;
        /* Color will be set inline based on theme */
        /* Border will be set inline based on theme */
        padding-bottom: 0.5rem;
      }
      
      .education_item {
        margin-bottom: 1rem;
      }
      
      .institution {
        font-size: 1.3rem;
        font-weight: 600;
        /* Color will be set inline based on theme */
        margin-bottom: 0.3rem;
      }
      
      .degree {
        font-size: 1.1rem;
        /* Color will be set inline based on theme */
        margin-bottom: 0.2rem;
      }
      
      .details {
        font-size: 1rem;
        /* Color will be set inline based on theme */
      }
      
      .role_item {
        margin-bottom: 1.5rem;
        padding-left: 1rem;
        /* Border color will be set inline based on theme */
      }
      
      .role_title {
        font-size: 1.2rem;
        font-weight: 600;
        /* Color will be set inline based on theme */
        margin-bottom: 0.3rem;
      }
      
      .role_organization {
        font-size: 1rem;
        /* Color will be set inline based on theme */
        margin-bottom: 0.3rem;
      }
      
      .role_date {
        font-size: 0.9rem;
        /* Color will be set inline based on theme */
        margin-bottom: 0.5rem;
      }
      
      .role_description {
        font-size: 1rem;
        /* Color will be set inline based on theme */
        line-height: 1.6;
      }
      
      .role_bullets {
        list-style: disc;
        padding-left: 1.5rem;
        margin-top: 0.5rem;
      }
      
      .role_bullet {
        margin-bottom: 0.5rem;
        /* Color will be set inline based on theme */
        line-height: 1.6;
      }
      
      .timeline_container {
        position: relative;
        padding: 2rem 0;
      }

      .timeline_line {
        position: absolute;
        left: 30px;
        top: 0;
        bottom: 0;
        width: 2px;
        /* Background will be set inline based on theme */
      }

      .timeline_item {
        position: relative;
        padding-left: 70px;
        margin-bottom: 3rem;
      }

      .timeline_dot {
        position: absolute;
        left: 20px;
        top: 8px;
        width: 20px;
        height: 20px;
        border-radius: 50%;
        /* Background will be set inline based on theme */
        border: 3px solid;
        /* Border color will be set inline based on theme */
        z-index: 1;
      }

      .timeline_date_badge {
        display: inline-block;
        padding: 0.25rem 0.75rem;
        border-radius: 20px;
        font-size: 0.9rem;
        font-weight: 600;
        margin-bottom: 0.5rem;
        /* Background and color will be set inline based on theme */
      }

      .timeline_content {
        /* Background will be set inline based on theme */
        border-radius: 12px;
        padding: 1.5rem;
        /* Box shadow will be set inline */
        transition: all 0.3s ease;
        position: relative;
      }

      .timeline_content:hover {
        transform: translateX(5px);
        /* Enhanced shadow will be set on hover */
      }

      .timeline_title {
        font-size: 1.3rem;
        font-weight: 700;
        margin-bottom: 0.3rem;
        /* Color will be set inline based on theme */
      }

      .timeline_org {
        font-size: 1rem;
        margin-bottom: 0.8rem;
        /* Color will be set inline based on theme */
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }

      .timeline_bullets {
        list-style: none;
        padding-left: 0;
        margin-top: 1rem;
      }

      .timeline_bullet {
        position: relative;
        padding-left: 1.5rem;
        margin-bottom: 0.5rem;
        line-height: 1.6;
        /* Color will be set inline based on theme */
      }

      .timeline_bullet:before {
        content: "▸";
        position: absolute;
        left: 0;
        color: #667eea;
        font-weight: bold;
      }
      
      .skills_grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 1.5rem;
      }
      
      .skill_category {
        /* Background will be set inline based on theme */
        padding: 1.5rem;
        border-radius: 8px;
      }
      
      .skill_category_title {
        font-size: 1.1rem;
        font-weight: 600;
        /* Color will be set inline based on theme */
        margin-bottom: 0.8rem;
      }
      
      .skill_list {
        list-style: none;
        padding: 0;
      }
      
      .skill_item {
        padding: 0.3rem 0;
        /* Color will be set inline based on theme */
        font-size: 1rem;
      }
      
      @media (max-width: 768px) {
        .page_title {
          font-size: 2rem;
        }
        
        .timeline_line {
          left: 15px;
        }
        
        .timeline_item {
          padding-left: 45px;
        }
        
        .timeline_dot {
          left: 5px;
          width: 16px;
          height: 16px;
        }
        
        .skills_grid {
          grid-template-columns: 1fr;
        }
      }
    |}]

let education_section theme =
  let section_style = 
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
    | Light -> 
        Vdom.Attr.create "style"
          "color: #2d3748; border-bottom: 2px solid #e2e8f0;"
    | Dark -> 
        Vdom.Attr.create "style"
          "color: #f7fafc; border-bottom: 2px solid #4a5568;"
  in
  let institution_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #2d3748;"
    | Dark -> Vdom.Attr.create "style" "color: #f7fafc;"
  in
  let text_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #4a5568;"
    | Dark -> Vdom.Attr.create "style" "color: #cbd5e0;"
  in
  let details_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #718096;"
    | Dark -> Vdom.Attr.create "style" "color: #a0aec0;"
  in
  Vdom.Node.div
      ~attrs:[ Styles.section; section_style ]
      [ Vdom.Node.h2
          ~attrs:[ Styles.section_title; title_style ]
          [ Vdom.Node.text "Education" ]
      ; Vdom.Node.div
          ~attrs:[ Styles.education_item ]
          [ Vdom.Node.div
              ~attrs:[ Styles.institution; institution_style ]
              [ Vdom.Node.text "Stony Brook University" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.degree; text_style ]
              [ Vdom.Node.text "Bachelor of Science with Honors in Computer Science" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.details; details_style ]
              [ Vdom.Node.text "GPA: 3.79 • August 2023 - May 2027 (expected)" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.details; details_style ]
              [ Vdom.Node.text "Relevant Coursework: Software Development, Analysis of Algorithms: Honors, Data Structures, Object-Oriented Programming, Systems Fundamentals, Programming Abstractions, Linear Algebra, Probability & Statistics" ]
          ]
      ]

(* SVG location icon helper *)
let location_icon () =
  let open Vdom in
  let open Vdom.Attr in
  Node.create_svg "svg"
    ~attrs:[
      create "viewBox" "0 0 24 24";
      create "width" "14";
      create "height" "14";
      create "fill" "currentColor";
      create "style" "margin-right: 6px; opacity: 0.7; vertical-align: text-bottom;";
    ]
    [ Node.create_svg "path"
        ~attrs:[
          create "d" "M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"
        ]
        []
    ]

let experience_section theme =
  let section_style = 
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
    | Light -> 
        Vdom.Attr.create "style"
          "color: #2d3748; border-bottom: 2px solid #e2e8f0;"
    | Dark -> 
        Vdom.Attr.create "style"
          "color: #f7fafc; border-bottom: 2px solid #4a5568;"
  in
  let timeline_line_style = 
    match theme with
    | Light -> 
        Vdom.Attr.create "style"
          "background: linear-gradient(180deg, #667eea 0%, #9f7aea 100%);"
    | Dark -> 
        Vdom.Attr.create "style"
          "background: linear-gradient(180deg, #9f7aea 0%, #667eea 100%);"
  in
  let timeline_dot_style = 
    match theme with
    | Light -> 
        Vdom.Attr.create "style"
          "background-color: #ffffff; border-color: #667eea;"
    | Dark -> 
        Vdom.Attr.create "style"
          "background-color: #1a202c; border-color: #9f7aea;"
  in
  let date_badge_style = 
    match theme with
    | Light -> 
        Vdom.Attr.create "style"
          "background-color: #667eea; color: #ffffff;"
    | Dark -> 
        Vdom.Attr.create "style"
          "background-color: #9f7aea; color: #ffffff;"
  in
  let content_style = 
    match theme with
    | Light -> 
        Vdom.Attr.create "style"
          "background-color: #f7fafc; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);"
    | Dark -> 
        Vdom.Attr.create "style"
          "background-color: #1a202c; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);"
  in
  let timeline_title_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #2d3748;"
    | Dark -> Vdom.Attr.create "style" "color: #f7fafc;"
  in
  let org_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #4a5568;"
    | Dark -> Vdom.Attr.create "style" "color: #cbd5e0;"
  in
  let bullet_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #4a5568;"
    | Dark -> Vdom.Attr.create "style" "color: #cbd5e0;"
  in
  
  let roles = [
    ( "Compute Platform Engineering Intern"
    , "GlaxoSmithKline plc - Seattle, WA"
    , "May 2025 - August 2025"
    , [ "Developed an interactive Python CLI that uses workload diagnosis to auto-select optimal HPC environments and optimize resource specifications when applicable, with two submission modes (automatic job script generation and direct environment access), reducing compute costs by ~7%."
      ; "Containerized and deployed the CLI using both Docker and Apptainer for cross-platform compatibility on Windows, Linux, and Unix systems, with planned rollout to 3,000+ computational scientists company-wide."
      ; "Built proof of concept demonstrating architectural optimizations for AI/ML team's prototype agentic system's tool orchestration layer, achieving ~35% reduction in context consumption while improving performance."
      ]
    );
    ( "Teaching Assistant"
    , "Stony Brook University - Stony Brook, NY"
    , "January 2025 - December 2025"
    , [ "Programming Abstractions (CSE 216): Led weekly recitations, exam review sessions, and office hours for a class of 100+ students, covering functional programming, object-orientation, type systems, memory management, program and data abstractions, parameter passing, modularity, version control, and parallel programming."
      ; "Software Development (CSE 316): Incoming teaching assistant for fall 2025."
      ; "Helped develop course materials, graded assignments/exams, and proctored exams to ensure smooth course operations."
      ]
    );
    ( "Student Software Developer"
    , "Stony Brook University VIP Program - Stony Brook, NY"
    , "September 2024 - Present"
    , [ "Develop a mobile app to help SBU clinicians monitor patients' post-surgery recovery progress by combining Apple Health data and custom forms to analyze their health via the HealthKit and ResearchKit frameworks."
      ; "Lead the HealthByte subteam, creating resources for onboarding new team members, delegating tasks, and organizing meetings."
      ; "Develop a full-stack Next.js web application for clinicians to interact with patient data gathered via the mobile app, with centralized authentication and database management for both applications."
      ]
    );
    ( "Full Stack Developer"
    , "QuattronKids - Remote"
    , "July 2024 - May 2025"
    , [ "Led full-stack development of PenguinLearn, a RESTful educational platform using Next.js, React, Supabase, and Prisma ORM, enabling migration from third-party hosting and reducing operational costs by ∼20%."
      ; "Implemented a real-time messaging system within the platform for direct communication between parents and teachers."
      ; "Developed comprehensive test suites using Jest for unit testing and Playwright for end-to-end testing, ensuring platform reliability."
      ]
    );
    ( "Teaching Assistant"
    , "ABCMath - Queens, NY"
    , "September 2022 - October 2024"
    , [ "Tutored & graded homework for programming (Python and Java), honors chemistry, & English & math classes for multiple grades; supervised & helped guide class for programming classes; revised material for multiple classes." ]
    );
  ] in
  
  Vdom.Node.div
    ~attrs:[ Styles.section; section_style ]
    [ Vdom.Node.h2
        ~attrs:[ Styles.section_title; title_style ]
        [ Vdom.Node.text "Experience" ]
    ; Vdom.Node.div
        ~attrs:[ Styles.timeline_container ]
        [ (* Timeline vertical line *)
          Vdom.Node.div
            ~attrs:[ Styles.timeline_line; timeline_line_style ]
            []
        ; (* Timeline items *)
          Vdom.Node.div
            (List.map roles ~f:(fun (title, org, date, bullets) ->
               Vdom.Node.div
                 ~attrs:[ Styles.timeline_item ]
                 [ (* Timeline dot *)
                   Vdom.Node.div
                     ~attrs:[ Styles.timeline_dot; timeline_dot_style ]
                     []
                 ; (* Content *)
                   Vdom.Node.div
                     ~attrs:[ Styles.timeline_content; content_style ]
                     [ (* Date badge *)
                       Vdom.Node.div
                         ~attrs:[ Styles.timeline_date_badge; date_badge_style ]
                         [ Vdom.Node.text date ]
                     ; (* Title *)
                       Vdom.Node.div
                         ~attrs:[ Styles.timeline_title; timeline_title_style ]
                         [ Vdom.Node.text title ]
                     ; (* Organization *)
                       Vdom.Node.div
                         ~attrs:[ Styles.timeline_org; org_style ]
                         [ location_icon (); Vdom.Node.text org ]
                     ; (* Bullets *)
                       Vdom.Node.ul
                         ~attrs:[ Styles.timeline_bullets ]
                         (List.map bullets ~f:(fun bullet ->
                            Vdom.Node.li
                              ~attrs:[ Styles.timeline_bullet; bullet_style ]
                              [ Vdom.Node.text bullet ]))
                     ]
                 ]))
        ]
    ]

let skills_section theme =
  let section_style = 
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
    | Light -> 
        Vdom.Attr.create "style"
          "color: #2d3748; border-bottom: 2px solid #e2e8f0;"
    | Dark -> 
        Vdom.Attr.create "style"
          "color: #f7fafc; border-bottom: 2px solid #4a5568;"
  in
  let category_style = 
    match theme with
    | Light -> 
        Vdom.Attr.create "style"
          "background-color: #f7fafc;"
    | Dark -> 
        Vdom.Attr.create "style"
          "background-color: #1a202c;"
  in
  let category_title_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #2d3748;"
    | Dark -> Vdom.Attr.create "style" "color: #f7fafc;"
  in
  let item_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #4a5568;"
    | Dark -> Vdom.Attr.create "style" "color: #cbd5e0;"
  in
  let skills = [
    ( "Languages/Databases"
    , [ "Java"; "Python"; "SQL (PostgreSQL, SQLite)"; "MongoDB"; "Pinecone"; "Bash"; "C"; "OCaml"; "JavaScript"; "PHP"; "Swift" ]
    );
    ( "Frameworks/Runtimes"
    , [ "Next.js"; "Express.js"; "Node.js"; "Playwright"; "Flask"; "Tailwind CSS" ]
    );
    ( "Libraries"
    , [ "NumPy"; "scikit-learn"; "pandas"; "Beautiful Soup"; "Selenium WebDriver"; "React"; "jQuery"; "pytest"; "Jest" ]
    );
    ( "Developer/DevOps Tools"
    , [ "Git"; "Docker"; "GitHub Actions"; "Ansible"; "Terraform"; "Jira"; "Slurm"; "AWS"; "GCP"; "GKE"; "OpenAI API"; "SonarQube"; "Prisma ORM" ]
    );
  ] in
  Vdom.Node.div
      ~attrs:[ Styles.section; section_style ]
      [ Vdom.Node.h2
          ~attrs:[ Styles.section_title; title_style ]
          [ Vdom.Node.text "Technical Skills" ]
      ; Vdom.Node.div
          ~attrs:[ Styles.skills_grid ]
          (List.map skills ~f:(fun (category, items) ->
             Vdom.Node.div
               ~attrs:[ Styles.skill_category; category_style ]
               [ Vdom.Node.div
                   ~attrs:[ Styles.skill_category_title; category_title_style ]
                   [ Vdom.Node.text category ]
               ; Vdom.Node.ul
                   ~attrs:[ Styles.skill_list ]
                   (List.map items ~f:(fun skill ->
                      Vdom.Node.li
                        ~attrs:[ Styles.skill_item; item_style ]
                        [ Vdom.Node.text skill ]))
               ]))
      ]

(* let activities_section theme =
  let section_style = 
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
    | Light -> 
        Vdom.Attr.create "style"
          "color: #2d3748; border-bottom: 2px solid #e2e8f0;"
    | Dark -> 
        Vdom.Attr.create "style"
          "color: #f7fafc; border-bottom: 2px solid #4a5568;"
  in
  let role_item_style = 
    match theme with
    | Light -> 
        Vdom.Attr.create "style" "border-left: 3px solid #667eea;"
    | Dark -> 
        Vdom.Attr.create "style" "border-left: 3px solid #9f7aea;"
  in
  let role_title_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #2d3748;"
    | Dark -> Vdom.Attr.create "style" "color: #f7fafc;"
  in
  let text_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #4a5568;"
    | Dark -> Vdom.Attr.create "style" "color: #cbd5e0;"
  in
  let date_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #718096;"
    | Dark -> Vdom.Attr.create "style" "color: #a0aec0;"
  in
  Vdom.Node.div
      ~attrs:[ Styles.section; section_style ]
      [ Vdom.Node.h2
          ~attrs:[ Styles.section_title; title_style ]
          [ Vdom.Node.text "Activities" ]
      ; Vdom.Node.div
          ~attrs:[ Styles.role_item; role_item_style ]
          [ Vdom.Node.div
              ~attrs:[ Styles.role_title; role_title_style ]
              [ Vdom.Node.text "Undergraduate Researcher" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.role_organization; text_style ]
              [ Vdom.Node.text "Stony Brook University - Stony Brook, NY" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.role_date; date_style ]
              [ Vdom.Node.text "December 2024 - Present" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.role_description; text_style ]
              [ Vdom.Node.text "Investigating and developing foundational ML/NLP tools in OCaml to address ecosystem gaps in tokenization, text processing, and statistical text analysis." ]
          ]
      ] *)

let component ?(theme = Bonsai.Value.return Light) () =
  let open Bonsai.Let_syntax in
  let%arr theme = theme in
  let title_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #1a202c;"
    | Dark -> Vdom.Attr.create "style" "color: #f7fafc;"
  in
  Vdom.Node.div
    ~attrs:[ Styles.container ]
    [ Vdom.Node.h1
        ~attrs:[ Styles.page_title; title_style ]
        [ Vdom.Node.text "About Me" ]
    ; education_section theme
    ; experience_section theme
    ; skills_section theme
    (* ; activities_section theme *)
    ]