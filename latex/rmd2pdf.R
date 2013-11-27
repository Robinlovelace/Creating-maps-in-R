## Convert Rmd into pdf
mess <- paste('pandoc -f markdown -t latex -s -o', "intro-spatial.tex", 
              "intro-spatial.md")
system(mess)

# from http://conjugateprior.org/2012/12/r-markdown-to-other-document-formats/

source("latex/rmd.R")
rmd.convert("intro-spatial.Rmd", output="latex")

## An alternative approach
## Set working diectory (Change this yourself!!)
## setwd("/media/woobe/SUPPORT/Repo/blenditbayes/2013-08-easy-documentation")

## Define filename
FILE <- "intro-spatial"

## Convert .Rmd into .md
library(knitr)
knit2html(paste(FILE, ".Rmd", sep=""))

## Convert .md into .pdf
system(paste("pandoc -o ", FILE, ".tex ", FILE, ".md", sep=""))
