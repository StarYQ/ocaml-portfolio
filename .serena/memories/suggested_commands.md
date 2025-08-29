# Essential Commands for OCaml Portfolio Development

## Build Commands
```bash
# Development build
make build
# or: dune build

# Production build with optimizations
make build-prod
# or: FORCE_DROP_INLINE_TEST=true INSIDE_DUNE=true dune build --profile=release

# Clean build artifacts
make clean
# or: dune clean
```

## Serve/Run Commands
```bash
# Run development server
make serve
# or: make up
# or: dune exec bin/main.exe

# Run production server
make serve-prod
# or: dune exec --profile=release bin/main.exe
```

## Cloudflare Workers Commands
```bash
# Build for Workers deployment
npm run build:worker

# Local development with Workers
npm run dev:worker

# Deploy to production
npm run deploy:worker

# Deploy to specific environments
npm run deploy:worker:production
npm run deploy:worker:preview
```

## Development Utilities
```bash
# Check bundle sizes
make check-size

# Install OCaml dependencies
opam install . --deps-only -y
```

## System Commands (macOS/Darwin)
- `ls`, `cd`, `grep`, `find` work as standard Unix commands
- `git` for version control
- `opam` for OCaml package management
- `npm` for Node.js scripts

## File Locations
- Main build output: `_build/default/lib/client_main/main.bc.js`
- Worker dist: `dist/` (created by build:worker)
- Static assets: `static/`