open! Core
open Bonsai_web

(* Theme type - Light, OCaml/sunset, or Dark mode *)
type t = Light | Sunset | Dark [@@deriving sexp, equal]

(* Create Dynamic_scope variable for global theme state *)
let variable =
  Bonsai.Dynamic_scope.create
    ~name:"theme"
    ~fallback:Sunset
    ()

(* Get current theme from Dynamic_scope *)
let current () = Bonsai.Dynamic_scope.lookup variable

(* Provide theme to a component tree *)
let provide ~theme component =
  Bonsai.Dynamic_scope.set variable theme ~inside:component

(* Helper to toggle between themes *)
let toggle = function
  | Light -> Sunset
  | Sunset -> Dark
  | Dark -> Light

(* Convert theme to string for CSS class *)
let to_class_name = function
  | Light -> "light-theme"
  | Sunset -> "sunset-theme"
  | Dark -> "dark-theme"

(* Convert theme to string for storage *)
let to_string = function
  | Light -> "light"
  | Sunset -> "sunset"
  | Dark -> "dark"

(* Parse theme from string *)
let of_string = function
  | "dark" -> Some Dark
  | "sunset" -> Some Sunset
  | "light" -> Some Light
  | _ -> None

let class_names =
  [ to_class_name Light; to_class_name Sunset; to_class_name Dark ]

(* Get theme from localStorage *)
let get_stored_theme () =
  let open Js_of_ocaml in
  match Js.Optdef.to_option Dom_html.window##.localStorage with
  | None -> None
  | Some storage ->
    match Js.Opt.to_option (storage##getItem (Js.string "theme")) with
    | None -> None
    | Some js_str -> of_string (Js.to_string js_str)

(* Store theme in localStorage *)
let store_theme theme =
  let open Js_of_ocaml in
  match Js.Optdef.to_option Dom_html.window##.localStorage with
  | None -> ()
  | Some storage ->
    storage##setItem (Js.string "theme") (Js.string (to_string theme))

(* Initialize theme from localStorage or use default *)
let initial_theme () =
  match get_stored_theme () with
  | Some theme -> theme
  | None -> Sunset
