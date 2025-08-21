## Ocaml Portfolio
Portfolio website written in OCaml.

## Usage
You can copy the following snippet to get this project up and running:

``` bash
export PORT=8000
make up
```

With Docker:
``` bash
cd ocaml-portfolio
docker build -t ocaml-portfolio .
docker run --rm -p 8000:8000 -e PORT=8000 ocaml-portfolio
```

or add ```ENV PORT=8000``` (or whatever you want to set your port to) in Dockerfile and run:
``` bash
cd ocaml-portfolio
docker build -t ocaml-portfolio .
docker run --rm -p 8000:8000 ocaml-portfolio
```

to stop and remove old container before running:
``` bash
docker stop $(docker ps -q --filter "ancestor=ocaml-portfolio") 2>/dev/null && \
docker run --rm -p 8000:8000 ocaml-portfolio
```