open! Core
open Types

let stat label value = { label; value }

(** Portfolio projects for the v2 project listing/detail experience *)
let portfolio_projects =
  [ { id = "001"
    ; slug = "prediction-market-bot"
    ; title = "PREDICTION MARKET MAKER BOT"
    ; subtitle = "Automated trading system for prediction markets"
    ; year = "DEC 2025 — PRESENT"
    ; summary = "Designed and deployed a market-making system for prediction markets, actively trading on Polymarket."
    ; overview =
        [ "Designed and deployed a market-making system for prediction markets, actively trading on Polymarket in the US closed beta."
        ; "Implemented automated quoting, inventory management, and risk controls to provide continuous liquidity across markets."
        ; "Built the production runtime around Redis state management, PM2 supervision, AWS EC2 deployment, and system-health alerting."
        ]
    ; tags = [ "trading"; "backend" ]
    ; tech_stack = [ "Python"; "Redis"; "PM2"; "AWS EC2" ]
    ; stats =
        [ stat "TOTAL PROFIT" "$160,000+"
        ; stat "RETURN ON CAPITAL" "3,500%+"
        ; stat "CONTRACTS TRADED" "20M+"
        ; stat "NOTIONAL VOLUME" "$9.4M+"
        ; stat "TOTAL TRADES" "330K+"
        ]
    ; github_url = None
    ; demo_url = Some "https://lbtradingllc.com/polymarket-us"
    ; current = true
    ; featured = true
    }
  ; { id = "002"
    ; slug = "ta-tools"
    ; title = "TA TOOLS"
    ; subtitle = "Automation platform for teaching assistants"
    ; year = "JUL 2024 — AUG 2024"
    ; summary = "Built a full-stack automation app for teaching assistant logistics, improving task efficiency by approximately 200%."
    ; overview =
        [ "Developed a full-stack web application using Flask, Jinja, and SQLite to automate logistics tasks for teaching assistants at a tutoring center."
        ; "Improved task efficiency by approximately 200% for active users through automation of repetitive administrative work."
        ; "Integrated Beautiful Soup and Selenium WebDriver for scraping and process automation where the workflow needed live site interaction."
        ]
    ; tags = [ "web"; "backend" ]
    ; tech_stack = [ "Python"; "Flask"; "Beautiful Soup"; "Selenium WebDriver"; "SQLite"; "JavaScript" ]
    ; stats = [ stat "EFFICIENCY GAIN" "+200%" ]
    ; github_url = None
    ; demo_url = None
    ; current = false
    ; featured = true
    }
  (* ; { id = "003"
    ; slug = "healthbyte"
    ; title = "HEALTHBYTE"
    ; subtitle = "Post-surgery recovery monitoring platform"
    ; year = "SEP 2024 — PRESENT"
    ; summary = "Led development of patient-facing iOS and clinician-facing web experiences for post-surgery recovery monitoring."
    ; overview =
        [ "Led the HealthByte subteam within Stony Brook's VIP Program, coordinating onboarding, delegation, and product direction."
        ; "Developed prototype patient-facing iOS application flows using Swift, HealthKit, and ResearchKit for post-surgery recovery monitoring."
        ; "Built clinician-facing full-stack web tooling and a shared PostgreSQL-backed data model across mobile and web surfaces."
        ]
    ; tags = [ "mobile"; "web" ]
    ; tech_stack = [ "Swift"; "HealthKit"; "ResearchKit"; "PostgreSQL"; "Next.js" ]
    ; stats = []
    ; github_url = None
    ; demo_url = None
    ; current = true
    ; featured = false
    } *)
  (* ; { id = "004"
    ; slug = "regio-vinco"
    ; title = "REGIO VINCO"
    ; subtitle = "Educational geography game for primary schools"
    ; year = "SEP 2024 — PRESENT"
    ; summary = "Interactive geography game designed to improve learning outcomes for elementary and middle school students."
    ; overview =
        [ "Developing an interactive web-based geography education game within the Stony Brook VIP Program."
        ; "Iterating on versions tested with 150+ students at partnering schools to improve engagement and classroom usability."
        ; "Balancing game mechanics, curriculum alignment, and lightweight delivery for school settings."
        ]
    ; tags = [ "web" ]
    ; tech_stack = [ "Web"; "Interactive"; "Education"; "JavaScript" ]
    ; stats = [ stat "STUDENTS TESTED" "150+" ]
    ; github_url = None
    ; demo_url = None
    ; current = true
    ; featured = false
    } *)
  (* ; { id = "005"
    ; slug = "penguinlearn"
    ; title = "PENGUINLEARN"
    ; subtitle = "Full-stack educational platform"
    ; year = "JUL 2024 — MAY 2025"
    ; summary = "Led full-stack development of a production educational platform, reducing operational costs by about 20%."
    ; overview =
        [ "Led full-stack development of PenguinLearn using Next.js, React, Supabase, and Prisma ORM."
        ; "Implemented real-time parent-teacher messaging, Stripe payment processing, and Zoom API meeting automation."
        ; "Built Jest and Playwright test coverage and set up CI/CD to support reliable delivery."
        ]
    ; tags = [ "web"; "backend" ]
    ; tech_stack = [ "Next.js"; "React"; "Supabase"; "Prisma ORM"; "Stripe"; "Zoom API"; "Jest"; "Playwright" ]
    ; stats = [ stat "COST REDUCTION" "~20%" ]
    ; github_url = None
    ; demo_url = None
    ; current = false
    ; featured = false
    } *)
  ; { id = "003"
    ; slug = "ocaml-portfolio"
    ; title = "OCAML PORTFOLIO"
    ; subtitle = "Personal site built end-to-end in OCaml"
    ; year = "2025 — PRESENT"
    ; summary = "Personal portfolio site written in OCaml with Dream, Bonsai Web, js_of_ocaml, and Cloudflare Workers."
    ; overview =
        [ "Built the portfolio entirely in OCaml using Dream for the server, Bonsai Web for the client, and js_of_ocaml for the browser bundle."
        ]
    ; tags = [ "web"; "backend" ]
    ; tech_stack = [ "OCaml"; "Bonsai"; "Dream"; "js_of_ocaml"; "Dune"; "Cloudflare Workers" ]
    ; stats = []
    ; github_url = Some "https://github.com/StarYQ/ocaml-portfolio"
    ; demo_url = Some "https://arnabb.dev/"
    ; current = true
    ; featured = false
    }
  ; { id = "004"
    ; slug = "seawolf-accessibility"
    ; title = "SEAWOLF ACCESSIBILITY"
    ; subtitle = "Accessible campus navigation and route recommendation"
    ; year = "2024 — PRESENT"
    ; summary = "Interactive campus navigation system focused on accessible route recommendations and visualization."
    ; overview =
        [ "Developed an accessible campus navigation experience with real-time route recommendation and visualization."
        ; "Built a custom OpenStreetMap parser in C to preprocess graph data for shortest-path computation."
        ; "Combined elevation and accessibility features with scikit-learn and NumPy to better model route cost and suggest alternatives."
        ]
    ; tags = [ "web"; "ai"; "backend" ]
    ; tech_stack = [ "Next.js"; "FastAPI"; "Python"; "C"; "scikit-learn"; "NumPy"; "Google Maps API" ]
    ; stats = []
    ; github_url = Some "https://github.com/tarunvaid05/Seawolf-Accessibility"
    ; demo_url = Some "https://seawolf-accessibility.up.railway.app/"
    ; current = false
    ; featured = false
    }
  ; { id = "005"
    ; slug = "nutriproof"
    ; title = "NUTRIPROOF"
    ; subtitle = "Nutrition and health-claim verification extension"
    ; year = "2024"
    ; summary = "Chrome extension for analyzing health and nutrition claims with AI-assisted factual validation."
    ; overview =
        [ "Built a Chrome extension that analyzes user-selected text about health and nutrition claims."
        ; "Combined GPT-based claim processing with Wolfram Alpha queries for factual validation and verdict generation."
        ; "Added charts and color-coded verdict displays for fast interpretation of the results."
        ]
    ; tags = [ "ai"; "web" ]
    ; tech_stack = [ "Python"; "Flask"; "JavaScript"; "OpenAI API"; "Wolfram Alpha API" ]
    ; stats = []
    ; github_url = Some "https://github.com/TheGordon/NutriProof"
    ; demo_url = Some "https://devpost.com/software/nutriproof"
    ; current = false
    ; featured = false
    }
  ]

