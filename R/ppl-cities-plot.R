ppl_cities <- c(
  "Leeds",
  "Namur",
  "Harrogate",
  "Horsforth",
  "Chester",
  "Guildford",
  "UK, Birmingham",
  "London",
  "Newcastle",
  "Chilumba Malawi"
)

coords <- ggmap::geocode(ppl_cities)

dfh <- data.frame(city = ppl_cities, coords)
dfhsp <- SpatialPointsDataFrame(coords = coords, data = dfh)
plot(dfhsp)
bbox(dfhsp)
head(dfh)
class(dfh)

bb <- ggmap::make_bbox(lon, lat, dfh)

ggmap(ggmap = get_map(bb, zoom = 3)) +
  geom_point(aes(lon, lat), data = dfh)
