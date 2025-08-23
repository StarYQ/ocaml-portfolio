open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom

(* Import shared types and data *)
module Types = Shared.Types
module Data = Shared.Data
module Styles = Project_styles.Styles

(* Helper to create search icon SVG *)
let search_icon =
  Vdom.Node.create_svg "svg"
    ~attrs:[
      Vdom.Attr.create "width" "20";
      Vdom.Attr.create "height" "20";
      Vdom.Attr.create "viewBox" "0 0 24 24";
      Vdom.Attr.create "fill" "none";
      Vdom.Attr.create "stroke" "currentColor";
      Vdom.Attr.create "stroke-width" "2";
    ]
    [
      Vdom.Node.create_svg "circle"
        ~attrs:[
          Vdom.Attr.create "cx" "11";
          Vdom.Attr.create "cy" "11";
          Vdom.Attr.create "r" "8";
        ] [];
      Vdom.Node.create_svg "path"
        ~attrs:[
          Vdom.Attr.create "d" "m21 21-4.35-4.35";
        ] []
    ]

(* Create GitHub icon *)
let github_icon =
  Vdom.Node.create_svg "svg"
    ~attrs:[
      Vdom.Attr.create "width" "16";
      Vdom.Attr.create "height" "16";
      Vdom.Attr.create "viewBox" "0 0 24 24";
      Vdom.Attr.create "fill" "currentColor";
    ]
    [
      Vdom.Node.create_svg "path"
        ~attrs:[
          Vdom.Attr.create "d" "M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z";
        ] []
    ]

(* Create demo/external link icon *)
let external_icon =
  Vdom.Node.create_svg "svg"
    ~attrs:[
      Vdom.Attr.create "width" "16";
      Vdom.Attr.create "height" "16";
      Vdom.Attr.create "viewBox" "0 0 24 24";
      Vdom.Attr.create "fill" "none";
      Vdom.Attr.create "stroke" "currentColor";
      Vdom.Attr.create "stroke-width" "2";
    ]
    [
      Vdom.Node.create_svg "path"
        ~attrs:[
          Vdom.Attr.create "d" "M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6";
        ] [];
      Vdom.Node.create_svg "polyline"
        ~attrs:[
          Vdom.Attr.create "points" "15 3 21 3 21 9";
        ] [];
      Vdom.Node.create_svg "line"
        ~attrs:[
          Vdom.Attr.create "x1" "10";
          Vdom.Attr.create "y1" "14";
          Vdom.Attr.create "x2" "21";
          Vdom.Attr.create "y2" "3";
        ] []
    ]

(* Individual accordion component for project details *)
let project_accordion_component ~project =
  let%sub accordion_state, set_accordion_state = 
    Bonsai.state (module Bool) ~default_model:false
  in
  
  let%arr accordion_state = accordion_state
  and set_accordion_state = set_accordion_state
  and project = project in
  
  let toggle_accordion = 
    Vdom.Attr.on_click (fun _ ->
      set_accordion_state (not accordion_state))
  in
  
  Vdom.Node.div
    ~attrs:[Styles.accordion_wrapper]
    [
      (* Accordion header *)
      Vdom.Node.div
        ~attrs:[
          Styles.accordion_header;
          toggle_accordion;
        ]
        [
          Vdom.Node.text "View Details";
          Vdom.Node.span [
            Vdom.Node.text (if accordion_state then "▼" else "▶")
          ]
        ];
      
      (* Accordion content *)
      (if accordion_state then
        Vdom.Node.div
          ~attrs:[Styles.accordion_content]
          [
            (* Long description *)
            Vdom.Node.p [Vdom.Node.text project.Types.long_description];
            
            (* Tech stack *)
            Vdom.Node.div
              ~attrs:[Styles.tech_stack]
              [
                Vdom.Node.div
                  ~attrs:[Styles.tech_stack_title]
                  [Vdom.Node.text "Technologies Used:"];
                Vdom.Node.div
                  ~attrs:[Styles.tech_stack_list]
                  (List.map project.tech_stack ~f:(fun tech ->
                    Vdom.Node.span
                      ~attrs:[Styles.tech_item]
                      [Vdom.Node.text tech]))
              ]
          ]
      else
        Vdom.Node.none)
    ]

(* Project card component *)
let project_card_component ~project =
  let%sub accordion = project_accordion_component ~project in
  
  let%arr accordion = accordion
  and project = project in
  
  Vdom.Node.div
    ~attrs:(if project.Types.featured then
      [Styles.project_card; Styles.featured]
    else
      [Styles.project_card])
    [
      (* Featured badge if applicable *)
      (if project.featured then
        Vdom.Node.div
          ~attrs:[Styles.featured_badge]
          [Vdom.Node.text "Featured"]
      else
        Vdom.Node.none);
      
      (* Card header *)
      Vdom.Node.div
        ~attrs:[Styles.card_header]
        [
          Vdom.Node.h3
            ~attrs:[Styles.card_title]
            [Vdom.Node.text project.title];
          Vdom.Node.p
            ~attrs:[Styles.card_description]
            [Vdom.Node.text project.description];
        ];
      
      (* Tags *)
      Vdom.Node.div
        ~attrs:[Styles.card_tags]
        (List.map project.tags ~f:(fun tag ->
          Vdom.Node.span
            ~attrs:[Styles.tag]
            [Vdom.Node.text tag]));
      
      (* Accordion for details *)
      Vdom.Node.div
        ~attrs:[Styles.accordion_container]
        [accordion];
      
      (* Links section *)
      Vdom.Node.div
        ~attrs:[Styles.card_links]
        (List.filter_opt [
          Option.map project.github_url ~f:(fun url ->
            Vdom.Node.a
              ~attrs:[
                Styles.card_link;
                Vdom.Attr.href url;
                Vdom.Attr.create "target" "_blank";
                Vdom.Attr.create "rel" "noopener noreferrer";
              ]
              [github_icon; Vdom.Node.text "GitHub"]);
          Option.map project.demo_url ~f:(fun url ->
            Vdom.Node.a
              ~attrs:[
                Styles.card_link;
                Vdom.Attr.href url;
                Vdom.Attr.create "target" "_blank";
                Vdom.Attr.create "rel" "noopener noreferrer";
              ]
              [external_icon; Vdom.Node.text "Demo"])
        ])
    ]

