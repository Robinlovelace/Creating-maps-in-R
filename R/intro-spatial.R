## ---- include=FALSE------------------------------------------------------
# output: word_document
# TODO: add details for the ggplot2 section
# TODO: create animation of population change over time
# Add world mapping in ggplot2
library(knitr)
library(methods)
options(replace.assign=FALSE, width=80)

opts_chunk$set(fig.path='knitr_figure/graphics-', 
               cache.path='knitr_cache/graphics-', 
               dev='pdf', fig.width=4, fig.height=3, 
               fig.show='hold', cache=FALSE, par=TRUE)
knit_hooks$set(crop=hook_pdfcrop)

knit_hooks$set(par=function(before, options, envir){
    if (before && options$fig.show!='none') {
        par(mar=c(3,3,2,1),cex.lab=.95,cex.axis=.9,
            mgp=c(2,.7,0),tcl=-.01, las=1)
}}, crop=hook_pdfcrop)

## ----fig.cap="Basic plot of x and y (right) and code used to generate the plot (right).", echo=FALSE, fig.width=6, fig.height=3----
# # Generate data
# x = 1:400
# y = sin(x / 10) * exp(x * -0.01)
# 
# plot(x, y) # plot the result
library(png)
library(grid)
grid.raster(readPNG("figure/plot1.png"))

## ---- eval=FALSE---------------------------------------------------------
## x = c("ggmap", "rgdal", "rgeos", "maptools", "dplyr", "tidyr", "tmap")
## # install.packages(x) # warning: uncommenting this may take a number of minutes
## lapply(x, library, character.only = TRUE) # load the required packages

## ---- echo=FALSE---------------------------------------------------------
# TODO: add info about accessing online data from R

## ---- fig.cap="The RStudio environment with the project tab poised to open the Creating-maps-in-R project.", echo=FALSE----
grid.raster(readPNG("figure/rstudio-proj.png"))

## ---- eval= F, echo=FALSE------------------------------------------------
## # Use the `setwd` command to set the working directory to the folder where the data is saved.
## # If your username is "username" and you saved the files into a
## # folder called "Creating-maps-in-R-master" on your Desktop, for example,
## # you would type the following:
## # setwd("C:/Users/username/Desktop/Creating-maps-in-R-master/")

## ---- message=FALSE, results='hide'--------------------------------------
library(rgdal)
lnd = readOGR(dsn = "data", layer = "london_sport")

## ------------------------------------------------------------------------
head(lnd@data, n = 2)
mean(lnd$Partic_Per)

## ---- fig.height=1.3, echo=FALSE, fig.cap="Tab-autocompletion in action: display from RStudio after typing `lnd@` then `tab` to see which slots are in `lnd`"----
grid.raster(readPNG("figure/tab-complete.png"))

## ---- eval=FALSE---------------------------------------------------------
## plot(lnd) # not shown in tutorial - try it on your computer

## ------------------------------------------------------------------------
# select rows of lnd@data where sports participation is less than 15
lnd@data[lnd$Partic_Per < 15, ]

## ---- eval=FALSE---------------------------------------------------------
## # Select zones where sports participation is between 20 and 25%
## sel = lnd$Partic_Per > 20 & lnd$Partic_Per < 25
## plot(lnd[sel, ]) # output not shown here
## head(sel) # test output of previous selection (not shown)

## ----fig.cap="Simple plot of London with areas of high sports participation highlighted in blue"----
plot(lnd, col = "lightgrey") # plot the london_sport object
sel = lnd$Partic_Per > 25
plot(lnd[ sel, ], col = "turquoise", add = TRUE) # add selected zones to map

## ---- echo=FALSE, fig.cap="Zones in London whose centroid lie within 10 km of the geographic centroid of the City of London. Note the distinction between zones which only touch or 'intersect' with the buffer (light blue) and zones whose centroid is within the buffer (darker blue).", message=FALSE----
library(rgeos)
plot(lnd, col = "grey")
# find London's geographic centroid (add ", byid = T" for all)
cent_lnd = gCentroid(lnd[lnd$name == "City of London",]) 
points(cent_lnd, cex = 3)
# set 10 km buffer
lnd_buffer = gBuffer(spgeom = cent_lnd, width = 10000) 

