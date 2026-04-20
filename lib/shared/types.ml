open! Core

(** Project filter types *)
type project_filter =
  | All
  | Web
  | Mobile
  | Backend
  | AI
  | Trading
[@@deriving sexp, equal, compare]

(** Small stat block used on project listings/detail pages *)
type project_stat =
  { label : string
  ; value : string
  }
[@@deriving sexp, equal]

(** Project data used across listing and detail pages *)
type project =
  { id : string
  ; slug : string
  ; title : string
  ; subtitle : string
  ; year : string
  ; summary : string
  ; overview : string list
  ; tags : string list
  ; tech_stack : string list
  ; stats : project_stat list
  ; github_url : string option
  ; demo_url : string option
  ; current : bool
  ; featured : bool
  }
[@@deriving sexp, equal]

(** Work/experience entry for the dedicated Work page *)
type experience =
  { id : string
  ; company : string
  ; role : string
  ; team : string
  ; location : string
  ; period : string
  ; status : string
  ; bullets : string list
  }
[@@deriving sexp, equal]

(** Convert filter to display string *)
let filter_to_string = function
  | All -> "All"
  | Web -> "Web"
  | Mobile -> "Mobile"
  | Backend -> "Backend"
  | AI -> "AI"
  | Trading -> "Trading"

(** Blog post data type for articles/words section *)
type blog_post =
  { title : string
  ; date : string
  ; excerpt : string
  ; url : string
  }

(** Navigation route type for client-side routing *)
type route =
  | Home
  | Work
  | Projects
  | Project_detail of string
  | About
  | Resume
[@@deriving sexp, equal]

let normalize_route_path path =
  match String.chop_suffix path ~suffix:"/" with
  | Some trimmed when not (String.is_empty trimmed) -> trimmed
  | _ -> path

(** Convert route to string for URLs *)
let route_to_string = function
  | Home -> "/"
  | Work -> "/work"
  | Projects -> "/projects"
  | Project_detail slug -> "/projects/" ^ slug
  | About -> "/about"
  | Resume -> "/resume"

(** Parse route from URL path *)
let route_of_string raw_path =
  let path = normalize_route_path raw_path in
  match path with
  | "/" | "" -> Some Home
  | "/work" -> Some Work
  | "/projects" -> Some Projects
  | "/about" -> Some About
  | "/resume" -> Some Resume
  | _ when String.is_prefix path ~prefix:"/projects/" ->
      let slug = String.drop_prefix path (String.length "/projects/") in
      if String.is_empty slug || String.mem slug '/'
      then None
      else Some (Project_detail slug)
  | _ -> None

(** Get page title for route *)
let route_to_title = function
  | Home -> "Home"
  | Work -> "Work"
  | Projects | Project_detail _ -> "Projects"
  | About -> "About"
  | Resume -> "Resume"

let route_matches_nav current target =
  match target with
  | Projects ->
      (match current with
       | Projects | Project_detail _ -> true
       | _ -> false)
  | _ -> equal_route current target

let project_slug = function
  | Project_detail slug -> Some slug
  | _ -> None