(* Filter button component *)
let filter_button ~label ~filter ~current_filter ~set_filter =
  let is_active = Types.equal_project_filter current_filter filter in
  let classes = 
    if is_active then 
      [Styles.filter_button; Styles.active]
    else 
      [Styles.filter_button]
  in
  
  Vdom.Node.button
    ~attrs:(classes @ [
      Vdom.Attr.on_click (fun _ -> set_filter filter);
    ])
    [Vdom.Node.text label]

(* Main component *)
let component () =
  let%sub current_filter, set_filter = 
    Bonsai.state 
      (module struct 
        type t = Types.project_filter [@@deriving sexp, equal]
      end)
      ~default_model:Types.All
  in
  
  let%sub search_query, set_search = 
    Bonsai.state (module String) ~default_model:""
  in
  
  (* Filter and search projects *)
  let%sub filtered_projects =
    let%arr current_filter = current_filter
    and search_query = search_query in
    Data.portfolio_projects
    |> (fun projects -> Data.filter_projects_by_tag projects current_filter)
    |> (fun projects ->
      if String.is_empty search_query then
        projects
      else
        Data.search_projects projects search_query)
  in
  
  (* Create project cards *)
  let%sub project_cards =
    Bonsai.assoc
      (module String)
      (filtered_projects >>| fun projects ->
        projects
        |> List.map ~f:(fun p -> (p.Types.id, p))
        |> Map.of_alist_exn (module String))
      ~f:(fun _id project ->
        project_card_component ~project)
  in
  
  let%arr current_filter = current_filter
  and set_filter = set_filter
  and search_query = search_query
  and set_search = set_search
  and filtered_projects = filtered_projects
  and project_cards = project_cards in
  
  let project_count = List.length filtered_projects in
  
  Vdom.Node.div
    ~attrs:[Styles.gallery]
    [
      (* Header *)
      Vdom.Node.div
        ~attrs:[Styles.gallery_header]
        [
          Vdom.Node.h1
            ~attrs:[Styles.gallery_title]
            [Vdom.Node.text "Portfolio Projects"];
          Vdom.Node.p
            ~attrs:[Styles.gallery_subtitle]
            [Vdom.Node.text "Explore my collection of OCaml projects showcasing functional programming excellence"]
        ];
      
      (* Controls section *)
      Vdom.Node.div
        ~attrs:[Styles.controls_section]
        [
          (* Search bar *)
          Vdom.Node.div
            ~attrs:[Styles.search_container]
            [
              search_icon;
              Vdom.Node.input
                ~attrs:[
                  Styles.search_input;
                  Vdom.Attr.type_ "text";
                  Vdom.Attr.placeholder "Search projects, technologies...";
                  Vdom.Attr.value search_query;
                  Vdom.Attr.on_input (fun _ value ->
                    set_search value);
                ] ()
            ];
          
          (* Filter buttons *)
          Vdom.Node.div
            ~attrs:[Styles.filter_bar]
            [
              filter_button ~label:"All" ~filter:Types.All 
                ~current_filter ~set_filter;
              filter_button ~label:"Web" ~filter:Types.Web 
                ~current_filter ~set_filter;
              filter_button ~label:"Backend" ~filter:Types.Backend 
                ~current_filter ~set_filter;
              filter_button ~label:"CLI" ~filter:Types.CLI 
                ~current_filter ~set_filter;
              filter_button ~label:"Tools" ~filter:Types.Tool 
                ~current_filter ~set_filter;
            ]
        ];
      
      (* Results count *)
      Vdom.Node.div
        ~attrs:[Styles.results_count]
        [Vdom.Node.textf "Showing %d projects" project_count];
      
      (* Project grid or empty state *)
      (if project_count > 0 then
        Vdom.Node.div
          ~attrs:[Styles.project_grid]
          (Map.data project_cards)
      else
        Vdom.Node.div
          ~attrs:[Styles.empty_state]
          [
            Vdom.Node.div
              ~attrs:[Styles.empty_icon]
              [Vdom.Node.text "🔍"];
            Vdom.Node.div
              ~attrs:[Styles.empty_title]
              [Vdom.Node.text "No projects found"];
            Vdom.Node.div
              ~attrs:[Styles.empty_message]
              [Vdom.Node.text "Try adjusting your search or filter criteria"]
          ])
    ]