# method 1 of subsetting selects any intersecting zones
lnd_central = lnd[lnd_buffer,] # the selection is too big!
# test the selection for the previous method - uncomment below
plot(lnd_central, col = "lightblue", add = T)
plot(lnd_buffer, add = T) # some areas just touch the buffer

# method2 of subsetting selects only points within the buffer
lnd_cents = SpatialPoints(coordinates(lnd),
  proj4string = CRS(proj4string(lnd))) # create spatialpoints
sel = lnd_cents[lnd_buffer,] # select points inside buffer
points(sel) # show where the points are located
lnd_central = lnd[sel,] # select zones intersecting w. sel
plot(lnd_central, add = T, col = "lightslateblue", 
  border = "grey")
plot(lnd_buffer, add = T, border = "red", lwd = 2)

# Add text to the plot!
text(coordinates(cent_lnd), "Central\nLondon")

## ---- echo=FALSE---------------------------------------------------------
# should be manipulating and plotting. TODO: talk about base graphics

## ------------------------------------------------------------------------
vec = vector(mode = "numeric", length = 3)
df = data.frame(x = 1:3, y = c(1/2, 2/3, 3/4))

## ------------------------------------------------------------------------
class(vec)
class(df)

## ------------------------------------------------------------------------
mat = as.matrix(df) # create matrix object with as.matrix
sp1 = SpatialPoints(coords = mat)

## ------------------------------------------------------------------------
class(sp1)
spdf = SpatialPointsDataFrame(sp1, data = df)
class(spdf)

## ---- warning=FALSE------------------------------------------------------
proj4string(lnd) = NA_character_ # remove CRS information from lnd
proj4string(lnd) = CRS("+init=epsg:27700") # assign a new CRS

## ------------------------------------------------------------------------
EPSG = make_EPSG() # create data frame of available EPSG codes
EPSG[grepl("WGS 84$", EPSG$note), ] # search for WGS 84 code 
lnd84 = spTransform(lnd, CRS("+init=epsg:4326")) # reproject

## ------------------------------------------------------------------------
# Save lnd84 object (we will use it in Part IV)
saveRDS(object = lnd84, file = "data/lnd84.Rds")

## ------------------------------------------------------------------------
rm(lnd84) # remove the lnd object

## ---- eval=FALSE---------------------------------------------------------
## library(rgdal) # ensure rgdal is loaded
## # Create new object called "lnd" from "london_sport" shapefile
## lnd = readOGR(dsn = "data", "london_sport")
## plot(lnd) # plot the lnd object (not shown)
## nrow(lnd) # return the number of rows (not shown)

## ---- eval=FALSE, echo=FALSE---------------------------------------------
## ## Downloading additional data
## 
## # Because we are using borough-level data, and boroughs are official administrative
## # zones, there is much data available at this level. We will use the example
## # of crime data to illustrate this data availability, and join this with the current
## # spatial dataset. As before, we can download and import the data from within R:
## 
## # download.file("http://data.london.gov.uk/datafiles/crime-community-safety/mps-
## # recordedcrime-borough.csv", destfile = "mps-recordedcrime-borough.csv")
## # uncomment and join the above code to download the data
## crime_data = read.csv("data/mps-recordedcrime-borough.csv",
##   stringsAsFactors = FALSE)
## head(crime_data)
## 
## # Initially, the `read.csv` may an error. If not the `head` command should show
## # that the dataset has not loaded correctly. This was due to an unusual
## # encoding used in the text file: hopefully you will not
## # encounter this problem in your research, but it highlights the importance
## # of checking the input data. To overcome this issue we
## # can set the encoding manually, and continue.
## 
## # variant: markdown_github

## ---- echo=FALSE, eval=FALSE---------------------------------------------
## # # convert crime_data and rename cols
## # crime_data = read.csv("data/mps-recordedcrime-borough.csv",
## #   fileEncoding = "UCS-2LE")
## # names(crime_data)
## # crime_data = rename(crime_data, DName = Spatial_DistrictName)
## # write.csv(crime_data, file = "data/mps-recordedcrime-borough.csv")

## ---- results='hide'-----------------------------------------------------
# Create and look at new crime_data object
crime_data = read.csv("data/mps-recordedcrime-borough.csv",
  stringsAsFactors = FALSE)

