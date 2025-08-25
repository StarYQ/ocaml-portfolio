(** Project filter types *)
type project_filter = 
  | All 
  | Web 
  | Mobile 
  | CLI
  | Backend
  | Tool
[@@deriving sexp, equal, compare]

(** Project data type for portfolio projects *)
type project = {
  id : string;
  title : string;
  description : string;
  long_description : string;
  tags : string list;
  tech_stack : string list;
  github_url : string option;
  demo_url : string option;
  current : bool;
}

(** Convert filter to display string *)
let filter_to_string = function
  | All -> "All"
  | Web -> "Web"
  | Mobile -> "Mobile"
  | CLI -> "CLI"
  | Backend -> "Backend"
  | Tool -> "Tool"

(** Blog post data type for articles/words section *)
type blog_post = {
  title : string;
  date : string; (* ISO date string *)
  excerpt : string;
  url : string;
}

(** Navigation route type for client-side routing *)
type route = 
  | Home
  | About
  | Projects
  | Resume
  | Contact
[@@deriving sexp, equal, typed_variants]

(** Convert route to string for URLs *)
let route_to_string = function
  | Home -> "/"
  | About -> "/about"
  | Projects -> "/projects"
  | Resume -> "/resume"
  | Contact -> "/contact"

(** Parse route from URL path *)
let route_of_string = function
  | "/" -> Some Home
  | "/about" -> Some About
  | "/projects" -> Some Projects
  | "/resume" -> Some Resume
  | "/contact" -> Some Contact
  | _ -> None

(** Get page title for route *)
let route_to_title = function
  | Home -> "Home"
  | About -> "About"
  | Projects -> "Projects"
  | Resume -> "Resume"
  | Contact -> "Contact"