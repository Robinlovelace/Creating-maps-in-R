Joining and clipping
========================================================

This tutorial builds on the previous section on plotting and highlights 
some of R's more advanced spatial functions. We look at joining new 
datasets to our data - an attribute join - spatial joins, whereby 
data is added to the target layer depending on the location of the 
origins and clipping. 

## Joining based on attributes
To reaffirm our starting point, let's re-plot the only 
spatial dataset in our workspace, and count the number
of polygons:

```r
library(rgdal)
```

```
## Loading required package: sp
## rgdal: version: 0.8-10, (SVN revision 478)
## Geospatial Data Abstraction Library extensions to R successfully loaded
## Loaded GDAL runtime: GDAL 1.10.0, released 2013/04/24
## Path to GDAL shared files: /usr/share/gdal/1.10
## Loaded PROJ.4 runtime: Rel. 4.8.0, 6 March 2012, [PJ_VERSION: 480]
## Path to PROJ.4 shared files: (autodetected)
```

```r
lnd <- readOGR(dsn = ".", "london_sport")
```

```
## OGR data source with driver: ESRI Shapefile 
## Source: ".", layer: "london_sport"
## with 33 features and 4 fields
## Feature type: wkbPolygon with 2 dimensions
```

```r
plot(lnd)
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1.png) 

```r
nrow(lnd)
```

```
## [1] 33
```


### Downloading additional data
Because we are using borough-level data, and boroughs are official administrative
zones, there is much data available at this level. We will use the example 
of crime data to illustrate this data availability, and join this with the current 
spatial dataset. As before, we can download and import the data from within R:

```r
# download.file('http://data.london.gov.uk/datafiles/crime-community-safety/mps-recordedcrime-borough.csv',
# destfile = 'mps-recordedcrime-borough.csv') uncomment the above line of
# code to download the data

crimeDat <- read.csv("mps-recordedcrime-borough.csv")  # flags an error
```

```
## Error: invalid multibyte string at '<ff><fe>M'
```

Initially, the `read.csv` command flags an error: open the raw .csv file in a 
text editor such as Notepad, Notepad++ or GVIM, find the problem and correct it.
Alternatively, you can work out what the file encoding is and use the correct 
argument (this is not recommended - simpler just to edit the text file
in most cases).


```r
crimeDat <- read.csv("mps-recordedcrime-borough.csv", fileEncoding = "UCS-2LE")
head(crimeDat)
```

```
##    Month                   MajorText                   MinorText
## 1 201104 Violence Against The Person              Common Assault
## 2 201104                    Burglary      Burglary In A Dwelling
## 3 201104   Other Notifiable Offences            Other Notifiable
## 4 201104                     Robbery           Personal Property
## 5 201104            Theft & Handling       Handling Stolen Goods
## 6 201104            Theft & Handling Theft/Taking Of Pedal Cycle
##   CrimeCount   Spatial_DistrictName
## 1         81 Kensington and Chelsea
## 2         78 Kensington and Chelsea
## 3         12 Kensington and Chelsea
## 4         41 Kensington and Chelsea
## 5          3 Kensington and Chelsea
## 6         59 Kensington and Chelsea
```

```r
summary(crimeDat$MajorText)
```

```
##                    Burglary             Criminal Damage 
##                        1543                        3125 
##                       Drugs             Fraud & Forgery 
##                        1925                        1581 
##   Other Notifiable Offences                     Robbery 
##                        1374                        1517 
##             Sexual Offences            Theft & Handling 
##                        1557                        6264 
## Violence Against The Person 
##                        4885
```

```r
crimeTheft <- crimeDat[which(crimeDat$MajorText == "Theft & Handling"), ]
head(crimeTheft)
```

```
##     Month        MajorText                              MinorText
## 5  201104 Theft & Handling                  Handling Stolen Goods
## 6  201104 Theft & Handling            Theft/Taking Of Pedal Cycle
## 13 201104 Theft & Handling Motor Vehicle Interference & Tampering
## 15 201104 Theft & Handling               Theft From Motor Vehicle
## 21 201104 Theft & Handling                           Theft Person
## 23 201104 Theft & Handling          Theft/Taking Of Motor Vehicle
##    CrimeCount   Spatial_DistrictName
## 5           3 Kensington and Chelsea
## 6          59 Kensington and Chelsea
## 13          5 Kensington and Chelsea
## 15        132 Kensington and Chelsea
## 21         76 Kensington and Chelsea
## 23         45 Kensington and Chelsea
```

```r
crimeAg <- aggregate(CrimeCount ~ Spatial_DistrictName, FUN = "sum", data = crimeTheft)
head(crimeAg)  # show the aggregated crime data
```

```
##   Spatial_DistrictName CrimeCount
## 1 Barking and Dagenham      12222
## 2               Barnet      19821
## 3               Bexley       8155
## 4                Brent      16823
## 5              Bromley      15172
## 6               Camden      36493
```

Now that we have crime data at the borough level, the challenge is to join it
by name. This is not always straightforward. Let us see which names in the 
crime data match the spatial data:

```r
lnd$name %in% crimeAg$Spatial_DistrictName
```

```
##  [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [12]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [23]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE
```

```r
lnd$name[which(!lnd$name %in% crimeAg$Spatial_DistrictName)]
```

```
## [1] City of London
## 33 Levels: Barking and Dagenham Barnet Bexley Brent Bromley ... Westminster
```

The first line of code above shows that all but one of the borough names matches;
the second tells us that it is City of London that is named differently in the 
crime data:

```r
levels(crimeAg$Spatial_DistrictName)
```

```
##  [1] "Barking and Dagenham"   "Barnet"                
##  [3] "Bexley"                 "Brent"                 
##  [5] "Bromley"                "Camden"                
##  [7] "Croydon"                "Ealing"                
##  [9] "Enfield"                "Greenwich"             
## [11] "Hackney"                "Hammersmith and Fulham"
## [13] "Haringey"               "Harrow"                
## [15] "Havering"               "Hillingdon"            
## [17] "Hounslow"               "Islington"             
## [19] "Kensington and Chelsea" "Kingston upon Thames"  
## [21] "Lambeth"                "Lewisham"              
## [23] "Merton"                 "Newham"                
## [25] "NULL"                   "Redbridge"             
## [27] "Richmond upon Thames"   "Southwark"             
## [29] "Sutton"                 "Tower Hamlets"         
## [31] "Waltham Forest"         "Wandsworth"            
## [33] "Westminster"
```

```r
levels(crimeAg$Spatial_DistrictName)[25] <- as.character(lnd$name[which(!lnd$name %in% 
    crimeAg$Spatial_DistrictName)])
