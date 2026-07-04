open! Core

(* Toggle this to [false] to remove the personal Me page from the public site.
   When disabled, the ME nav item is hidden and /me falls back to Home. *)
let show_me_page = false

(* Toggle this to [true] to show the Resume page on the public site.
   When disabled, Resume links are hidden and /resume falls back to Home. *)
let show_resume_page = true

(* Toggle this to [true] to show public metrics for the market-making project.
   When disabled, the project still appears but its stat blocks are hidden. *)
let show_market_making_project_stats = false
