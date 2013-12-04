## Convert Rmd into pdf
mess <- paste('pandoc -f markdown -t latex -s -o', "intro-spatial.tex", 
              "intro-spatial.md")
system(mess) # create latex file

mess <- paste("sed 's/plot of.chunk.//g' intro-spatial.tex > intro-spatial-rl.tex")
system(mess) # replace "plot of chunk " text with nowth

mess <- paste("sed -i -e 's/width=\\\\maxwidth/width=8cm/g' intro-spatial-rl.tex")
system(mess) # reduce plot size

mess <- paste("sed -i -e 's/\\\\section{References}/\\\\newpage \\\\section{References}/g' intro-spatial-rl.tex")
system(mess) # Put refs on new page

mess <- "sed -i -e '64i\\\\\\maketitle' intro-spatial-rl.tex"
system(mess) # make title

mess <- "sed -i -e '62i\\\\\\usepackage[margin=2cm]{geometry}' intro-spatial-rl.tex"
system(mess) # shrink margins

mess <- "sed -i -e '62i\\\\\\markboth{\\\\hfill }{GeoTALISMAN Short Course \\\\hfill}' intro-spatial-rl.tex"
system(mess) # add headings

mess <- "sed -i -e '62i\\\\\\pagestyle{myheadings}' intro-spatial-rl.tex"
system(mess) # add headings





# add bigger blocks of text
# text will be inserted after the line

idx <- 63
# open the file and read in all the lines 
conn <- file("intro-spatial-rl.tex")
text <- readLines(conn)
block <- "\\author{
Cheshire, James\\\\
\\texttt{james.cheshire@ucl.ac.uk}
\\and
Lovelace, Robin\\\\
\\texttt{r.lovelace@leeds.ac.uk}
}
\\title{Introduction to Spatial Data and ggplot2}"
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