lnd$name %in% crimeAg$Spatial_DistrictName  # now all columns match
```

```
##  [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [15] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [29] TRUE TRUE TRUE TRUE TRUE
```

The above code block first identified the row with the faulty name and 
then renamed the level to match the `lnd` dataset. Note that we could not
rename the variable directly, as it is stored as a factor.

We are now ready to join the datasets. It is recommended to use 
the `join` function in the `plyr` package but the `merge` function 
could equally be used.

```r
`?`(join)
```

```
## No documentation for 'join' in specified packages and libraries:
## you could try '??join'
```

```r
library(plyr)
`?`(join)
```

The documentation for join will be displayed if the plyr package is loaded (if not,
load or install and load it!). It requires all joining variables to have the 
same name, so we will rename the variable to make the join work:

```r
head(lnd$name)
```

```
## [1] Bromley              Richmond upon Thames Hillingdon          
## [4] Havering             Kingston upon Thames Sutton              
## 33 Levels: Barking and Dagenham Barnet Bexley Brent Bromley ... Westminster
```

```r
head(crimeAg$Spatial_DistrictName)  # the variables to join
```

```
## [1] Barking and Dagenham Barnet               Bexley              
## [4] Brent                Bromley              Camden              
## 33 Levels: Barking and Dagenham Barnet Bexley Brent Bromley ... Westminster
```

```r
crimeAg <- rename(crimeAg, replace = c(Spatial_DistrictName = "name"))
head(join(lnd@data, crimeAg))  # test it works
```

```
## Joining by: name
```

```
##   ons_label                 name Partic_Per Pop_2001 CrimeCount
## 1      00AF              Bromley       21.7   295535      15172
## 2      00BD Richmond upon Thames       26.6   172330       9715
## 3      00AS           Hillingdon       21.5   243006      15302
## 4      00AR             Havering       17.9   224262      12611
## 5      00AX Kingston upon Thames       24.4   147271       9023
## 6      00BF               Sutton       19.3   179767       8810
```

```r
lnd@data <- join(lnd@data, crimeAg)
```

```
## Joining by: name
```


## Adding point data for clipping and spatial join
In addition to joing by zone name, it is also possible to do
[spatial joins](http://help.arcgis.com/en/arcgisdesktop/10.0/help/index.html#//00080000000q000000) in R. There are three main varieties: many-to-one - where
the values of many intersecting objects contribute to a new variable in 
the main table - one-to-many, or one-to-one. Because boroughs in London 
are quite large, we will conduct a many-to-one spatial join.
We will be using Tube Stations as the spatial data to join, 
with the aim of finding out which and how many stations
are found in each London borough.

```r
download.file("http://www.personal.leeds.ac.uk/~georl/egs/lnd-stns.zip", "lnd-stns.zip")
unzip("lnd-stns.zip")
library(rgdal)
stations <- readOGR(dsn = ".", layer = "lnd-stns", p4s = "+init=epsg:27700")
```

```
## OGR data source with driver: ESRI Shapefile 
## Source: ".", layer: "lnd-stns"
## with 2532 features and 27 fields
## Feature type: wkbPoint with 2 dimensions
```

```r
proj4string(stations)  # this is the full geographical detail.
```

```
## [1] "+init=epsg:27700 +proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +datum=OSGB36 +units=m +no_defs +ellps=airy +towgs84=446.448,-125.157,542.060,0.1502,0.2470,0.8421,-20.4894"
```

```r
proj4string(lnd)
```

```
## [1] "+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +units=m +no_defs"
```

```r
bbox(stations)
```

```
##              min    max
## coords.x1 455435 602523
## coords.x2 122266 227704
```

```r
bbox(lnd)
```

```
##      min    max
## x 503571 561941
## y 155851 200932
```

The above code loads the data correctly, but also shows that 
there are problems with it: the Coordinate Reference System (CRS)
differs from that of our shapefile. 
Although OSGB 1936 (or EPSG 27700) is the 'correct' CRS for the UK, 
we will convert the stations dataset into lat-long coordinates, 
as this is a more common CRS and enables easy basemap creation:
 

```r
stationsWGS <- spTransform(stations, CRSobj = CRS(proj4string(lnd)))
stations <- stationsWGS
rm(stationsWGS)
plot(lnd)
points(stations[sample(1:nrow(stations), size = 500), ])
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9.png) 


