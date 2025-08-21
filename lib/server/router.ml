let port = 
  try int_of_string (Sys.getenv "PORT") 
  with Not_found -> 8080

let serve_static_file filename content_type =
  fun _ ->
    let%lwt content = 
      let ic = open_in filename in
      let content = really_input_string ic (in_channel_length ic) in
      close_in ic;
      Lwt.return content
    in
    Dream.html ~headers:[("Content-Type", content_type)] content

let serve_js_file =
  serve_static_file "_build/default/lib/client_main/main.bc.js" "application/javascript"

let serve_index_html =
  serve_static_file "static/index.html" "text/html"

let run_server =
  Dream.run ~interface:"0.0.0.0" ~port
  @@ Dream.logger
  @@ Dream.router [
    (* Serve the compiled JavaScript *)
    Dream.get "/_build/default/lib/client_main/main.bc.js" serve_js_file;
    
    (* Serve CSS *)
    Dream.get "/styles.css" (fun _ ->
      Lwt.return (Dream.response 
        ~headers:[("Content-Type", "text/css")]
        Css.css_route));
    
    (* Serve static files from static/ directory *)
    Dream.get "/static/**" (Dream.static "static");
    
    (* SPA catch-all: serve index.html for all other routes *)
    Dream.get "/**" serve_index_html;
  ]
