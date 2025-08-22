open! Core
open Bonsai_web
open Virtual_dom

(* Sample project data for demonstration *)
let sample_projects = [
  ("Bonsai Portfolio Website", 
   "A modern portfolio website built entirely in OCaml using Dream backend and Bonsai Web frontend. Features type-safe routing, functional reactive UI components, and zero JavaScript.",
   ["OCaml"; "Bonsai"; "Dream"; "Dune"; "ppx_css"]);
  
  ("OCaml Compiler Extension",
   "Custom PPX extension for automatic code generation and compile-time optimizations. Reduces boilerplate code by 40% and improves type inference in complex scenarios.",
   ["OCaml"; "PPX"; "AST Manipulation"; "Compiler Design"]);
  
  ("Distributed Task Queue",
   "High-performance distributed task queue system with automatic failover and load balancing. Processes millions of jobs daily with sub-second latency.",
   ["OCaml"; "Lwt"; "PostgreSQL"; "Redis"; "Docker"]);
  
  ("Real-time Analytics Engine",
   "Stream processing engine for real-time data analytics with incremental computation. Handles 100K events/second with minimal memory overhead.",
   ["OCaml"; "Incremental"; "Async"; "Kafka"; "ClickHouse"])
]

let project_accordion (title, description, technologies) =
  let open Bonsai.Let_syntax in
  let%sub accordion = 
    Bonsai_web_ui_accordion.component
      ~starts_open:false
      ~title:(Value.return (
        Vdom.Node.div
          ~attrs:[Vdom.Attr.style (Css_gen.create ~field:"font-weight" ~value:"bold")]
          [Vdom.Node.text title]
      ))
      ~content:(
        Bonsai.const (
          Vdom.Node.div
            ~attrs:[Vdom.Attr.style (Css_gen.padding ~top:(`Px 10) ~bottom:(`Px 10) ())]
            [
              Vdom.Node.p [Vdom.Node.text description];
              Vdom.Node.div
                ~attrs:[Vdom.Attr.style (Css_gen.margin_top (`Px 10))]
                [
                  Vdom.Node.strong [Vdom.Node.text "Technologies: "];
                  Vdom.Node.span [
                    Vdom.Node.text (String.concat ~sep:", " technologies)
                  ]
                ]
            ]
        )
      )
      () in
  let%arr accordion = accordion in
  accordion.view

let component () =
  let open Bonsai.Let_syntax in
  (* Create individual accordion computations *)
  let accordions = List.map sample_projects ~f:(fun project ->
    project_accordion project
  ) in
  
  (* Combine all accordion computations *)
  let rec combine_accordions = function
    | [] -> Bonsai.const []
    | [x] -> 
        let%sub acc = x in
        let%arr acc = acc in
        [acc]
    | x :: xs ->
        let%sub first = x in
        let%sub rest = combine_accordions xs in
        let%arr first = first and rest = rest in
        first :: rest
  in
  
  let%sub all_accordions = combine_accordions accordions in
  
  let%arr accordions = all_accordions in
  Vdom.Node.div
    ~attrs:[Vdom.Attr.style (Css_gen.padding ~left:(`Px 20) ~right:(`Px 20) ())]
    [
      Vdom.Node.h1 [Vdom.Node.text "Projects"];
      Vdom.Node.p 
        ~attrs:[Vdom.Attr.style (Css_gen.margin_bottom (`Px 20))]
        [Vdom.Node.text "Click on any project title to expand and see more details."];
      Vdom.Node.div
        ~attrs:[Vdom.Attr.style (Css_gen.create ~field:"max-width" ~value:"800px")]
        accordions
    ]