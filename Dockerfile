# Stage 1: Build the application
FROM ocaml/opam:alpine-ocaml-5.1 as build

# Install system dependencies
RUN sudo apk add --update libev-dev openssl-dev gmp-dev gmp

# Pull the latest OPAM repository updates
RUN cd ~/opam-repository && git pull origin master && opam update

WORKDIR /home/opam

# Copy the project's opam file and install dependencies
COPY --chown=opam:opam portfolio20240602.opam portfolio20240602.opam
RUN opam install . --deps-only

# Copy the rest of the application
COPY --chown=opam:opam . .

# Build the project
RUN opam exec -- dune build --profile=release

# Stage 2: Create the runtime image
FROM alpine:3.18 as run

# Install runtime dependencies
RUN apk add --update libev

# Set default port environment variable
ENV PORT=8000

# Copy the compiled binary from the build stage
COPY --from=build /home/opam/_build/default/bin/main.exe /bin/server

# Make sure the server is executable
RUN chmod +x /bin/server

ENTRYPOINT ["/bin/server"]
