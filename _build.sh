#!/bin/sh

Rscript -e "rmarkdown::render('vignettes/Conduct-analyses.Rmd', 'all', output_dir='./doc')"
Rscript -e "devtools::build_manual('.', './doc')"
