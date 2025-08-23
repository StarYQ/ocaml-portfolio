# Production build configuration for OCaml Portfolio

.PHONY: build build-dev build-prod serve serve-prod up clean check-size

# Development build (default)
build: build-dev

build-dev:
	dune build

# Production build with optimizations
build-prod:
	@echo "Building for production with dead code elimination..."
	FORCE_DROP_INLINE_TEST=true \
	INSIDE_DUNE=true \
	dune build --profile=release

# Serve the application
serve: build-dev
	dune exec bin/main.exe

serve-prod: build-prod
	dune exec --profile=release bin/main.exe

# Alias for serve (common convention)
up: serve

# Clean build artifacts
clean:
	dune clean

# Check bundle size
check-size:
	@echo "Bundle sizes:"
	@ls -lh _build/default/lib/client_main/main.bc.js 2>/dev/null || echo "Development build not found"
	@ls -lh _build/release/lib/client_main/main.bc.js 2>/dev/null || echo "Production build not found"