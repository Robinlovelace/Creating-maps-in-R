## Convert Rmd into pdf
mess <- paste('pandoc -f markdown -t latex -s -o', "intro-spatial.tex", 
              "intro-spatial.md")
system(mess) # create latex file

mess <- paste("sed 's/plot of.chunk.//g' intro-spatial.tex > intro-spatial-rl.tex")
system(mess) # replace "plot of chunk " text with nowth

mess <- paste("sed -i -e 's/=\\\\ScaleIfNeeded/=10cm/g' intro-spatial-rl.tex")
system(mess) # reduce plot size

mess <- paste("sed -i -e 's/\\\\section{R quick reference}/\\\\newpage \\\\section{R quick reference}/g' intro-spatial-rl.tex")
system(mess) # Put refs on new page

mess <- paste("sed -i -e 's/\\\\section{References}/\\\\newpage \\\\section{References}/g' intro-spatial-rl.tex")
system(mess) # Put refs on new page

mess <- paste("sed -i -e 's/\\\\date{}//g' intro-spatial-rl.tex")
system(mess) # add date

mess <- "sed -i -e '90i\\\\\\tableofcontents' intro-spatial-rl.tex"
system(mess) # make title

mess <- "sed -i -e '90i\\\\\\maketitle' intro-spatial-rl.tex"
system(mess) # make title

mess <- "sed -i -e '87i\\\\\\usepackage[a4paper,margin=2cm]{geometry}' intro-spatial-rl.tex"
system(mess) # shrink margins

mess <- "sed -i -e '87i\\\\\\markboth{\\\\hfill }{GeoTALISMAN Short Course \\\\hfill}' intro-spatial-rl.tex"
system(mess) # add headings

mess <- "sed -i -e '87i\\\\\\pagestyle{myheadings}' intro-spatial-rl.tex"
system(mess) # add headings

mess <- "sed -i -e '78i\\linkcolor=blue,' intro-spatial-rl.tex"
system(mess) # make title

# add bigger blocks of text
# text will be inserted after the line

idx <- 91
# open the file and read in all the lines 
conn <- file("intro-spatial-rl.tex")
text <- readLines(conn)
block <- "\\author{Lovelace, Robin\\\\
\\texttt{r.lovelace@leeds.ac.uk}
\\and
Cheshire, James\\\\
\\texttt{james.cheshire@ucl.ac.uk}
}
\\title{Introduction to visualising spatial data in R}"
text_block <- unlist(strsplit(block, split='\n'))
# concatenate the old file with the new text
mytext <- c(text[1:idx],text_block,text[(idx+1):length(text)]) 
writeLines(mytext, conn, sep="\n")
close(conn)

# from http://conjugateprior.org/2012/12/r-markdown-to-other-document-formats/
# 
# source("latex/rmd.R")
# rmd.convert("intro-spatial.Rmd", output="latex")
# 
# ## An alternative approach
# ## Set working diectory (Change this yourself!!)
# ## setwd("/media/woobe/SUPPORT/Repo/blenditbayes/2013-08-easy-documentation")
# 
# ## Define filename
# FILE <- "intro-spatial"
# 
# ## Convert .Rmd into .md
# library(knitr)
# knit2html(paste(FILE, ".Rmd", sep=""))
# 
# ## Convert .md into .pdf
# system(paste("pandoc -o ", FILE, ".tex ", FILE, ".md", sep=""))
