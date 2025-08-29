# OCaml Portfolio Project Overview

## Purpose
A modern portfolio website built entirely in OCaml demonstrating functional web development with dual deployment capabilities (GitHub Pages + Cloudflare Workers).

## Tech Stack
- **Backend**: OCaml with Dream web framework
- **Frontend**: Bonsai Web framework (OCaml)
- **Compilation**: js_of_ocaml (compiles OCaml to JavaScript)
- **Build System**: Dune 3.15
- **Deployment**: Dual deployment to GitHub Pages and Cloudflare Workers
- **CI/CD**: GitHub Actions

## Key Features
- Single Page Application (SPA) with client-side routing
- Static asset serving (resume.pdf)
- Modern CSS with theme support
- Production optimizations with dead code elimination
- Cloudflare Workers for edge deployment

## Architecture
```
lib/
├── client/      - Frontend Bonsai components
├── client_main/ - Main client entry point  
├── server/      - Dream backend router
├── shared/      - Shared types and utilities
└── theme/       - CSS and theming

bin/main.ml      - Server entry point
src/index.ts     - Cloudflare Worker script
scripts/         - Build and deployment scripts
```

## Deployment Models
1. **GitHub Pages**: Traditional static site hosting
2. **Cloudflare Workers**: Edge deployment with ASSETS binding for static files

## Dependencies
- OCaml 5.2.1
- Key packages: dream, bonsai, js_of_ocaml, lwt_ppx, ppx_jane, ppx_css