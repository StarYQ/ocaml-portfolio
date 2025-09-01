(lang dune 3.15)

(name portfolio20240602)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Arnab Bhowmik")

(maintainers "")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name portfolio20240602)
 (synopsis "Pure OCaml Portfolio Website")
 (description
  "A modern portfolio website built entirely in OCaml using Dream backend and Bonsai Web frontend")
 (depends
  ocaml
  dune
  dream
  lwt_ppx
  (bonsai
   (>= v0.16))
  (virtual_dom
   (>= v0.16))
  (js_of_ocaml
   (>= 5.0))
  (js_of_ocaml-ppx
   (>= 5.0))
  ppx_jane
  ppx_css)
 (tags
  (portfolio ocaml bonsai web)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
