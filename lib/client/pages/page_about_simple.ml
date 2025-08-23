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
              [ Vdom.Node.text "Bachelor of Science with Honors in Computer Science" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.details ]
              [ Vdom.Node.text "GPA: 3.79 • August 2023 - May 2027 (expected)" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.details ]
              [ Vdom.Node.text "Relevant Coursework: Software Development, Analysis of Algorithms: Honors, Data Structures, Object-Oriented Programming, Systems Fundamentals, Programming Abstractions, Linear Algebra, Probability & Statistics" ]
          ]
      ]
  )

let experience_section =
  let roles = [
    ( "Compute Platform Engineering Intern"
    , "GlaxoSmithKline plc - Seattle, WA"
    , "May 2025 - August 2025"
    , "Developed an interactive Python CLI that uses workload diagnosis to auto-select optimal HPC environments and optimize resource specifications, reducing compute costs by ~7%. Containerized and deployed the CLI using both Docker and Apptainer for cross-platform compatibility. Built proof of concept demonstrating architectural optimizations for AI/ML team's prototype agentic system."
    );
    ( "Teaching Assistant"
    , "Stony Brook University - Stony Brook, NY"
    , "January 2025 - December 2025"
    , "Programming Abstractions (CSE 216): Leading weekly recitations, exam review sessions, and office hours for 100+ students, covering functional programming, object-orientation, type systems, memory management, and parallel programming. Software Development (CSE 316): Incoming teaching assistant for fall 2025."
    );
    ( "Student Software Developer"
    , "Stony Brook University VIP Program - Stony Brook, NY"
    , "September 2024 - Present"
    , "Developing a mobile app to help SBU clinicians monitor patients' post-surgery recovery progress using Apple Health data and custom forms via HealthKit and ResearchKit frameworks. Leading the HealthByte subteam, creating onboarding resources, delegating tasks, and organizing meetings. Developing a full-stack Next.js web application for clinicians to interact with patient data."
    );
    ( "Full Stack Developer"
    , "QuattronKids - Remote"
    , "July 2024 - May 2025"
    , "Led full-stack development of PenguinLearn, a RESTful educational platform using Next.js, React, Supabase, and Prisma ORM, enabling migration from third-party hosting and reducing operational costs by ~20%. Implemented a real-time messaging system for direct communication between parents and teachers. Developed comprehensive test suites using Jest and Playwright."
    );
    ( "Teaching Assistant"
    , "ABCMath - Queens, NY"
    , "September 2022 - October 2024"
    , "Tutored and graded homework for programming (Python and Java), honors chemistry, and English and math classes for multiple grades. Supervised and helped guide class for programming classes. Revised material for multiple classes."
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