head(crime_data, 3) # display first 3 lines
head(crime_data$CrimeType) # information about crime type

# Extract "Theft & Handling" crimes and save
crime_theft = crime_data[crime_data$CrimeType == "Theft & Handling", ]
head(crime_theft, 2) # take a look at the result (replace 2 with 10 to see more rows)

# Calculate the sum of the crime count for each district, save result
crime_ag = aggregate(CrimeCount ~ Borough, FUN = sum, data = crime_theft)
# Show the first two rows of the aggregated crime data
head(crime_ag, 2)

## ------------------------------------------------------------------------
# Compare the name column in lnd to Borough column in crime_ag to see which rows match.
lnd$name %in% crime_ag$Borough
# Return rows which do not match
lnd$name[!lnd$name %in% crime_ag$Borough]

## ---- results='hide', message=FALSE--------------------------------------
?left_join # error flagged
??left_join
library(dplyr) # load the powerful dplyr package (use plyr if unavailable)
?left_join # should now be loaded (use join if unavailable)

## ---- echo=FALSE---------------------------------------------------------
# commented out: old version using plyr version of rename
# crime_ag = rename(crime_ag, replace = c("DName" = "name"))

## ---- results='hide'-----------------------------------------------------
head(lnd$name) # dataset to add to (results not shown)
head(crime_ag$Borough) # the variables to join
crime_ag = rename(crime_ag, name = Borough) # rename the 'Borough' heading to 'name'
# head(left_join(lnd@data, crime_ag)) # test it works
lnd@data = left_join(lnd@data, crime_ag)

## ---- eval=FALSE---------------------------------------------------------
## library(tmap) # load tmap package (see Section IV)
## qtm(lnd, "CrimeCount") # plot the basic map

## ---- echo=FALSE, eval=FALSE---------------------------------------------
## # This is the modified version of the code, to create the map displayed
## library(tmap)
## lnd$Thefts = lnd$CrimeCount / 10000
## qtm(lnd, "Thefts", fill.title = "Thefts\n(10000)", scale = 0.8) +
##   tm_layout(legend.position = c(0.89,0.02))

## ---- echo=FALSE, fig.cap="Number of thefts per borough."----------------
grid.raster(readPNG("figure/lnd-crime.png"))

## ---- echo=FALSE, results='hide', message=FALSE, warning=FALSE, fig.cap="Proportion of council seats won by Conservatives in the 2014 local elections using data from data.london.gov and joined using the methods presented in this section"----
library(ggmap)
borough_dat = read.csv("data/london-borough-profiles-2014.csv")
names(borough_dat)
borough_dat = rename(borough_dat, conservative = Proportion.of.seats.won.by.Conservatives.in.2014.election)
borough_dat$conservative = as.numeric(as.character(borough_dat$conservative))
summary(borough_dat$conservative)
head(lnd$ons_label)
head(borough_dat$Code)
# check the joining variables work
summary(borough_dat$Code %in% lnd$ons_label)
# rename the linking variable
borough_dat = rename(borough_dat, ons_label = Code)
to_join = select(borough_dat, ons_label, conservative)
lnd@data = left_join(lnd@data, to_join)

library(maptools)
lnd_f = fortify(lnd, region = "ons_label") # you may need to load maptools
lnd_f = rename(lnd_f, ons_label = id)
head(lnd_f$ons_label)
head(lnd$ons_label)

lnd_f = left_join(lnd_f, lnd@data)

map = ggplot(lnd_f, aes(long, lat, group = group, fill = conservative)) +
  geom_polygon() +
  coord_equal() +
  labs(x = "Easting (m)", y = "Northing (m)", fill = "% Tory") +
  scale_fill_continuous(low = "grey", high = "blue") +
  theme_nothing(legend = T)
map

## ---- results='hide'-----------------------------------------------------
library(rgdal)
# create new stations object using the "lnd-stns" shapefile.
stations = readOGR(dsn = "data", layer = "lnd-stns")
proj4string(stations) # this is the full geographical detail.
proj4string(lnd) # what's the coordinate reference system (CRS)
bbox(stations) # the extent, 'bounding box' of stations
bbox(lnd) # return the bounding box of the lnd object

