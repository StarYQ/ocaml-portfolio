(** Project data type for portfolio projects *)
type project = {
  title : string;
  description : string;
  tech_stack : string list;
  github_url : string option;
  demo_url : string option;
}

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
  | Words
  | Contact
[@@deriving sexp, equal, typed_variants]

(** Convert route to string for URLs *)
let route_to_string = function
  | Home -> "/"
  | About -> "/about"
  | Projects -> "/projects"
  | Words -> "/words"
  | Contact -> "/contact"

(** Parse route from URL path *)
let route_of_string = function
  | "/" -> Some Home
  | "/about" -> Some About
  | "/projects" -> Some Projects
  | "/words" -> Some Words
  | "/contact" -> Some Contact
  | _ -> None

(** Get page title for route *)
let route_to_title = function
  | Home -> "Home"
  | About -> "About"
  | Projects -> "Projects"
  | Words -> "Words"
  | Contact -> "Contact"