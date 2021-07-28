FROM rocker/r-base

COPY ./DESCRIPTION /

RUN apt-get update
RUN apt-get --yes install libcurl4-openssl-dev libssl-dev libxml2-dev pandoc pandoc-citeproc

RUN Rscript -e "install.packages('pak', repos = 'https://r-lib.github.io/p/pak/dev/')"
RUN Rscript -e "pak::local_install_dev_deps()"
