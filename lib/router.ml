let port = int_of_string ( Sys.getenv "PORT" )

let run_router =
Dream.run ~interface:"0.0.0.0" ~port:(port)
@@ Dream.logger
@@ Dream.router [
Dream.get "/" (fun _ ->
        Dream.html (Page_index.template));
Dream.get "/about" (fun _ ->
        Dream.html (Page_about.template));
Dream.get "/projects" (fun _ ->
        Dream.html (Page_projects.template));
Dream.get "/words" (fun _ ->
        Dream.html (Page_words.template));
Dream.get "/contact" (fun _ ->
        Dream.html (Page_contact.template));
Dream.get "/styles.css" (fun _ ->
        Lwt.return (Dream.response 
        ~headers:[("Content-Type", "text/css")]
        Css.css_route))
]
