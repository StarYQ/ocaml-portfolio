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
      
      .role_bullets {
        list-style: disc;
        padding-left: 1.5rem;
        margin-top: 0.5rem;
      }
      
      .role_bullet {
        margin-bottom: 0.5rem;
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
    , "Stony Brook University Vertically Integrated Projects (VIP) Program - Stony Brook, NY"
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
  Bonsai.const (
    Vdom.Node.div
      ~attrs:[ Styles.section ]
      [ Vdom.Node.h2
          ~attrs:[ Styles.section_title ]
          [ Vdom.Node.text "Experience" ]
      ; Vdom.Node.div
          (List.map roles ~f:(fun (title, org, date, bullets) ->
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
               ; Vdom.Node.ul
                   ~attrs:[ Styles.role_bullets ]
                   (List.map bullets ~f:(fun bullet ->
                      Vdom.Node.li
                        ~attrs:[ Styles.role_bullet ]
                        [ Vdom.Node.text bullet ]))
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

let activities_section =
  Bonsai.const (
    Vdom.Node.div
      ~attrs:[ Styles.section ]
      [ Vdom.Node.h2
          ~attrs:[ Styles.section_title ]
          [ Vdom.Node.text "Activities" ]
      ; Vdom.Node.div
          ~attrs:[ Styles.role_item ]
          [ Vdom.Node.div
              ~attrs:[ Styles.role_title ]
              [ Vdom.Node.text "Undergraduate Researcher" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.role_organization ]
              [ Vdom.Node.text "Stony Brook University - Stony Brook, NY" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.role_date ]
              [ Vdom.Node.text "December 2024 - Present" ]
          ; Vdom.Node.div
              ~attrs:[ Styles.role_description ]
              [ Vdom.Node.text "Investigating and developing foundational ML/NLP tools in OCaml to address ecosystem gaps in tokenization, text processing, and statistical text analysis." ]
          ]
      ]
  )

let component () =
  let open Bonsai.Let_syntax in
  let%sub education = education_section in
  let%sub experience = experience_section in
  let%sub skills = skills_section in
  let%sub activities = activities_section in
  let%arr education = education
  and experience = experience
  and skills = skills
  and activities = activities in
  Vdom.Node.div
    ~attrs:[ Styles.container ]
    [ Vdom.Node.h1
        ~attrs:[ Styles.page_title ]
        [ Vdom.Node.text "About Me" ]
    ; education
    ; experience
    ; skills
    ; activities
    ]