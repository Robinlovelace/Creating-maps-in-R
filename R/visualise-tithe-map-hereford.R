# Aim: display historic map boundaries from a digitised tithe map (1840)

# Dependencies
library(sp)
library(leaflet)
library(raster)

# 1: pre-processing
tmp = geojsonio::geojson_read("data/TMparcels_simplified.geojson", what = "sp")
field_vars = c("Owner", "Occupier", "FieldName", "LandUse")
field_var_names = c("Owner", "Occupier", "Field name", "Land use")
tmp@data[field_vars] = apply(tmp@data[field_vars], 2, as.character)
bbox(tmp)
proj4string(tmp) = CRS("+init=epsg:27700")
tmp = spTransform(tmp, CRSobj = CRS("+init=epsg:4326"))

# Create custom colorscheme for field land uses
cols = colors()[c(151, 26, 233, 26, 26, 142, 47, 33, 33, 81)]
pal = colorFactor(palette = cols, domain = tmp$LandUse)
lab_list = vector(mode = "list", length = length(tmp))
i = 1
for(i in 1:nrow(tmp)){
  df_tab = data.frame(Attribute = field_vars,
                      Value = c(tmp$Owner[i], tmp$Occupier[i], tmp$FieldName[i], tmp$LandUse[i]))
  df_html = htmlTable::htmlTable(df_tab, rnames = F)
  lab_list[[i]] = df_html
}
# these were generated with gdal2tiles.py TMO_georef_4326.tif
tithe_url = "https://www.mapbox.com/studio/tilesets/robinlovelace.ae9wdjpx/{z}/{x}/{y}.png"
# Generate interactive map of field boundaries
leaflet() %>%
  addTiles(urlTemplate = tithe_url, group = "Tithe original", options = tileOptions(tms = T)) %>% 
  addTiles(group = "OSM") %>%
  addProviderTiles(provider = "Esri.WorldImagery", group = "Satellite") %>% 
  addPolygons(data = tmp, weight = 1, color = "#000000", popup = lab_list,
            fillColor= ~ pal(LandUse),
            fillOpacity = 0.6,
            group = "Tithe map"
            ) %>% 
  addLegend(pal = pal, values = tmp$LandUse, title = "Land use (1840)") %>% 
  addLayersControl(baseGroups = c("Tithe original", "OSM", "Satellite"), overlayGroups = c("Tithe map"),
                   options = layersControlOptions(collapsed = F))
  

# # # # # # # # # # # # # #
# Out-takes + experiments #
# # # # # # # # # # # # # #

# The leaflet way
leaflet() %>% addTiles() %>% addPolygons(data = tmp)

leaflet() %>%
  addTiles(urlTemplate = tithe_url, options = tileOptions(tms = T)) %>% 
  addPolygons(data = tmp)

# With mapbox tiles
# devtools::install_github('rstudio/leaflet')
# devtools::install_github('bhaskarvk/leaflet.mapbox')
library(leaflet.mapbox)

leafletMapbox(access_token = Sys.getenv("MAPBOX")) %>%
  addMapboxTileLayer(mapbox.classicStyleIds$dark)

leafletMapbox(access_token = Sys.getenv("MAPBOX")) %>%
  addMapboxTileLayer(id = "robinlovelace.ae9wdjpx", group = "Tithe original", options = tileOptions(tms = T)) %>% 
  addTiles(group = "OSM") %>%
  addProviderTiles(provider = "Esri.WorldImagery", group = "Satellite") %>% 
  addPolygons(data = tmp, weight = 1, color = "#000000", popup = lab_list,
              fillColor= ~ pal(LandUse),
              fillOpacity = 0.6,
              group = "Tithe map"
  ) %>% 
  addLegend(pal = pal, values = tmp$LandUse, title = "Land use (1840)") %>% 
  addLayersControl(baseGroups = c("Tithe original", "OSM", "Satellite"), overlayGroups = c("Tithe map"),
                   options = layersControlOptions(collapsed = F))


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

r = stack("data/TMO_georef.tif")
ri = r$TMO_georef.1
plotRGB(r)
mapview::viewRGB(r)