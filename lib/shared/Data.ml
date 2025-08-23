open! Core
open Types

(** Actual portfolio projects from resume *)
let portfolio_projects = [
  {
    id = "ta-tools";
    title = "TA Tools";
    description = "Full-stack web application to automate teaching assistant logistics tasks";
    long_description = "Developed a full-stack web application to automate logistics tasks for teaching assistants at a previous workplace, improving task efficiency by approximately 200% for those who used it. Built the backend with Python and Flask for seamless web integration, using Jinja and JavaScript for the frontend and SQLite for database management.";
    tags = ["web"; "backend"; "tool"; "fullstack"];
    tech_stack = ["Python"; "Flask"; "Beautiful Soup"; "Selenium WebDriver"; "SQLite"; "JavaScript"];
    github_url = None;
    demo_url = None;
    featured = true;
  };
  
  {
    id = "seawolf-accessibility";
    title = "Seawolf Accessibility";
    description = "Interactive campus navigation web app for accessible route recommendations";
    long_description = "Developing an interactive campus navigation web app to recommend and visualize optimal accessible routes in real time. Built a custom OpenStreetMap parser in C to extract and preprocess map data to use in Dijkstra's algorithm. Mapped building entrances/exits to support indoor traversal, yielding more inclusive routing. Enhanced the route cost function using scikit-learn and NumPy to perform linear regression on aggregated cost data based on stair penalties and slope gradients computed using Google Maps Elevation API data. Using the K-nearest neighbors (KNN) algorithm to recommend alternative routes with similar accessibility characteristics.";
    tags = ["web"; "fullstack"; "ai"; "accessibility"];
    tech_stack = ["Next.js"; "FastAPI"; "Python"; "C"; "scikit-learn"; "NumPy"; "Google Maps API"];
    github_url = None;
    demo_url = Some "https://seawolf-accessibility.example.com";
    featured = true;
  };
  
  {
    id = "real-estate-ai-assistant";
    title = "Real Estate Closing AI Assistant";
    description = "AI classification system for real estate deal-closing platform";
    long_description = "Developing an AI classification system for a startup's real estate deal-closing platform using LangGraph workflows, integrating with WordPress and using Pinecone vector search to automatically organize documents, emails, and attachments for streamlined document management and communication. Managing backend infrastructure using Terraform on AWS EC2, refining data ingestion pipelines and modifying CI/CD workflows.";
    tags = ["backend"; "ai"; "api"];
    tech_stack = ["PHP"; "OpenAI API"; "Pinecone"; "AWS EC2"; "Terraform"];
    github_url = None;
    demo_url = None;
    featured = true;
  };
  
  {
    id = "nutriproof";
    title = "NutriProof";
    description = "Chrome extension for health and nutrition claim verification using AI";
    long_description = "Built a Chrome extension that uses a GPT model fine-tuned on self-curated labeled data to analyze user-selected text about health and nutrition, automatically querying Wolfram Alpha's Full Results API for factual validation. Parsed claims, generated optimized Wolfram queries, and re-integrated verified results into GPT for more accurate verdicts. Implemented interactive charts with Chart.js and color-coded verdicts for quick, intuitive accuracy assessments.";
    tags = ["tool"; "ai"; "web"];
    tech_stack = ["Python"; "Flask"; "JavaScript"; "OpenAI API"; "Wolfram Alpha API"];
    github_url = None;
    demo_url = Some "https://nutriproof-extension.example.com";
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