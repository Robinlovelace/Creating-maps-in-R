# Packages

# Uncomment next line if devtools not installed
# install.packages("devtools")

# Install and load development version of stplanr package (uncomment)
# devtools::install_github("ropensci/stplanr")
# install.packages("stplanr")
library(stplanr)

# od data
head(flow[c(1:3, 12)])
head(cents)
plot(cents)
l = od2line(flow, zones)
plot(l, add = T)
plot(l, lwd = l$All / 10)
mapview(l)

# Look at the help for the function
# ?toptail_buff
# example("toptail_buff")

# Run example code
plot(zones)
plot(routes_fast, col = "yellow", lwd = 5, add = T)
r_anon = toptail_buff(l = routes_fast, buff = zones)
plot(r_anon, add = T)

# compile this code to html
# knitr::spin("R/stplanr-example.R", format = "Rhtml")
