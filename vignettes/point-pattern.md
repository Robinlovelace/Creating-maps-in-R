Point Pattern analysis and spatial interpolation with R
================

This tutorial teaches the basics of point pattern analysis in R. It is influenced by the chapter on Spatial Point Pattern Analysis in *Applied Spatial Data Analysis with R* (Bivand, Pebesma, and Gómez-Rubio 2013) and an [online tutorial](http://rspatial.org/analysis/rst/8-pointpat.html) on Point Pattern Analyis by Robert Hijmans.

We will use the **sp** package for this rather than the newer **sf** package, as point pattern analysis is more established for the formers `Spatial` class system than the latter's `sf` classes. We will also use **raster** as it has concise and well-designed functions for spatial data:

``` r
library(sp)
library(raster)
```

This tutorial assumes you have downloaded the GitHub repo [`robinlovelace/Creating-maps-in-R`](https://github.com/Robinlovelace/Creating-maps-in-R) and that the working directory of your R session is the root directory of this project.

<!-- Could say how to this with download.file... -->
The input datasets, cunningly stored in the `data/` directory, are on 'Boris Bikes' docking stations around London, and can be read-in and visualised with the following commands:

``` r
lnd = rgdal::readOGR("data/lnd.geojson")
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "data/lnd.geojson", layer: "OGRGeoJSON"
    ## with 33 features
    ## It has 7 fields

``` r
cycle_hire = rgdal::readOGR("data/cycle_hire.geojson")
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "data/cycle_hire.geojson", layer: "OGRGeoJSON"
    ## with 742 features
    ## It has 5 fields

``` r
cycle_hire_osm = rgdal::readOGR("data/cycle_hire-osm.geojson")
```

    ## OGR data source with driver: GeoJSON 
    ## Source: "data/cycle_hire-osm.geojson", layer: "OGRGeoJSON"
    ## with 532 features
    ## It has 5 fields

``` r
plot(cycle_hire)
points(cycle_hire_osm, col = "red")
plot(lnd, add = TRUE)
```

![](point-pattern_files/figure-markdown_github/cycle-hire1-1.png)

It is immediately clear that the two datasets on cycle hire points are closely related (they have a high degree of spatial correlation) and have a distinctive pattern. `cycle_hire` represents official data on cycle parking, and will be the main point dataset analysed. `cycle_hire_osm` is the community contributed dataset on cycle hire locations, downloaded from OpenStreetMap. Both sets of points overlay some of London's 33 boroughs, the central ones, and seem to follow the River Thames, especially along the north bank of the river. But how to describe that information quantitively, and extrapolate the values from the plotted location to other areas?

It is the purpose of this tutorial to provide the knowhow to answer such questions, that should be extensible to many applications that involve point data.

A basic statistic to compute on points within a polygon is the number of points per polygon, and the related statistic of point density. Let's first compute that for London overall, before doing a zone-by-zone breakdown:

``` r
nrow(cycle_hire)
```

    ## [1] 742

``` r
lnd_area = sum(area(lnd)) / 1e6
```

The results show that there are 742 cycle hire points and that London covers an area of just over one and a half thousand square kilometres (1 km<sup>2</sup> = 1000000 m<sup>2</sup> = 1e6 m<sup>2</sup> in scientific notation). That represents on average roughly one cycle parking rental space per 2 square kilometers, or half a rental point per square kilometer, as revealed by the results of the calculation below:

``` r
nrow(cycle_hire) /
  lnd_area
```

    ## [1] 0.4714415

This is not a good indicator of the density of the bike hire scheme overall, because they are so concentrated in central London. A more representative result can be found by calculating the average point density *within the extent of the bike hire scheme*. We can coerce the bounding box (or extent in **raster** terminology) of the stations into a polygon whose area can be measured with the following commands:

``` r
bb_hire = as(extent(cycle_hire), "SpatialPolygons")
crs(bb_hire) = crs(lnd)
```

Exercises
---------

-   What is the average point density of cycle hire points within the scheme's bounding box?

<!-- ```{r} -->
<!-- c_area = area(bb_hire) / 1e6 -->
<!-- nrow(cycle_hire) / c_area -->
<!-- ``` -->
-   Why did we add the second line of code in the previous code chunk?
-   Why are there two `crs()` calls?
-   The above chunk uses **raster** functions. How would you write the above code using **sp** code?

Challenges
----------

-   Reproduce the result using **sp** code.
-   Reproduce the resuts using **sf** code.

References
==========

Bivand, Roger S, Edzer J Pebesma, and Virgilio Gómez-Rubio. 2013. *Applied Spatial Data Analysis with R*. Vol. 747248717. Springer.
