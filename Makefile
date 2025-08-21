# Build targets
.PHONY: build build-client build-server clean install-deps

build: build-client build-server

build-client:
	@echo "Building Bonsai client..."
	eval $$(opam env) && dune build lib/client_main/main.bc.js

build-server:
	@echo "Building Dream server..."
	eval $$(opam env) && dune build bin/main.exe

clean:
	dune clean

install-deps:
	opam install . --deps-only -y

# Development targets
.PHONY: dev serve watch

dev: build serve

serve:
	@echo "Starting server on http://localhost:8080"
	eval $$(opam env) && PORT=8080 dune exec portfolio20240602

watch:
	@echo "Starting development server with file watching..."
	eval $$(opam env) && dune build --watch &
	eval $$(opam env) && PORT=8080 dune exec portfolio20240602

# Legacy target
up: serve
