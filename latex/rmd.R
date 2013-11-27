rmd.convert <- function(fname, output=c('latex', 'word', 'html', "pdf")){
  ## Thanks to Robert Musk for helpful additions to make this run better on Windows
  
  require(knitr)
  require(tools)
  
  thedir <- file_path_as_absolute(dirname(fname))
  thefile <- (basename(fname)) 
  
  create_latex <- function(f){
    knit(f, 'tmp-outputfile.md'); 
    newname <- paste0(file_path_sans_ext(f), ".tex")
    mess <- paste('pandoc -f markdown -t latex -s -o', shQuote(newname), 
                  "tmp-outputfile.md")
    system(mess)
    cat("The Latex file is", file.path(thedir, newname), 
        "\nIf transporting do not forget to include the folder", file.path(thedir, "figure"), "\n")
    mess <- paste('rm tmp-outputfile.md')
    system(mess)
  }
  
  create_word <- function(f){
    knit(f, 'tmp-outputfile.md');
    newname <- paste0(file_path_sans_ext(f),".docx")
    mess <- paste('pandoc -f markdown -t docx -o', shQuote(newname), "tmp-outputfile.md")
    system(mess)
    cat("The Word (docx) file is", file.path(thedir, newname), "\n")
    mess <- paste('rm tmp-outputfile.md')
    system(mess)
  }
  
  create_html <- function(f){
    knit2html(f)
    cat("The main HTML file is", file.path(thedir, paste0(file_path_sans_ext(f), ".html")), 
        "\nIf transporting do not forget to include the folder", file.path(thedir, "figure"), "\n")
  }
  
  create_pdf <- function(f){
    knit(f, 'tmp-outputfile.md');
    newname <- paste0(file_path_sans_ext(f),".pdf")
    mess <- paste('pandoc -f markdown -o', shQuote(newname), "tmp-outputfile.md")
    system(mess)
    cat("The PDF file is", file.path(thedir, newname), "\n")
    mess <- paste('rm tmp-outputfile.md')
    system(mess)
  }
  
  origdir <- getwd()  
  tryCatch({
    setwd(thedir) ## put us next to the original Rmarkdown file
    out <- match.arg(output)
    switch(out,
           latex=create_latex(thefile),
           html=create_html(thefile),
           pdf=create_pdf(thefile),
           word=create_word(thefile)
    )}, finally=setwd(origdir))
  
}