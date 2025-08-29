# Code Style and Conventions

## OCaml Conventions
- **File naming**: snake_case for modules (e.g., `main.ml`, `client_main`)
- **Function naming**: snake_case
- **Type naming**: snake_case for types, PascalCase for variants
- **Module naming**: PascalCase (e.g., `Server.Router`)

## Project Structure Conventions
- `lib/` contains all library modules organized by purpose:
  - `client/` - Frontend Bonsai components
  - `server/` - Backend Dream handlers
  - `shared/` - Shared types and utilities
  - `theme/` - CSS and styling
  - `client_main/` - Main client entry point
- `bin/` contains executables
- `static/` contains static assets
- `scripts/` contains build and deployment utilities

## Build Conventions
- Use `dune` as the primary build system
- Production builds use `--profile=release` for optimizations
- Environment variables:
  - `FORCE_DROP_INLINE_TEST=true` for production
  - `INSIDE_DUNE=true` for certain build scenarios

## Deployment Conventions
- **Workers**: Assets served from `dist/` directory with ASSETS binding
- **GitHub Pages**: Static files with proper routing
- **Dual deployment**: Both platforms supported simultaneously

## Dependencies
- Use `opam` for OCaml packages
- Use `npm` only for Cloudflare Workers tooling
- Pin specific versions in `dune-project` and `wrangler.toml`