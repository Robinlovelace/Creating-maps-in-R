# # # # # # # # # # # # # # # # # # # # 
# Simplify sp objects w. mapshaper    #
# Needs https://nodejs.org installed  #
# Tested on Windows and Linux         #
# # # # # # # # # # # # # # # # # # # # 

# # # # # #
# R setup #
# # # # # #

if(!require(devtools)) install.packages("devtools") # installs devtools if needs be
devtools::install_github("ropensci/stplanr") # install dev. version of stplanr
library(stplanr) # load the stplanr library
mapshape_available() # is mapshaper available to system()?

# # # # # # # # # # #
# data to simplify  #
# # # # # # # # # # #

rnet = overline(routes_fast)
rnet = overline(routes_fast, attrib = "All")

# # # # # # #
# simplify  #
# # # # # # #

rnet5 = mapshape(rnet, percent = 5)
rnet1 = mapshape(rnet, percent = 1)
rnets = mapshape(rnet, ms_options = "snap-interval=0.001")

# # # # #
# plot  #
# # # # #

par(mfrow = c(2,2))
plot(rnet, main = "No simplification")
plot(rnet5, main = "5% simplification")
plot(rnet1, main = "1% simplification")
plot(rnets, main = "snap interval simplification")