## ----fig.cap="Sampling and plotting stations"----------------------------
# Create reprojected stations object
stations27700 = spTransform(stations, CRSobj = CRS(proj4string(lnd)))
stations = stations27700 # overwrite the stations object 
rm(stations27700) # remove the stations27700 object to clear up
plot(lnd) # plot London for context (see Figure 9)
points(stations) # overlay the station points

## ----fig.cap="The clipped stations dataset"------------------------------
stations_backup = stations # backup the stations object
stations = stations_backup[lnd, ] 
plot(stations) # test the clip succeeded (see Figure 10)

## ---- echo=F,eval=FALSE--------------------------------------------------
## # save(lnd, file="data/lnd.RData")
## # save(stations, file="data/stations.RData")

## ---- eval=FALSE---------------------------------------------------------
## sel = over(stations_backup, lnd)
## stations2 = stations_backup[!is.na(sel[,1]),]

## ------------------------------------------------------------------------
stations_agg = aggregate(x = stations["CODE"], by = lnd, FUN = length)
head(stations_agg@data)

## ------------------------------------------------------------------------
lnd$n_points = stations_agg$CODE

## ------------------------------------------------------------------------
lnd_n = aggregate(stations["NUMBER"], by = lnd, FUN = mean)

## ----fig.cap="Choropleth map of mean values of stations in each borough"----
brks = quantile(lnd_n$NUMBER)
labs = grey.colors(n = 4)
q = cut(lnd_n$NUMBER, brks, labels = labs, 
  include.lowest = T)
summary(q) # check what we've created

qc = as.character(q) # convert to character class to plot
plot(lnd_n, col = qc) # plot (not shown in printed tutorial)
legend(legend = paste0("Q", 1:4), fill = levels(q), "topright")
areas = sapply(lnd_n@polygons, function(x) x@area)

## ---- eval=F-------------------------------------------------------------
## levels(stations$LEGEND) # see A roads and rapid transit stations (RTS) (not shown)
## sel = grepl("A Road Sing|Rapid", stations$LEGEND) # selection for plotting
## sym = as.integer(stations$LEGEND[sel]) # symbols
## points(stations[sel,], pch = sym)
## legend(legend = c("A Road", "RTS"), "bottomright", pch = unique(sym))

## ---- echo=FALSE, eval=FALSE---------------------------------------------
## # , fig.cap="Symbol levels for train station types in London"
## q = cut(lnd_n$NUMBER, breaks= c(quantile(lnd_n$NUMBER)), include.lowest=T)
## clr = as.character(factor(q, labels = paste0("grey", seq(20, 80, 20))))
## plot(lnd_n, col = clr)
## legend(legend = paste0("q", 1:4), fill = paste0("grey", seq(20, 80, 20)), "topright")
## sel = grepl("A Road Sing|Rapid", stations$LEGEND) # selection for plotting
## sym = as.integer(stations$LEGEND[sel]) # symbols
## points(stations[sel,], pch = sym)
## legend(legend = c("A Road", "RTS"), "bottomright", pch = unique(sym))

## ------------------------------------------------------------------------
# install.packages("tmap") # install the CRAN version
# to download the development version, use the devtools package
# devtools::install_github("mtennekes/tmap", subdir = "pkg", build_vignette = TRUE)
library(tmap)
vignette(package = "tmap") # available vignettes in tmap
vignette("tmap-nutshell")

## ---- eval=FALSE---------------------------------------------------------
## # Create our first tmap map (not shown)
## qtm(shp = lnd, fill = "Partic_Per", fill.palette = "-Blues")

## ---- fig.cap="Side-by-side maps of crimes and % voting conservative"----
qtm(shp = lnd, fill = c("Partic_Per", "Pop_2001"), fill.palette = c("Blues"), ncol = 2)

## ---- fig.cap="Facetted map of London Boroughs created by tmap"----------
tm_shape(lnd) +
    tm_fill("Pop_2001", thres.poly = 0) +
tm_facets("name", free.coords=TRUE, drop.shapes=TRUE) +
    tm_layout(legend.show = FALSE, title.position = c("center", "center"), title.size = 20)

## ------------------------------------------------------------------------
p = ggplot(lnd@data, aes(Partic_Per, Pop_2001))

## ----fig.cap="A simple graphic produced with **ggplot2**", fig.height=1.7, fig.width=3----
p + geom_point()

