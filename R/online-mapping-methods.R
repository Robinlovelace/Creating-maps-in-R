library(tmap)
library(sp)
lnd = read_shape("data/london_sport.shp")
names(lnd)
plot(lnd)
lnd_wgs = spTransform(lnd, CRS("+init=epsg:4326"))
qtm(lnd_wgs, fill = "Pop_2001")
tmap_mode(mode = "plot")

vignette("tmap-nutshell")
vignette("tmap-modes")

qtm(lnd)
bbox(lnd)

leaflet() %>%
  addPolygons(data = lnd_wgs) %>%
  addPolygons(data = lnd_wgs)

library(leaflet)
leaflet() %>% addTiles() %>%
  addPolygons(data = lnd_wgs)

df = data.frame(x = 12, y = 150000)

names(lnd)
plot(lnd$Partic_Per, lnd$Pop_2001)
library(ggplot2)
ggplot(data = lnd@data, aes(Partic_Per, Pop_2001)) +
  geom_point(aes(color = Pop_2001)) +
  scale_color_gradient(low = "green", high = "red")
  
  geom_point(data = df, aes(x = x, y = y), color = "red")
