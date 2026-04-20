open! Js_of_ocaml

let inject_styles () =
  let open Js_of_ocaml.Dom_html in
  let style_element = createStyle document in
  style_element##.innerHTML := Js.string {|
    :root, .light-theme {
      --bg-primary: #f5f2ea;
      --bg-secondary: #ece7dc;
      --surface-muted: rgba(17, 17, 17, 0.04);
      --surface-elevated: rgba(255, 255, 255, 0.6);
      --text-primary: #111111;
      --text-secondary: rgba(17, 17, 17, 0.76);
      --text-tertiary: rgba(17, 17, 17, 0.52);
      --border-color: rgba(17, 17, 17, 0.14);
      --border-strong: rgba(17, 17, 17, 0.72);
      --focus-ring: rgba(17, 17, 17, 0.35);
      --shadow-soft: 0 12px 40px rgba(17, 17, 17, 0.08);
      --font-family-mono: "JetBrains Mono", "IBM Plex Mono", "Space Mono", "SFMono-Regular", "SF Mono", Consolas, monospace;
    }

    .dark-theme {
      --bg-primary: #0f0f10;
      --bg-secondary: #171719;
      --surface-muted: rgba(255, 255, 255, 0.05);
      --surface-elevated: rgba(255, 255, 255, 0.03);
      --text-primary: #f4f1ea;
      --text-secondary: rgba(244, 241, 234, 0.8);
      --text-tertiary: rgba(244, 241, 234, 0.56);
      --border-color: rgba(244, 241, 234, 0.16);
      --border-strong: rgba(244, 241, 234, 0.8);
      --focus-ring: rgba(244, 241, 234, 0.4);
      --shadow-soft: 0 12px 40px rgba(0, 0, 0, 0.3);
      --font-family-mono: "JetBrains Mono", "IBM Plex Mono", "Space Mono", "SFMono-Regular", "SF Mono", Consolas, monospace;
    }

    body {
      margin: 0;
      min-height: 100vh;
      background: var(--bg-primary);
      color: var(--text-primary);
      font-family: var(--font-family-mono);
      line-height: 1.45;
      text-rendering: optimizeLegibility;
      transition: background-color 0.2s ease, color 0.2s ease;
    }

    * {
      box-sizing: border-box;
      transition: background-color 0.3s ease,
                  color 0.3s ease,
                  border-color 0.3s ease,
                  box-shadow 0.3s ease;
    }

    a {
      color: inherit;
    }

    img {
      display: block;
      max-width: 100%;
    }

    ::selection {
      background: var(--text-primary);
      color: var(--bg-primary);
    }
  |};
  let head = document##.head in
  Dom.appendChild head style_element

let () =
  inject_styles ();
  Client.App.run ()
