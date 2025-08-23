open! Core
open Types

(** Sample portfolio projects with comprehensive data *)
let portfolio_projects = [
  {
    id = "bonsai-portfolio";
    title = "Bonsai Portfolio Website";
    description = "Modern portfolio built entirely in OCaml using Bonsai Web framework";
    long_description = "A fully functional portfolio website showcasing the power of OCaml for frontend development. Built with Jane Street's Bonsai framework for functional reactive programming, Dream web server for the backend, and zero JavaScript. Features type-safe routing, reactive UI components, and compile-time CSS validation with ppx_css.";
    tags = ["web"; "frontend"; "fullstack"];
    tech_stack = ["OCaml"; "Bonsai Web"; "Dream"; "Dune"; "ppx_css"; "js_of_ocaml"];
    github_url = Some "https://github.com/user/bonsai-portfolio";
    demo_url = Some "https://portfolio.example.com";
    featured = true;
  };
  
  {
    id = "ocaml-compiler-extension";
    title = "OCaml PPX Extension Library";
    description = "Custom preprocessor extension for automatic code generation";
    long_description = "A sophisticated PPX rewriter that eliminates boilerplate code in OCaml applications. Provides automatic generation of comparison functions, serializers, and API client code from type definitions. Reduces code duplication by 40% and improves type inference in complex generic scenarios.";
    tags = ["tool"; "compiler"; "library"];
    tech_stack = ["OCaml"; "PPX"; "AST"; "Compiler-libs"; "OMP"];
    github_url = Some "https://github.com/user/ocaml-ppx-extension";
    demo_url = None;
    featured = true;
  };
  
  {
    id = "distributed-task-queue";
    title = "Distributed Task Queue System";
    description = "High-performance job processing system with automatic failover";
    long_description = "Production-grade distributed task queue capable of processing millions of jobs daily. Features automatic failover, intelligent load balancing, dead letter queues, and real-time monitoring. Built with Lwt for concurrent I/O, PostgreSQL for persistence, and Redis for caching. Achieves sub-second latency at scale.";
    tags = ["backend"; "distributed"; "infrastructure"];
    tech_stack = ["OCaml"; "Lwt"; "PostgreSQL"; "Redis"; "Docker"; "Kubernetes"];
    github_url = Some "https://github.com/user/ocaml-task-queue";
    demo_url = None;
    featured = true;
  };
  
  {
    id = "cli-task-manager";
    title = "Terminal Task Manager";
    description = "Beautiful CLI application for task management with rich TUI";
    long_description = "A modern terminal-based task management application with a rich text user interface. Features include project organization, tags, due dates, priority levels, and vim-style keybindings. Built with Notty for terminal graphics and Lwt for responsive user interaction.";
    tags = ["cli"; "productivity"; "tool"];
    tech_stack = ["OCaml"; "Notty"; "Lwt"; "SQLite"; "ANSITerminal"];
    github_url = Some "https://github.com/user/ocaml-taskman";
    demo_url = None;
    featured = false;
  };
  
  {
    id = "realtime-analytics";
    title = "Real-time Analytics Engine";
    description = "Stream processing engine for real-time data analytics";
    long_description = "High-throughput stream processing engine designed for real-time analytics and incremental computation. Processes 100K+ events per second with minimal memory overhead. Features windowed aggregations, exactly-once processing semantics, and automatic backpressure handling.";
    tags = ["backend"; "data"; "streaming"];
    tech_stack = ["OCaml"; "Async"; "Incremental"; "Kafka"; "ClickHouse"; "Prometheus"];
    github_url = Some "https://github.com/user/ocaml-analytics";
    demo_url = None;
    featured = false;
  };
  
  {
    id = "web-scraper";
    title = "Concurrent Web Scraper";
    description = "High-performance web scraping framework with rate limiting";
    long_description = "Extensible web scraping framework with built-in rate limiting, retry logic, and concurrent processing. Supports custom parsers, automatic cookie handling, and JavaScript rendering through headless browser integration. Respects robots.txt and implements polite crawling strategies.";
    tags = ["web"; "tool"; "data"];
    tech_stack = ["OCaml"; "Cohttp"; "Lwt"; "Lambdasoup"; "PostgreSQL"];
    github_url = Some "https://github.com/user/ocaml-scraper";
    demo_url = None;
    featured = false;
  };
  
  {
    id = "graphql-server";
    title = "Type-safe GraphQL Server";
    description = "GraphQL server with compile-time schema validation";
    long_description = "A GraphQL server implementation that leverages OCaml's type system for compile-time schema validation. Features automatic resolver generation from types, subscription support via WebSockets, and built-in performance monitoring. Integrates seamlessly with existing OCaml web frameworks.";
    tags = ["backend"; "web"; "api"];
    tech_stack = ["OCaml"; "Dream"; "GraphQL"; "PostgreSQL"; "WebSocket"];
    github_url = Some "https://github.com/user/ocaml-graphql";
    demo_url = Some "https://api.example.com/graphql";
    featured = false;
  };
  
  {
    id = "ml-inference";
    title = "ML Model Inference Server";
    description = "Production ML model serving with OCaml";
    long_description = "High-performance machine learning inference server optimized for low latency predictions. Supports ONNX models, automatic batching, model versioning, and A/B testing. Includes built-in monitoring, request tracing, and automatic scaling based on load.";
    tags = ["backend"; "ml"; "api"];
    tech_stack = ["OCaml"; "Owl"; "ONNX"; "gRPC"; "Prometheus"; "Docker"];
    github_url = Some "https://github.com/user/ocaml-ml-server";
    demo_url = None;
    featured = false;
  };
  
  {
    id = "blockchain-parser";
    title = "Blockchain Data Parser";
    description = "Efficient blockchain data parsing and analysis tool";
    long_description = "Fast and memory-efficient blockchain data parser supporting multiple chains. Features parallel block processing, transaction indexing, and custom analytics queries. Processes gigabytes of blockchain data with minimal memory footprint through streaming parsing.";
    tags = ["cli"; "tool"; "blockchain"];
    tech_stack = ["OCaml"; "Core"; "Async"; "RocksDB"; "Protocol Buffers"];
    github_url = Some "https://github.com/user/ocaml-blockchain";
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