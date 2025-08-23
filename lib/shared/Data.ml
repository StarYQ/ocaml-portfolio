open! Core
open Types

(** Actual portfolio projects *)
let portfolio_projects = [
  {
    id = "ta-tools";
    title = "TA Tools";
    description = "Web application to streamline teaching assistant workflows and grading";
    long_description = "Developed a comprehensive web application to help teaching assistants manage their responsibilities more efficiently. Features include automated grading workflows, student progress tracking, assignment management, and office hours scheduling. Built with Python Flask backend and SQLite database for lightweight deployment. The tool significantly reduced grading time and improved feedback consistency across multiple TAs.";
    tags = ["web"; "backend"; "tool"];
    tech_stack = ["Python"; "Flask"; "SQLite"; "HTML/CSS"; "JavaScript"];
    github_url = Some "https://github.com/username/ta-tools";
    demo_url = None;
    featured = true;
  };
  
  {
    id = "seawolf-accessibility";
    title = "Seawolf Accessibility";
    description = "Assistive technology platform for students with disabilities";
    long_description = "Leading development of an innovative assistive technology platform designed to improve accessibility for students with disabilities at Stony Brook University. The platform includes screen reader enhancements, voice navigation, real-time captioning for lectures, and personalized learning accommodations. Working with Next.js for the frontend, FastAPI for backend services, and C for low-level system integration to ensure optimal performance for accessibility features.";
    tags = ["web"; "fullstack"; "accessibility"];
    tech_stack = ["Next.js"; "React"; "FastAPI"; "Python"; "C"; "PostgreSQL"];
    github_url = None;
    demo_url = None;
    featured = true;
  };
  
  {
    id = "real-estate-ai-assistant";
    title = "Real Estate AI Assistant";
    description = "AI-powered chatbot for real estate property search and recommendations";
    long_description = "Building an intelligent conversational assistant that helps users find their ideal properties through natural language queries. The system uses OpenAI's GPT models for natural language understanding, Pinecone vector database for semantic property search, and AWS infrastructure for scalable deployment. Features include personalized property recommendations, virtual property tours scheduling, mortgage calculations, and neighborhood insights. Integrated with multiple MLS databases for real-time property data.";
    tags = ["backend"; "ai"; "api"];
    tech_stack = ["PHP"; "OpenAI API"; "Pinecone"; "AWS"; "MySQL"; "REST API"];
    github_url = None;
    demo_url = None;
    featured = true;
  };
  
  {
    id = "nutriproof-extension";
    title = "NutriProof Chrome Extension";
    description = "Browser extension for instant nutrition fact verification using AI";
    long_description = "Created a Chrome extension that helps users verify nutritional claims on websites and social media. The extension uses computer vision to detect nutrition labels and health claims, then cross-references them with scientific databases and uses OpenAI's API to provide fact-checked information. Built with a Python Flask backend for processing and a lightweight JavaScript frontend for seamless browser integration. Helps users make informed dietary decisions by flagging misleading health claims.";
    tags = ["tool"; "ai"; "web"];
    tech_stack = ["Python"; "Flask"; "OpenAI API"; "JavaScript"; "Chrome Extension API"];
    github_url = Some "https://github.com/username/nutriproof";
    demo_url = None;
    featured = false;
  };
  
  {
    id = "penguinlearn-platform";
    title = "PenguinLearn Platform";
    description = "Interactive educational platform for children's learning";
    long_description = "Developing an engaging educational platform for QuattronKids that makes learning fun for children aged 6-12. Features include gamified lessons, interactive coding tutorials, progress tracking for parents, and real-time collaboration for group projects. Built with Next.js and React for a responsive, animated interface, and Supabase for real-time data synchronization. Implements adaptive learning algorithms to personalize content difficulty based on individual student progress.";
    tags = ["web"; "fullstack"; "education"];
    tech_stack = ["Next.js"; "React"; "TypeScript"; "Supabase"; "Tailwind CSS"];
    github_url = None;
    demo_url = Some "https://penguinlearn.com";
    featured = false;
  };
  
  {
    id = "healthbyte-app";
    title = "HealthByte Mobile App";
    description = "iOS health tracking app for medical research data collection";
    long_description = "Developing a comprehensive health tracking iOS application for the Stony Brook VIP program. The app collects health metrics using HealthKit integration, conducts research surveys through ResearchKit, and provides data visualization for both users and researchers. Features include activity tracking, symptom logging, medication reminders, and secure data export for research analysis. Built with Swift and SwiftUI for native iOS performance and user experience.";
    tags = ["mobile"; "health"; "research"];
    tech_stack = ["Swift"; "SwiftUI"; "HealthKit"; "ResearchKit"; "Core Data"];
    github_url = None;
    demo_url = None;
    featured = false;
  };
  
  {
    id = "algorithm-visualizer";
    title = "Algorithm Visualizer";
    description = "Interactive web tool for visualizing data structures and algorithms";
    long_description = "Created an educational tool to help students understand complex algorithms through interactive visualizations. Supports sorting algorithms, graph traversals, dynamic programming problems, and tree operations. Features step-by-step execution, custom input data, complexity analysis, and code generation in multiple languages. Used extensively by students in Data Structures and Analysis of Algorithms courses.";
    tags = ["web"; "tool"; "education"];
    tech_stack = ["React"; "TypeScript"; "D3.js"; "Node.js"; "Express"];
    github_url = Some "https://github.com/username/algo-visualizer";
    demo_url = Some "https://algovis.example.com";
    featured = false;
  };
  
  {
    id = "campus-events-api";
    title = "Campus Events API";
    description = "RESTful API for university event management and discovery";
    long_description = "Designed and implemented a comprehensive API for managing campus events at Stony Brook University. Features include event creation and management, RSVP tracking, location-based discovery, calendar integration, and notification systems. Built with FastAPI for high performance, PostgreSQL for data persistence, and Redis for caching. Implements OAuth 2.0 for secure authentication and role-based access control.";
    tags = ["backend"; "api"; "web"];
    tech_stack = ["FastAPI"; "Python"; "PostgreSQL"; "Redis"; "OAuth 2.0"; "Docker"];
    github_url = Some "https://github.com/username/campus-events-api";
    demo_url = None;
    featured = false;
  };
  
  {
    id = "code-review-bot";
    title = "Automated Code Review Bot";
    description = "GitHub bot for automated code quality checks and suggestions";
    long_description = "Built an intelligent code review bot that automatically analyzes pull requests for code quality issues, potential bugs, and style violations. Uses static analysis tools, custom rule engines, and machine learning models to provide constructive feedback. Integrates with GitHub Actions for seamless CI/CD pipeline integration. Currently used by multiple student organizations for maintaining code quality standards.";
    tags = ["tool"; "backend"; "automation"];
    tech_stack = ["Python"; "GitHub API"; "Docker"; "PostgreSQL"; "Celery"];
    github_url = Some "https://github.com/username/code-review-bot";
    demo_url = None;
    featured = false;
  };
]

