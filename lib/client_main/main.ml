open! Js_of_ocaml

let inject_styles () =
  (* Create a style element and inject theme CSS *)
  let open Js_of_ocaml.Dom_html in
  let style_element = createStyle document in
  style_element##.innerHTML := Js.string {|
    /* Light theme variables (default) */
    :root, .light-theme {
      /* Primary colors */
      --bg-primary: #ffffff;
      --bg-secondary: #f7fafc;
      --bg-tertiary: #edf2f7;
      
      /* Text colors */
      --text-primary: #1a202c;
      --text-secondary: #4a5568;
      --text-tertiary: #718096;
      --text-inverse: #ffffff;
      
      /* Gradient colors */
      --gradient-start: #667eea;
      --gradient-end: #764ba2;
      --gradient-start-hover: #5a67d8;
      --gradient-end-hover: #6b4299;
      
      /* Card and surface colors */
      --card-bg: #ffffff;
      --card-border: #e2e8f0;
      --card-shadow: rgba(0, 0, 0, 0.1);
      --card-shadow-hover: rgba(0, 0, 0, 0.15);
      
      /* Form colors */
      --input-bg: #ffffff;
      --input-border: #cbd5e0;
      --input-border-focus: #667eea;
      --input-text: #1a202c;
      
      /* Navigation specific */
      --nav-bg: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      --nav-text: rgba(255, 255, 255, 0.9);
      --nav-text-hover: #ffffff;
      --nav-link-bg-hover: rgba(255, 255, 255, 0.1);
      --nav-link-bg-active: rgba(255, 255, 255, 0.2);
      
      /* Button colors */
      --btn-primary-bg: #667eea;
      --btn-primary-text: #ffffff;
      --btn-secondary-bg: transparent;
      --btn-secondary-text: #667eea;
      --btn-secondary-border: #667eea;
      
      /* Code block colors */
      --code-bg: #f7fafc;
      --code-text: #d53f8c;
      --code-border: #e2e8f0;
      
      /* Overlay */
      --overlay-bg: rgba(0, 0, 0, 0.5);
    }
    
    /* Dark theme variables */
    .dark-theme {
      /* Primary colors */
      --bg-primary: #1a202c;
      --bg-secondary: #2d3748;
      --bg-tertiary: #4a5568;
      
      /* Text colors */
      --text-primary: #f7fafc;
      --text-secondary: #cbd5e0;
      --text-tertiary: #a0aec0;
      --text-inverse: #1a202c;
      
      /* Gradient colors */
      --gradient-start: #4c51bf;
      --gradient-end: #553c9a;
      --gradient-start-hover: #434190;
      --gradient-end-hover: #4c3480;
      
      /* Card and surface colors */
      --card-bg: #2d3748;
      --card-border: #4a5568;
      --card-shadow: rgba(0, 0, 0, 0.3);
      --card-shadow-hover: rgba(0, 0, 0, 0.5);
      
      /* Form colors */
      --input-bg: #2d3748;
      --input-border: #4a5568;
      --input-border-focus: #4c51bf;
      --input-text: #f7fafc;
      
      /* Navigation specific */
      --nav-bg: linear-gradient(135deg, #4c51bf 0%, #553c9a 100%);
      --nav-text: rgba(255, 255, 255, 0.9);
      --nav-text-hover: #ffffff;
      --nav-link-bg-hover: rgba(255, 255, 255, 0.1);
      --nav-link-bg-active: rgba(255, 255, 255, 0.2);
      
      /* Button colors */
      --btn-primary-bg: #4c51bf;
      --btn-primary-text: #ffffff;
      --btn-secondary-bg: transparent;
      --btn-secondary-text: #a0aec0;
      --btn-secondary-border: #4a5568;
      
      /* Code block colors */
      --code-bg: #2d3748;
      --code-text: #f687b3;
      --code-border: #4a5568;
      
      /* Overlay */
      --overlay-bg: rgba(0, 0, 0, 0.7);
    }
    
    /* Body and global styles */
    body {
      background-color: var(--bg-primary);
      color: var(--text-primary);
      transition: background-color 0.3s ease, color 0.3s ease;
    }
    
    /* Apply smooth transitions for theme changes */
    * {
      transition: background-color 0.3s ease, 
                  color 0.3s ease, 
                  border-color 0.3s ease,
                  box-shadow 0.3s ease;
    }
  |};
  let head = document##.head in
  Dom.appendChild head style_element

let () = 
  (* Inject theme styles into the DOM *)
  inject_styles ();
  (* Start the Bonsai app - it handles its own navigation *)
  Client.App.run ()