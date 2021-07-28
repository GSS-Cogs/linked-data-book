#!/bin/sh

set -ev

docker build -t linked-data-book .

docker run --rm -v $PWD:/workspace -w /workspace -p 4321:4321 linked-data-book \
  Rscript -e "bookdown::serve_book(host = '0.0.0.0', preview = FALSE)"
