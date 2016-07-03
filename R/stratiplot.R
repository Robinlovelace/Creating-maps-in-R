# Stratigraphy with R
# install.packages("stratigraph")
library(stratigraph)
data(plain)
plot.strat.column(counts = plain[,2:4], depths = plain[,1],
                  tax.cat = as.factor(c(1,2,1)), output.size = c(4,4),
                  reorder = 'lad.by.category')


library(analogue)
example("Stratiplot")
