### Collaboration script with Robin
### Robin, here is the code. We basically want to acknowledge Ben Schmidt for
### his advice. Step 5 in this script is the one from him, and this solves the
### problem you had. I think I need your help to explain Ben's trick. Let me know
### how we can go from here.
### Last update: December 1, 2012
### Copyright: Kota Hattori and Robin Lovelace

library(maps)
library(rgeos) # auto loads sp
library(maptools)
library(geosphere)
library(ggmap) # auto-loads ggplot2
library(dplyr)


### Step 1: Get longitude and latitude for destinations using ggmap

cities <- c("Wellington", "Briasbaine", "Melbourne", "Adelaide", "Perth",
		    "Santiago", "Bogota", "Sao Paulo", "Cape Town",
		    "Seattle", "Vancouver", "Dallas", "Houston", "Atlanta", "Chicago", "New York",
		    "Tokyo", "Osaka", "Fukuoka", "Singapore", "Manila", "Chennai",
		    "Helsinki", "Rome", "Paris", "Berlin", "London", "Copenhargen", "Stockholm")

destinations <- geocode(cities)
destinations$cities <- cities

### Change column names
colnames(destinations) <- c("arr_lon", "arr_lat", "cities")


### Step 2: Get longitude and latitude for the departure city (i.e., Sydney)

sydney <- geocode("sydney")


### Step 3: Create a data frame with destinations and sydney

mydf <- mutate(destinations,
			   dep_lon = sydney$lon,
			   dep_lat = sydney$lat)


### Step 4: Calculate routes
### gcIntermediate() returns class SpatialLines.

rts <- gcIntermediate(mydf[,c('dep_lon', 'dep_lat')], mydf[,c('arr_lon', 'arr_lat')],
					  100, breakAtDateLine = FALSE, addStartEnd = TRUE, sp = TRUE)


### Create a SpatialLinesDataFrame and convert it to data.frame using fortify().
### In order to use ggplot2, I need to have a data.frame object.

rts <- as(rts, "SpatialLinesDataFrame")
rts.2 <- fortify(rts)

### Add cities in this data frame. This will help us specify line colors later.
### For each route, there are 102 dots. We repeat each destination 102 times and
### create a new column.

rts.2 <- mutate(rts.2, destination = rep(cities, each = 102))


### Step 5: Split lines

### If I draw ggplot with the present data, R draws funny horizontal lines
### which go from one end of the worldmap to the other end. I communicated
### with Ben Schmidt and he kindly suggested a soluition.
### I need to split flight lines into two. The following is his email.

### Adding NAs works if you're using R's 'line' function as in Nathan's tutorial; in ggplot, though, 
### I tend to do this using "geom_path." Then all you need to do is create a new variable that instead
### of keeping each flight as a single path, divides it into two (one for one side of the date line, one
###  for the other.) I've found the easiest way to do this is to call anything a break when it moves
### more than 30 degrees (which in practice is usually when it's moving from long -179 to long
### 179 or something.) Then by adding a call to aes(group=yourGroupName), it doesn't try to connect.

### This is Ben's shipping map
### https://gist.github.com/bmschmidt/9914296

####break groups that cross from 0 to 360 or vice versa, which otherwise leave streaks

rts.2$split = c(0, abs(rts.2$long[-1] - rts.2$long[1:(nrow(rts.2) - 1)]) > 20)

rts.2$id = as.numeric(rts.2$id)

rts.2$segment = 100 * rts.2$id + cumsum(rts.2$split)


### Step 6: Get a world map

worldmap <- map_data ("world")


### Step 7: Draw the flight map

base <- ggplot()

map <- geom_polygon(data = worldmap, aes(x = long, y = lat, group = group),
				    size = 0.1, color = "#090D2A", fill = "#090D2A", alpha = 1)

#png("Robin2.png", width = 12, height = 9, units="in", res = 500)

base + map + geom_path(data = rts.2, aes(x = long, y = lat, group = segment, color = destination),
							   alpha = 0.5, lineend = "round", lwd = 0.5) +
				     coord_equal() +
				     scale_x_continuous(breaks = NULL, expand = c(0, 0)) +
				     scale_y_continuous(breaks = NULL, expand = c(0, 0)) +
				     theme(axis.title.x = element_blank(),
				           axis.title.y = element_blank(),  
				           legend.position = "none")
#dev.off()