Now we can clearly see that the stations overlay the boroughs.
The problem is that the stations dataset is far more exentsive than
London borough dataset; we need 


## Clipping
There are a number of functions that we can use to clip the points
so that only those falling within London boroughs are retained:

```r
`?`(overlay)
`?`(sp::over)
library(rgeos)
```

```
## rgeos version: 0.2-19, (SVN revision 394)
##  GEOS runtime version: 3.3.8-CAPI-1.7.8 
##  Polygon checking: TRUE
```

```r
`?`(rgeos::gIntersects)
```

We can write off the first one straight away as it is depreciated by the second. 
It seems that `gIntersects` can produce the same output as `over`, based 
on [discussion](http://gis.stackexchange.com/questions/63793/how-to-overlay-a-polygon-over-spatialpointsdataframe-and-preserving-the-spdf-dat) 
in the community,  so either 
can be used. (See this 
[discussion](http://stackoverflow.com/questions/15881455/how-to-clip-worldmap-with-polygon-in-r)
for further alternatives.) 
In this tutorial we will use `gIntersects`,
for clipping although we could equally use 
`gContains`, `gWithin` and other `g...` functions -
see rgeos help pages by typing `?gOverlaps` or other functions for more.
`gIntersects` will output information for each point, telling us which 
polygon it interacts with (i.e. the polygon it is in):

```r
int <- gIntersects(stations, lnd, byid = T)  # find which stations intersect 
class(int)  # it's outputed a matrix
```

```
## [1] "matrix"
```

```r
dim(int)  # with 33 rows (one for each zone) and 2532 cols (the points)
```

```
## [1]   33 2532
```

```r
summary(int[, c(200, 500)])  # not the output of this
```

```
##     200             500         
##  Mode :logical   Mode :logical  
##  FALSE:33        FALSE:32       
##  NA's :0         TRUE :1        
##                  NA's :0
```

```r
plot(lnd)
points(stations[200, ], col = "red")  # note point id 200 is outside the zones
points(stations[500, ], col = "green")  # note point 500 is inside
which(int[, 500] == T)  # this tells us that point 500 intersects with zone 32
```

```
## 31 
## 32
```

```r
points(coordinates(lnd[32, ]), col = "black")  # test the previous statement
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11.png) 

Now that we know how gIntersects works in general terms, let's use it to 
allocate a borrough to each of our station points, which we will then 
aggregate up. Data from these points (e.g. counts, averages in each area etc.)
can then be transferred to the main polygons table: the essence of a spatial 
join....



## Aggregating the data to complete the join

