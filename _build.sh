#!/bin/sh

set -ev

docker build -t linked-data-book .

docker run --rm -v $PWD:/workspace -w /workspace -it linked-data-book \
  Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::bs4_book')"
