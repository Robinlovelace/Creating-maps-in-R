# Aim: display historic map boundaries from a digitised tithe map (1840)

# Dependencies
library(sp)
library(leaflet)

# 1: pre-processing
tmp = geojsonio::geojson_read("data/TMparcels_simplified.geojson", what = "sp")
bbox(tmp)
proj4string(tmp) = CRS("+init=epsg:27700")
tmp = spTransform(tmp, CRSobj = CRS("+init=epsg:4326"))

# Create custom colorscheme for field land uses
cols = colors()[c(151, 26, 233, 26, 26, 142, 47, 33, 33, 81)]
pal = colorFactor(palette = cols, domain = tmp$LandUse)
lab_list = vector(mode = "list", length = length(tmp))
i = 1
for(i in 1:nrow(tmp)){
  df_tab = data.frame(Attribute = c("Owner", "Occupier", "Field name", "Land use"),
                      Value = c(tmp$Owner[i], tmp$Occupier[i], tmp$FieldName[i], tmp$LandUse[i]))
  df_html = htmlTable::htmlTable(df_tab, rnames = F)
  lab_list[[i]] = df_html
}

# Generate interactive map of field boundaries
leaflet() %>% addTiles() %>%
  addPolygons(data = tmp, weight = 1, color = "#000000", popup = lab_list,
            fillColor= ~ pal(LandUse),
            fillOpacity=0.7
            ) %>% 
  addLegend(pal = pal, values = tmp$LandUse)

# # # # # # # # # # # # # #
# Out-takes + experiments #
# # # # # # # # # # # # # #

# The leaflet way
leaflet() %>% addTiles() %>% addPolygons(data = tmp)

# Mapview way:
mapview::mapview(tmp)

# The tmap way:
library(tmap)
qtm(tmp, fill = "LandUse")
tmap_mode("view")
qtm(tmp, fill = "LandUse")

# Reading-in with simple features
tmp_sf = sf::st_read("TMparcels_simplified.shp")
head(tmp_sf)

# Alternative html table generator
tmp_mini = tmp
tmp_mini@data = tmp@data[,c(1, 2, 3, 4, 5)]
lab_list = mapview:::brewPopupTable(tmp_mini)

i = 1
for(i in 1:nrow(tmp)){
  df_tab = data.frame(Attribute = c("Owner", "Occupier", "Field name", "Land use"),
                      Value = c(tmp$Owner[i], tmp$Occupier[i], tmp$FieldName[i], tmp$LandUse[i]))
  # df_html = knitr::kable(df_tab, format = "html", row.names = F) # limited control
  # df_html = xtable::xtable(df_tab) # latex
  df_html = htmlTable::htmlTable(df_tab, rnames = F)
  lab_list[[i]] = df_html
}
