

```r
# Reproducible workflow for transport planning

# How to represent movement on a map?
o = c(5, 51)
d = c(8, 52)

plot(rbind(o, d))
lines(rbind(o, d))
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)

```r
library(stplanr)
(o = geo_code("Utrecht"))
```

```
##      lon      lat 
##  5.12142 52.09074
```

```r
(d = geo_code("Munster"))
```

```
##       lon       lat 
##  7.626135 51.960665
```

```r
r_osrm = viaroute(startlat = o[2], startlng = o[1], endlat = d[2], endlng = d[1])
```

```
## Error in if (grepl("application/json", httrreq$headers$`content-type`) == : argument is of length zero
```

```r
r_sp = viaroute2sldf(r_osrm)
```

```
## Error in viaroute2sldf(r_osrm): object 'r_osrm' not found
```

```r
plot(r_sp)
```

```
## Error in plot(r_sp): object 'r_sp' not found
```

```r
library(tmap)
r_bb = tmaptools::bb(r_sp, 2)
```

```
## Error in get_bb(x, cx = cx, cy = cy, width = width, height = height, xlim = xlim, : object 'r_sp' not found
```

```r
data("Europe")
qtm(Europe) +
  qtm(r_sp)
```

```
## Error in qtm(r_sp): object 'r_sp' not found
```

```r
# try with tmap_mode("view")

# Scaling up the solution to many trips with stplanr
# See the stplanr intro vignette:
# https://cran.r-project.org/web/packages/stplanr/vignettes/introducing-stplanr.html
head(cents)
```

```
## class       : SpatialPointsDataFrame 
## features    : 6 
## extent      : -1.550806, -1.511861, 53.8041, 53.82887  (xmin, xmax, ymin, ymax)
## coord. ref. : +init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 
## variables   : 4
## names       :  geo_code,  MSOA11NM, percent_fem,  avslope 
## min values  : E02002361, Leeds 032,    0.408759, 2.284782 
## max values  : E02002393, Leeds 064,    0.591141, 5.091685
```

```r
head(flow)
```

```
##        Area.of.residence Area.of.workplace All Work.mainly.at.or.from.home
## 920573         E02002361         E02002361 109                           0
## 920575         E02002361         E02002363  38                           0
## 920578         E02002361         E02002367  10                           0
## 920582         E02002361         E02002371  44                           0
## 920587         E02002361         E02002377  34                           0
## 920591         E02002361         E02002382   7                           0
##        Underground..metro..light.rail..tram Train Bus..minibus.or.coach
## 920573                                    0     0                     4
## 920575                                    0     1                     4
## 920578                                    0     0                     1
## 920582                                    0     0                     2
## 920587                                    0     0                     0
## 920591                                    0     0                     1
##        Taxi Motorcycle..scooter.or.moped Driving.a.car.or.van
## 920573    2                            0                   39
## 920575    1                            0                   24
## 920578    0                            0                    8
## 920582    2                            0                   28
## 920587    1                            2                   19
## 920591    0                            0                    5
##        Passenger.in.a.car.or.van Bicycle On.foot
## 920573                         3       2      59
## 920575                         4       0       4
## 920578                         0       0       1
## 920582                         3       3       6
## 920587                         3       0       9
## 920591                         1       0       0
##        Other.method.of.travel.to.work                  id
## 920573                              0 E02002361 E02002361
## 920575                              0 E02002361 E02002363
## 920578                              0 E02002361 E02002367
## 920582                              0 E02002361 E02002371
## 920587                              0 E02002361 E02002377
## 920591                              0 E02002361 E02002382
```

```r
rd = od2line(flow = flow, zones = cents)
plot(rd)
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-2.png)

Output the result


```r
# old = setwd("vignettes")
# knitr::spin("munster-code.R")
# setwd(old)
```

