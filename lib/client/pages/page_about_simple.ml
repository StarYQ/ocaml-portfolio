open! Core
open Bonsai_web
open Virtual_dom

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
        color: #1a202c;
        text-align: center;
      }
      
      .section {
        margin-bottom: 3rem;
        background: white;
        border-radius: 12px;
        padding: 2rem;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
      }
      
      .section_title {
        font-size: 1.8rem;
        font-weight: 600;
        margin-bottom: 1.5rem;
        color: #2d3748;
        border-bottom: 2px solid #e2e8f0;
        padding-bottom: 0.5rem;
      }
      
      .education_item {
        margin-bottom: 1rem;
      }
      
      .institution {
        font-size: 1.3rem;
        font-weight: 600;
        color: #2d3748;
        margin-bottom: 0.3rem;
      }
      
      .degree {
        font-size: 1.1rem;
        color: #4a5568;
        margin-bottom: 0.2rem;
      }
      
      .details {
        font-size: 1rem;
        color: #718096;
      }
      
      .role_item {
        margin-bottom: 1.5rem;
        padding-left: 1rem;
        border-left: 3px solid #667eea;
      }
      
      .role_title {
        font-size: 1.2rem;
        font-weight: 600;
        color: #2d3748;
        margin-bottom: 0.3rem;
      }
      
      .role_organization {
        font-size: 1rem;
        color: #4a5568;
        margin-bottom: 0.3rem;
      }
      
      .role_date {
        font-size: 0.9rem;
        color: #718096;
        margin-bottom: 0.5rem;
      }
      
      .role_description {
        font-size: 1rem;
        color: #4a5568;
        line-height: 1.6;
      }
      
      .skills_grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 1.5rem;
      }
      
      .skill_category {
        background: #f7fafc;
        padding: 1.5rem;
        border-radius: 8px;
      }
      
      .skill_category_title {
        font-size: 1.1rem;
        font-weight: 600;
        color: #2d3748;
        margin-bottom: 0.8rem;
      }
      
      .skill_list {
        list-style: none;
        padding: 0;
      }
      
      .skill_item {
        padding: 0.3rem 0;
        color: #4a5568;
        font-size: 1rem;
      }
      
      @media (max-width: 768px) {
        .page_title {
          font-size: 2rem;
        }
        
        .skills_grid {
          grid-template-columns: 1fr;
        }
      }
    |}]

let education_section =
  Bonsai.const (
    Vdom.Node.div
      ~attrs:[ Styles.section ]
      [ Vdom.Node.h2
          ~attrs:[ Styles.section_title ]
          [ Vdom.Node.text "Education" ]
      ; Vdom.Node.div
          ~attrs:[ Styles.education_item ]
          [ Vdom.Node.div
              ~attrs:[ Styles.institution ]
              [ Vdom.Node.text "Stony Brook University" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.degree ]
              [ Vdom.Node.text "Bachelor of Science in Computer Science (Honors)" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.details ]
              [ Vdom.Node.text "GPA: 3.79 • Expected Graduation: May 2027" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.details ]
              [ Vdom.Node.text "Relevant Coursework: Data Structures & Algorithms, Analysis of Algorithms, Computer Architecture, Software Engineering" ]
          ]
      ]
  )

let experience_section =
  let roles = [
    ( "Teaching Assistant"
    , "Stony Brook University - Computer Science Department"
    , "August 2024 - Present"
    , "Teaching assistant for CSE 214 (Data Structures) and CSE 373 (Analysis of Algorithms). Conduct office hours, grade assignments, and help students understand complex algorithmic concepts."
    );
    ( "Undergraduate Researcher"
    , "Stony Brook University - Assistive Technology Lab"
    , "February 2025 - Present"
    , "Working on Seawolf Accessibility project to develop assistive technologies for students with disabilities. Implementing features using Next.js, FastAPI, and C for system-level components."
    );
    ( "Software Developer"
    , "QuattronKids"
    , "October 2024 - Present"
    , "Developing PenguinLearn, an educational platform for children. Building interactive features with Next.js, React, and Supabase for real-time collaboration."
    );
    ( "App Developer"
    , "Stony Brook VIP Program"
    , "September 2024 - Present"
    , "Developing HealthByte mobile application using Swift, HealthKit, and ResearchKit for health data collection and analysis."
    );
  ] in
  Bonsai.const (
    Vdom.Node.div
      ~attrs:[ Styles.section ]
      [ Vdom.Node.h2
          ~attrs:[ Styles.section_title ]
          [ Vdom.Node.text "Experience" ]
      ; Vdom.Node.div
          (List.map roles ~f:(fun (title, org, date, description) ->
             Vdom.Node.div
               ~attrs:[ Styles.role_item ]
               [ Vdom.Node.div
                   ~attrs:[ Styles.role_title ]
                   [ Vdom.Node.text title ]
               ; Vdom.Node.div
                   ~attrs:[ Styles.role_organization ]
                   [ Vdom.Node.text org ]
               ; Vdom.Node.div
                   ~attrs:[ Styles.role_date ]
                   [ Vdom.Node.text date ]
               ; Vdom.Node.div
                   ~attrs:[ Styles.role_description ]
                   [ Vdom.Node.text description ]
               ]))
      ]
  )

let skills_section =
  let skills = [
    ( "Languages"
    , [ "Python"; "JavaScript"; "TypeScript"; "Java"; "C/C++"; "Swift"; "OCaml"; "SQL"; "HTML/CSS" ]
    );
    ( "Web Frameworks"
    , [ "React"; "Next.js"; "Node.js"; "Express"; "Flask"; "FastAPI"; "PHP" ]
    );
    ( "Databases & Cloud"
    , [ "PostgreSQL"; "MongoDB"; "SQLite"; "Redis"; "AWS"; "Supabase"; "Pinecone" ]
    );
    ( "Tools & Technologies"
    , [ "Git"; "Docker"; "Linux"; "REST APIs"; "GraphQL"; "JWT"; "OAuth"; "CI/CD" ]
    );
    ( "Mobile & AI"
    , [ "Swift/SwiftUI"; "HealthKit"; "ResearchKit"; "OpenAI API"; "LangChain"; "Pandas"; "NumPy" ]
    );
  ] in
  Bonsai.const (
    Vdom.Node.div
      ~attrs:[ Styles.section ]
      [ Vdom.Node.h2
          ~attrs:[ Styles.section_title ]
          [ Vdom.Node.text "Technical Skills" ]
      ; Vdom.Node.div
          ~attrs:[ Styles.skills_grid ]
          (List.map skills ~f:(fun (category, items) ->
             Vdom.Node.div
               ~attrs:[ Styles.skill_category ]
               [ Vdom.Node.div
                   ~attrs:[ Styles.skill_category_title ]
                   [ Vdom.Node.text category ]
               ; Vdom.Node.ul
                   ~attrs:[ Styles.skill_list ]
                   (List.map items ~f:(fun skill ->
                      Vdom.Node.li
                        ~attrs:[ Styles.skill_item ]
                        [ Vdom.Node.text skill ]))
               ]))
      ]
  )

let component () =
  let open Bonsai.Let_syntax in
  let%sub education = education_section in
  let%sub experience = experience_section in
  let%sub skills = skills_section in
  let%arr education = education
  and experience = experience
  and skills = skills in
  Vdom.Node.div
    ~attrs:[ Styles.container ]
    [ Vdom.Node.h1
        ~attrs:[ Styles.page_title ]
        [ Vdom.Node.text "About Me" ]
    ; education
    ; experience
    ; skills
    ]