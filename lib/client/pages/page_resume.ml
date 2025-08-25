open! Core
open Bonsai_web
open Bonsai.Let_syntax
open Virtual_dom
open Theme

(* Import styles using ppx_css *)
module Styles = [%css
  stylesheet
    {|
      .resume_container {
        min-height: 100vh;
        padding: 2rem;
        display: flex;
        flex-direction: column;
        align-items: center;
        /* Background will be set inline based on theme */
      }
      
      .resume_header {
        text-align: center;
        margin-bottom: 2rem;
        animation: fadeInUp 0.8s ease-out;
      }
      
      @keyframes fadeInUp {
        from { 
          opacity: 0; 
          transform: translateY(20px);
        }
        to { 
          opacity: 1; 
          transform: translateY(0);
        }
      }
      
      .resume_title {
        font-size: 2.5rem;
        font-weight: 700;
        margin-bottom: 0.5rem;
        /* Color will be set inline based on theme */
      }
      
      .resume_subtitle {
        font-size: 1.2rem;
        /* Color will be set inline based on theme */
        margin-bottom: 2rem;
      }
      
      .download_button {
        padding: 1rem 2rem;
        background: #7c3aed;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-block;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        margin-bottom: 2rem;
      }
      
      .download_button:hover {
        background: #6d28d9;
        transform: translateY(-2px);
        box-shadow: 0 8px 12px rgba(0, 0, 0, 0.15);
      }
      
      .download_icon {
        margin-right: 0.5rem;
      }
      
      .pdf_viewer_container {
        width: 100%;
        max-width: 900px;
        animation: fadeIn 1s ease-out 0.3s both;
      }
      
      @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
      }
      
      .pdf_viewer {
        width: 100%;
        height: 800px;
        border-radius: 12px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
        /* Border color will be set inline based on theme */
      }
      
      .no_pdf_message {
        padding: 3rem;
        text-align: center;
        border-radius: 12px;
        /* Background and color will be set inline based on theme */
      }
      
      .no_pdf_icon {
        font-size: 3rem;
        margin-bottom: 1rem;
      }
      
      @media (max-width: 768px) {
        .resume_container {
          padding: 1rem;
        }
        
        .resume_title {
          font-size: 2rem;
        }
        
        .resume_subtitle {
          font-size: 1rem;
        }
        
        .pdf_viewer {
          height: 600px;
        }
      }
    |}]

let render_header theme =
  let title_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #1a202c;"
    | Dark -> Vdom.Attr.create "style" "color: #f7fafc;"
  in
  let subtitle_style = 
    match theme with
    | Light -> Vdom.Attr.create "style" "color: #4a5568;"
    | Dark -> Vdom.Attr.create "style" "color: #cbd5e0;"
  in
  Vdom.Node.div
    ~attrs:[Styles.resume_header]
    [
      Vdom.Node.h1
        ~attrs:[Styles.resume_title; title_style]
        [Vdom.Node.text "Resume"];
      Vdom.Node.p
        ~attrs:[Styles.resume_subtitle; subtitle_style]
        [Vdom.Node.text "Download my resume or view it below"]
    ]

let render_download_button =
  Vdom.Node.a
    ~attrs:[
      Styles.download_button;
      Vdom.Attr.create "href" "/ocaml-portfolio/static/resume.pdf";
      Vdom.Attr.create "download" "Arnab_Bhowmik_Resume.pdf";
      Vdom.Attr.create "aria-label" "Download Resume PDF"
    ]
    [
      Vdom.Node.span
        ~attrs:[Styles.download_icon]
        [Vdom.Node.text "↓"];
      Vdom.Node.text "Download Resume"
    ]

let render_pdf_viewer theme =
  let border_style = 
    match theme with
    | Light -> 
        Vdom.Attr.create "style" 
          "border: 2px solid #e2e8f0;"
    | Dark -> 
        Vdom.Attr.create "style" 
          "border: 2px solid #2d3748;"
  in
  Vdom.Node.div
    ~attrs:[Styles.pdf_viewer_container]
    [
      Vdom.Node.create "iframe"
        ~attrs:[
          Styles.pdf_viewer;
          border_style;
          Vdom.Attr.create "src" "/ocaml-portfolio/static/resume.pdf";
          Vdom.Attr.create "title" "Resume PDF Viewer";
          Vdom.Attr.create "loading" "lazy";
          (* Allow fullscreen for better viewing *)
          Vdom.Attr.create "allowfullscreen" "true"
        ]
        []
    ]

let render_no_pdf_fallback theme =
  let style = 
    match theme with
    | Light -> 
        Vdom.Attr.create "style"
          "background-color: #f7fafc; color: #4a5568; border: 2px dashed #cbd5e0;"
    | Dark -> 
        Vdom.Attr.create "style"
          "background-color: #2d3748; color: #cbd5e0; border: 2px dashed #4a5568;"
  in
  Vdom.Node.div
    ~attrs:[Styles.no_pdf_message; style]
    [
      Vdom.Node.div
        ~attrs:[Styles.no_pdf_icon]
        [Vdom.Node.text "📄"];
      Vdom.Node.h3
        [Vdom.Node.text "Resume not available"];
      Vdom.Node.p
        [Vdom.Node.text "The resume PDF is not currently available. Please check back later."]
    ]

let component ?(theme = Bonsai.Value.return Light) () =
  (* Using state to track if PDF loads successfully *)
  let%sub pdf_available, _set_pdf_available = Bonsai.state (module Bool) ~default_model:true in
  
  let%arr theme = theme
  and pdf_available = pdf_available in
  
  let bg_style = 
    match theme with
    | Light -> 
        Vdom.Attr.create "style" 
          "background: linear-gradient(to bottom, #f7fafc, #ffffff);"
    | Dark -> 
        Vdom.Attr.create "style" 
          "background: linear-gradient(to bottom, #1a202c, #2d3748);"
  in
  
  Vdom.Node.div
    ~attrs:[Styles.resume_container; bg_style]
    [
      render_header theme;
      render_download_button;
      (* For now, always show the PDF viewer. In production, you might want to check if file exists *)
      if pdf_available then
        render_pdf_viewer theme
      else
        render_no_pdf_fallback theme
    ]