(lang dune 3.15)

(name ocaml_portfolio)

(generate_opam_files true)

(source
 (github StarYQ/ocaml-portfolio))

(authors "Arnab Bhowmik")

(maintainers "")

(license LICENSE)

(package
 (name ocaml_portfolio)
 (synopsis "OCaml Portfolio Website")
 (description
  "A portfolio website built entirely in OCaml using Dream backend and Bonsai Web frontend")
 (depends
  ocaml
  dune
  dream
  lwt_ppx
  (bonsai
   (= v0.16.0))
  (virtual_dom
   (= v0.16.0))
  (js_of_ocaml
   (>= 5.0))
  (js_of_ocaml-ppx
   (>= 5.0))
  ppx_jane
  ppx_css)
 (tags
  (portfolio ocaml bonsai web)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