(** Get all unique tags from projects *)
let get_all_tags projects =
  projects
  |> List.concat_map ~f:(fun p -> p.tags)
  |> List.dedup_and_sort ~compare:String.compare

(** Filter projects by tag *)
let filter_projects_by_tag projects tag =
  match tag with
  | All -> projects
  | Web -> List.filter projects ~f:(fun p -> List.mem p.tags "web" ~equal:String.equal)
  | Mobile -> List.filter projects ~f:(fun p -> List.mem p.tags "mobile" ~equal:String.equal)
  | CLI -> List.filter projects ~f:(fun p -> List.mem p.tags "cli" ~equal:String.equal)
  | Backend -> List.filter projects ~f:(fun p -> List.mem p.tags "backend" ~equal:String.equal)
  | Tool -> List.filter projects ~f:(fun p -> List.mem p.tags "tool" ~equal:String.equal)

(** Search projects by title or description *)
let search_projects (projects : project list) query =
  let query_lower = String.lowercase query in
  List.filter projects ~f:(fun p ->
    String.is_substring (String.lowercase p.title) ~substring:query_lower ||
    String.is_substring (String.lowercase p.description) ~substring:query_lower ||
    List.exists p.tech_stack ~f:(fun tech -> 
      String.is_substring (String.lowercase tech) ~substring:query_lower
    )
  )