Point Pattern analysis and spatial interpolation with R
================

This tutorial teaches the basics of point pattern analysis in R. It is influenced by the chapter on Spatial Point Pattern Analysis in *Applied Spatial Data Analysis with R* (Bivand, Pebesma, and Gómez-Rubio 2013) and an [online tutorial](http://rspatial.org/analysis/rst/8-pointpat.html) on Point Pattern Analyis by Robert Hijmans.

``` r
library(sp)
```

The input datasets are on 'Boris Bikes' docking stations around London, and can be read-in and visualised with the following commands:

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
```

![](point-pattern_files/figure-markdown_github/cycle-hire1-1.png)

It is immediately clear that these two datasets are closely related (they have a high degree of spatial correlation) and have a distinctive pattern. But how to describe that quantitively, and extrapolate the values from the plotted location to other areas?

It is the purpose of this tutorial to provide the knowhow to answer such questions.

Bivand, Roger S, Edzer J Pebesma, and Virgilio Gómez-Rubio. 2013. *Applied Spatial Data Analysis with R*. Vol. 747248717. Springer.