## ----fig.cap="ggplot with aesthetics", eval=FALSE------------------------
## p + geom_point(aes(colour=Partic_Per, size=Pop_2001)) # not shown

## ----fig.cap="ggplot for text", fig.height=3, fig.width=4----------------
p + geom_point(aes(colour = Partic_Per, size = Pop_2001)) +
  geom_text(size = 2, aes(label = name))

## ---- warning=FALSE------------------------------------------------------
library(rgeos)
lnd_f = fortify(lnd) # you may need to load maptools

## ------------------------------------------------------------------------
head(lnd_f, n = 2) # peak at the fortified data
lnd$id = row.names(lnd) # allocate an id variable to the sp data
head(lnd@data, n = 2) # final check before join (requires shared variable name)
lnd_f = left_join(lnd_f, lnd@data) # join the data

## ------------------------------------------------------------------------
lnd_f[1:2, 1:8]

## ----fig.cap="Map of Lond Sports Participation"--------------------------
map = ggplot(lnd_f, aes(long, lat, group = group, fill = Partic_Per)) +
  geom_polygon() +
  coord_equal() +
  labs(x = "Easting (m)", y = "Northing (m)",
    fill = "% Sports\nParticipation") +
  ggtitle("London Sports Participation")

## ----fig.cap="Greyscale map"---------------------------------------------
map + scale_fill_gradient(low = "white", high = "black")

## ---- eval=FALSE---------------------------------------------------------
## ggsave("large_plot.png", scale = 3, dpi = 400)

## ---- eval=FALSE---------------------------------------------------------
## install.packages("leaflet")
## library(leaflet)
## 
## leaflet() %>%
##   addTiles() %>%
##   addPolygons(data = lnd84)

## ---- echo=FALSE, fig.cap="The lnd84 object loaded in rstudio via the leaflet package"----
grid.raster(readPNG("figure/rstudio-leaflet.png"))

## ---- echo=FALSE---------------------------------------------------------
# library(reshape2) # old way of doing
# If not install it, or skip the next two steps

## ---- results='hide'-----------------------------------------------------
london_data = read.csv("data/census-historic-population-borough.csv")
library(tidyr) # if not install it, or skip the next two steps
ltidy = gather(london_data, date, pop, -Area.Code, -Area.Name)
head(ltidy, 2) # check the output (not shown)

## ---- echo=FALSE, eval=FALSE---------------------------------------------
## # lnd_molten = melt(london_data, id = c("Area.Code", "Area.Name"))
## # lnd_molten = read.csv("data/london_data_melt.csv")
## # head(lnd_molten)
## # names(lnd_molten)[3] = "date"
## # Only do this step if reshape and melt failed

## ------------------------------------------------------------------------
head(lnd_f, 2) # identify shared variables with ltidy 
ltidy = rename(ltidy, ons_label = Area.Code) # rename Area.code variable
lnd_f = left_join(lnd_f, ltidy)

## ---- echo=FALSE---------------------------------------------------------
# old way of doing it
# lnd_f = merge(lnd_f, ltidy, by.x = "id", by.y = "Area.Code")

## ------------------------------------------------------------------------
lnd_f$date = gsub(pattern = "Pop_", replacement = "", lnd_f$date)

## ----fig.cap="Faceted plot of the distribution of London's population over time", fig.height=6, fig.width=6----
ggplot(data = lnd_f, # the input data
  aes(x = long, y = lat, fill = pop/1000, group = group)) + # define variables
  geom_polygon() + # plot the boroughs
  geom_path(colour="black", lwd=0.05) + # borough borders
  coord_equal() + # fixed x and y scales
  facet_wrap(~ date) + # one plot per time slice
  scale_fill_gradient2(low = "blue", mid = "grey", high = "red", # colors
    midpoint = 150, name = "Population\n(thousands)") + # legend options
  theme(axis.text = element_blank(), # change the theme options
    axis.title = element_blank(), # remove axis titles
    axis.ticks = element_blank()) # remove axis ticks
# ggsave("figure/facet_london.png", width = 9, height = 9) # save figure

## ---- echo=FALSE---------------------------------------------------------
# **Creating an animation of population change over time**

# library(animation)

## ---- echo=FALSE, eval=FALSE---------------------------------------------
## system("mv intro-spatial.pdf intro-spatial-rl.pdf") # change name

