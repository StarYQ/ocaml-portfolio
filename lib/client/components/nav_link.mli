open Bonsai_web
open Shared.Types

(** [make'] is like [make], but supports wrapping arbitrary nodes inside the link. 
    This is the Jane Street nav_link implementation adapted for our routing system. *)
val make'
  :  ?attrs:Vdom.Attr.t list
  -> set_url:(route -> unit Effect.t)
  -> page_to_string:(route -> string)
  -> route
  -> Vdom.Node.t list
  -> Vdom.Node.t

(** [make] builds a nav link that navigates to another page within the app. It
    performs an on-page navigation when clicked directly, but also plays well with
    Mod-click, such as Ctrl-click to open in a new tab.
    
    This is adapted from Jane Street's bonsai_web_components nav_link. *)
val make
  :  ?attrs:Vdom.Attr.t list
  -> set_url:(route -> unit Effect.t)
  -> page_to_string:(route -> string)
  -> route
  -> string
  -> Vdom.Node.t

(** Convenience function that uses our router's navigation *)
val create
  :  ?attrs:Vdom.Attr.t list
  -> route:route
  -> text:string
  -> unit
  -> Vdom.Node.t

(** Convenience function that wraps arbitrary content *)
val create'
  :  ?attrs:Vdom.Attr.t list
  -> route:route
  -> Vdom.Node.t list
  -> Vdom.Node.t