let work_experiences =
  [ { id = "001"
    ; company = "COREWEAVE"
    ; logo_file = Some "coreweave_logo.jpg"
    ; role = "Software Engineering Intern"
    ; team = "Cloud Platform API / IAM"
    ; location = "New York, NY"
    ; period = "JUN 2026 — AUG 2026"
    ; status = "INCOMING"
    ; bullets = []
    }
  ; { id = "002"
    ; company = "GLAXOSMITHKLINE"
    ; logo_file = Some "gsk-logo.png"
    ; role = "Compute Platform Engineering Intern"
    ; team = "HPC & Cloud Infrastructure"
    ; location = "Seattle, WA"
    ; period = "MAY 2025 — AUG 2025"
    ; status = "COMPLETED"
    ; bullets =
        [ "Built an interactive Python CLI that diagnoses workloads and selects optimal HPC environments across Slurm and Google Batch, reducing compute costs by about 10%."
        ; "Containerized and shipped the tool with Docker and Apptainer for cross-platform rollout to 3,000+ computational scientists."
        ; "Built proof-of-concept orchestration improvements for an AI/ML agentic system, reducing context consumption by about 35% while improving performance."
        ]
    }
  ; { id = "003"
    ; company = "STONY BROOK UNIVERSITY"
    ; logo_file = Some "sbu-logo.png"
    ; role = "Teaching Assistant"
    ; team = "CSE 216 & CSE 316"
    ; location = "Stony Brook, NY"
    ; period = "JAN 2025 — DEC 2025"
    ; status = "ACTIVE"
    ; bullets =
        [ "Led recitations, office hours, and review sessions for Programming Abstractions and Software Development."
        ; "Supported 250+ students across functional programming, software design, testing, and large-program engineering."
        ; "Revised course materials, graded assignments and exams, and helped keep course operations running smoothly."
        ]
    }
  ; { id = "004"
    ; company = "STONY BROOK VIP PROGRAM"
    ; logo_file = Some "sbu-logo.png"
    ; role = "Student Software Developer"
    ; team = "HealthByte & Regio Vinco"
    ; location = "Stony Brook, NY"
    ; period = "SEP 2024 — PRESENT"
    ; status = "ACTIVE"
    ; bullets =
        [ "Led the HealthByte subteam through delegation, onboarding, and planning."
        ; "Developed prototype patient-facing iOS and clinician-facing web apps for post-surgery recovery monitoring."
        ; "Helped build Regio Vinco, an educational geography game tested with 150+ students."
        ]
    }
  ; { id = "005"
    ; company = "QUATTRONKIDS / PENGUINLEARN"
    ; logo_file = Some "penguinlearn-logo.png"
    ; role = "Full Stack Developer"
    ; team = "Core Platform"
    ; location = "Remote"
    ; period = "JUL 2024 — MAY 2025"
    ; status = "COMPLETED"
    ; bullets =
        [ "Led full-stack development using Next.js, React, Supabase, and Prisma ORM, reducing operational costs by about 20%."
        ; "Implemented real-time messaging, Stripe payment processing, and Zoom API meeting scheduling."
        ; "Added Jest and Playwright test coverage and set up CI/CD for dependable deployments."
        ]
    }
  ; { id = "006"
    ; company = "ABCMATH"
    ; logo_file = Some "abcmath-logo.jpeg"
    ; role = "Teaching Assistant"
    ; team = "Programming, math, and science instruction"
    ; location = "Queens, NY"
    ; period = "SEP 2022 — OCT 2024"
    ; status = "COMPLETED"
    ; bullets =
        [ "Tutored programming, chemistry, English, and math across multiple grade levels."
        ; "Supported classroom instruction, supervised programming sessions, and revised class materials."
        ]
    }
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
  | Backend -> List.filter projects ~f:(fun p -> List.mem p.tags "backend" ~equal:String.equal)
  | AI -> List.filter projects ~f:(fun p -> List.mem p.tags "ai" ~equal:String.equal)
  | Trading -> List.filter projects ~f:(fun p -> List.mem p.tags "trading" ~equal:String.equal)

(** Search projects by title or description *)
let search_projects (projects : project list) query =
  let query_lower = String.lowercase query in
  List.filter projects ~f:(fun p ->
    String.is_substring (String.lowercase p.title) ~substring:query_lower ||
    String.is_substring (String.lowercase p.summary) ~substring:query_lower ||
    List.exists p.tech_stack ~f:(fun tech ->
      String.is_substring (String.lowercase tech) ~substring:query_lower
    )
  )

let featured_projects =
  List.filter portfolio_projects ~f:(fun project -> project.featured)

let secondary_projects =
  List.filter portfolio_projects ~f:(fun project -> not project.featured)

let find_project_by_slug slug =
  List.find portfolio_projects ~f:(fun project -> String.equal project.slug slug)
