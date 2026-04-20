open! Core
open Virtual_dom

module Styles = [%css
  stylesheet
    {|
      .main {
        padding-top: 4.4rem;
      }

      @media (max-width: 767px) {
        .main {
          padding-top: 7rem;
        }
      }
    |}]

let render ~navigation ~content =
  Vdom.Node.div
    [ navigation
    ; Vdom.Node.create "main"
        ~attrs:[ Styles.main ]
        [ content ]
    ]
