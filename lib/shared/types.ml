(** Project filter types *)
type project_filter =
  | All
  | Web
  | Mobile
  | Backend
  | AI
  | Trading
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
  description_link : (string * string) option; (** Optional (link_text, url) for inline links in description *)
}

(** Convert filter to display string *)
let filter_to_string = function
  | All -> "All"
  | Web -> "Web"
  | Mobile -> "Mobile"
  | Backend -> "Backend"
  | AI -> "AI"
  | Trading -> "Trading"

(** Blog post data type for articles/words section *)
type blog_post = {
  title : string;
  date : string; 
  excerpt : string;
  url : string;
}

(** Navigation route type for client-side routing *)
type route = 
  | Home
  | About
  | Projects
  | Resume
[@@deriving sexp, equal, typed_variants]

(** Convert route to string for URLs *)
let route_to_string = function
  | Home -> "/"
  | About -> "/about"
  | Projects -> "/projects"
  | Resume -> "/resume"

(** Parse route from URL path *)
let route_of_string = function
  | "/" | "" -> Some Home
  | "/about" -> Some About
  | "/projects" -> Some Projects
  | "/resume" -> Some Resume
  | path when String.length path >= 6 && String.sub path 0 6 = "/about" -> Some About
  | path when String.length path >= 9 && String.sub path 0 9 = "/projects" -> Some Projects
  | path when String.length path >= 7 && String.sub path 0 7 = "/resume" -> Some Resume
  | _ -> None

(** Get page title for route *)
let route_to_title = function
  | Home -> "Home"
  | About -> "About"
  | Projects -> "Projects"
  | Resume -> "Resume"