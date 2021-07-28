# linked-data-book

This repository contains the source of **Creating Linked Open Statistical Data** book. The book is built using [bookdown](https://github.com/rstudio/bookdown).

Running `_serve.sh` will set up a docker container with all the required dependencies, build the book and serve it from `localhost:4321`. Edits to any of the Rmarkdown files while the book is served will result in it being rebuilt, allowing for interactive editing.

The book's dependencies are captured in the [`DESCRIPTION`](./DESCRIPTION) file.
