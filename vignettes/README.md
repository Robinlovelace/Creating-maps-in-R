```r
install.packages(“rgeos”)
library(rgeos)
```

An introductory tutorial on R as a GIS is the working paper “Introduction to visualising spatial data in R” ([Lovelace and Cheshire, 2014](https://github.com/Robinlovelace/Creating-maps-in-R)). This document, along with sample code and data, is available free online. It contains links to many other spatial R resources, so is a good starting point for further explorations of R as a GIS.

## R in action as a GIS

To demonstrate where R's flexibility comes into its own, imagine you have a large number of points that you would like to analyse. These are heavily clustered in a few area, and you would like to a) know where these clusters are; b) remove the points in these clusters and create single points in their place, which summarise the information contained in the clustered points; c) visualise the output.

![clustering](https://github.com/Robinlovelace/Creating-maps-in-R/raw/master/vignettes/figure/Aggregated_data_for_culters.png)

We will not actually run through all the steps needed to do this in R. Suffice to know that it is possible in R and very difficult to do in other GIS packages such as [QGIS](http://www.qgis.org/en/site/), ArcGIS or even [PostGIS](http://postgis.net/) (another command line GIS that is based on the database language Postgres, a type of SQL): I was asked to tackle this problem by the Spanish GIS service SIGTE after other solutions had been tried.

All of the steps needed to solve the problem, including provision of example data, are provided [online](http://robinlovelace.net/r/2014/03/21/clustering-points-R.html). Here I provide an overview of the processes involved and some of the key functions to provide insight into the R way of thinking about spatial data. 

First the data must be loaded and converted into yet another spatial data class. This is done using the `readOGR` function from the **rgdal** package mentioned above and then using the command `as(SpatialPoints(stations), "ppp")` to convert the spatial object stations into the ppp class from the spatstat package. 

Next the data is converted into a density raster. The value of each pixel corresponds to the interpolated density of points in that area. This is visualised using the `plot` and `contour` functions to ensure that the conversion has worked properly.

The raster image is converted into smooth lines using the `contourLines`. The lines, one for each cluster zone, must then be converted into polygons using the command `gPolygonize(SLDF[5, ])`. `gPolygonize` is a very useful function from the rgeos package which automates the conversion of lines into polygons.

The results are plotted using the rather lengthy set of commands shown below. This results in the figure displayed above (notice the `red` argument creates the red fill of the zones):


```r
plot(Dens, main = "")
plot(lnd, border = "grey", lwd = 2, add = T)
plot(SLDF, col = terrain.colors(8), add = T)
plot(cAg, col = "red", border = "white", add = T)
graphics::text(coordinates(cAg) + 1000, labels = cAg$CODE)
```

Finally the points inside the cluster polygons are extracted using R's very concise spatial subsetting syntax:


```r
sIn <- stations[cAg, ]  # select the stations inside the clusters
```
