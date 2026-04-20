# CHANGELOG

## 2026-04-20 - Work Page Experience Logos
- Added optional `logo_file` support for work experiences so logos can be configured from shared data by filename only
- Rendered company logos beside work entries with a responsive framed layout that tolerates different aspect ratios
- Wired the current work experiences to use logo assets from `static/`
- Highlighted `ACTIVE` work statuses with the same emphasized badge treatment as `INCOMING`

## 2026-04-20 - Default Dark Theme Shell
- Made dark mode the immediate default on initial page load when no theme preference is stored
- Updated the static app shell and generated Worker shell to apply the saved theme before the OCaml app mounts
- Aligned loading-state colors with the active theme to avoid a light flash on entry

## 2026-03-30 - Project Cleanup & Rename
- Renamed project from `portfolio20240602` to `ocaml_portfolio` across all dune files and dune-project
- Fixed template placeholders: GitHub URL set to StarYQ/ocaml-portfolio, removed dummy documentation URL
- Deleted dead files: empty test scaffold, orphaned page_contact.ml, legacy Cloudflare Pages script
- Regenerated opam file with correct metadata

## 2025-01-29 - Cloudflare Workers Deployment
- Replaced Cloudflare Pages with Workers deployment
- Created TypeScript Worker script with ASSETS binding
- Implemented SPA routing in Worker with proper fallback
- Added security and caching headers
- Updated GitHub Actions workflow for Workers
- Archived Pages-specific files (functions, old worker)
- GitHub Pages deployment remains unchanged

## 2025-08-26 - Contact Page Removal & Hero Section Enhancement
- Removed Contact page and route from application
- Integrated contact links (GitHub, LinkedIn, Email) into hero section
- Added circular icon buttons with hover animations
- Updated routing system to remove Contact route completely
- Cleaned up navigation components

## 2025-08-26 - Router Base Path Fix for GitHub Pages
- Added base path handling to Router.ml for GitHub Pages deployment
- Router now detects environment and uses `/ocaml-portfolio` prefix when on GitHub Pages
- Local development continues to work without base path
- Fixed navigation and page reload issues on GitHub Pages

## 2025-08-26 - Resume PDF Dynamic Path Fix
- Added environment detection for PDF paths (local vs GitHub Pages)
- Implemented `get_base_path()` helper using Js_of_ocaml DOM access
- Resume PDF now loads from `/static/resume.pdf` locally and `/ocaml-portfolio/static/resume.pdf` on GitHub Pages

## 2025-08-26 - GitHub Pages Deployment Fix
- Fixed JavaScript path in index.html to use /ocaml-portfolio/ subdirectory
- Added 404.html with redirect for GitHub Pages fallback
- Updated workflow to include 404.html in deployment artifact

## 2025-08-25 - Resume Page Implementation
- Replaced Words section with professional Resume page
- Added PDF viewer with embedded iframe
- Implemented download button with purple accent (#7c3aed)
- Full theme support (light/dark modes)
- Responsive layout with animations
- Created placeholder PDF file
- Updated all navigation links and routing

## 2025-08-23 - Theme Toggle Fix & UI Polish
- Fixed Navigation_styles module build error
- Implemented sliding pill-shaped theme toggle with sun/moon icons  
- Verified project card accordions work independently
- Theme persists correctly across all pages
- Added proper ARIA attributes for accessibility

## 2025-08-23 - Dark/Light Mode Toggle
- Implemented dark/light mode toggle infrastructure
- Created theme module with state management 
- Added comprehensive CSS variables for theming
- Integrated theme toggle button in navigation bar
- Updated styles to use CSS variables
- Added localStorage persistence for theme preference

## 2025-01-22 - Animated Navigation Bar
- Implemented professional animated navigation with gradient background
- Added mobile-responsive hamburger menu with slide-out panel  
- Integrated ppx_css for type-safe CSS with animations
- Fixed Bonsai state management and Router Effect.t types
- Active route highlighting with animated underline

## 2025-01-21 - Bonsai Web Migration

### Added
- Bonsai Web frontend with client-side routing (/, /about, /projects, /words, /contact)
- Dual build system: Dream server + js_of_ocaml client
- Client/server/shared directory structure for code organization
- Type-safe shared types between frontend and backend
- Development Makefile with build/serve targets
- Simple placeholder pages for all routes

### Changed
- Migrated from server-side EML templates to Bonsai components
- Server now serves SPA with client-side routing
- Updated dependencies: bonsai, virtual_dom, js_of_ocaml, ppx_jane

### Technical
- Using Bonsai Computation API (removed deprecated local_ syntax)
- Fixed module naming conflicts and dependency issues
- Configured proper PPX preprocessors
- Client bundle: ~24MB main.bc.js
- Url_var implementation for route tracking

### Status - RESOLVED
- Initial issues fixed in next update

## 2025-08-21 - State-Based Routing Fix

### Fixed
- Routing now fully functional - all navigation works correctly
- Replaced problematic Url_var with state-based approach
- Browser back/forward buttons work properly
- Direct URL navigation supported

### Changed  
- New router implementation using Bonsai.state with polling
- Global route setter for navigation effects
- 100ms polling interval for URL change detection

### Status
- All routes display correct content
- No page reloads during navigation
- URL bar updates appropriately
- Build passes with no type errors

### Evaluated
- fmlib: Not adopted - Elm architecture conflicts with Bonsai's reactive paradigm

## 2025-01-22 - Portfolio Patterns Research

### Added
- Comprehensive portfolio-specific Bonsai patterns documentation
- 40+ code examples for common portfolio features
- Performance optimization patterns (lazy loading, virtual scrolling)
- Testing strategies with Bonsai_web_test

### Documented
- Fixed routing patterns using Url_var (replacing polling anti-pattern)
- Component architecture with (view, state) tuple returns
- Theme system using Dynamic_scope
- ppx_css patterns for type-safe styling
- Interactive features: smooth scroll, hover effects, page transitions
- Portfolio components: project gallery, skills showcase, contact forms

### Research Files
- PORTFOLIO_BONSAI_PATTERNS_REPORT.md - Main patterns documentation
- test-reports/portfolio-patterns-research/ - Research validation

### Next Steps
- Implement Url_var routing to fix polling issue
- Integrate bonsai_web_ui_* component libraries
- Add animations and transitions to UI components

## 2025-01-22 - Production Patterns Deep Analysis

### Added
- Comprehensive production patterns analysis (5 documents, ~2000 lines)
- Quality standards checklist for production Bonsai apps
- Common solutions for frequent development challenges
- Complete feature implementations with full code examples

### Research Documents Created
- PRODUCTION_PATTERNS_REPORT.md - Core patterns & architectures
- QUALITY_STANDARDS.md - Production quality benchmarks
- COMMON_SOLUTIONS.md - Solutions to common problems
- FEATURE_IMPLEMENTATIONS.md - Complete portfolio features
- SUMMARY.md - Synthesis & recommendations

### Key Findings
- Current router uses anti-pattern (polling) - must fix with Url_var
- 25+ UI components available but unused (forms, modals, tables, etc.)
- Missing: error boundaries, loading states, proper testing
- Performance gaps: no memoization or incremental computation
- Quality gaps: accessibility, security standards not met

### Implementation Roadmap
- Week 1: Fix routing, add error boundaries, basic tests
- Week 2: Integrate UI components, add validation
- Week 3: Build gallery, skills section, enhance forms
- Week 4: Testing, performance, accessibility audit
