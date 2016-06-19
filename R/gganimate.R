# Aim: create animated map
# devtools::install_github("dgrtwo/gganimate")
pkgs = c("ggmap", "sp", "tmap", "rgeos", "maptools", "dplyr")
lapply(pkgs, library, character.only = TRUE)
lnd = read_shape("data/london_sport.shp")
lnd_f <- fortify(lnd, region = "ons_label") # only for visualisation
lnd_f = rename(lnd_f, ons_label = id)
lnd_f = left_join(lnd_f, lnd@data)

## ---- results='hide'-----------------------------------------------------
london_data = read.csv("data/census-historic-population-borough.csv")
library(tidyr) # if not install it, or skip the next two steps
ltidy = gather(london_data, date, pop, -Area.Code, -Area.Name)
head(ltidy, 2) # check the output (not shown)

head(lnd_f, 2) # identify shared variables with ltidy 
ltidy = rename(ltidy, ons_label = Area.Code) # rename Area.code variable
lnd_f = left_join(lnd_f, ltidy)

lnd_f$date = gsub(pattern = "Pop_", replacement = "", lnd_f$date)

## ----fig.cap="Faceted plot of the distribution of London's population over time", fig.height=6, fig.width=6----
p = ggplot(data = lnd_f, # the input data
       aes(x = long, y = lat, fill = pop/1000, group = group, frame = date)) + # define variables
  geom_polygon() + # plot the boroughs
  geom_path(colour="black", lwd=0.05) + # borough borders
  coord_equal() + # fixed x and y scales
  # facet_wrap(~ date) + # one plot per time slice
  scale_fill_gradient2(low = "blue", mid = "grey", high = "red", # colors
                       midpoint = 150, name = "Population\n(thousands)") + # legend options
  theme(axis.text = element_blank(), # change the theme options
        axis.title = element_blank(), # remove axis titles
        axis.ticks = element_blank()) # remove axis ticks

# needs gganimate package
pa = gganimate::gg_animate(p)
gganimate::gg_animate_save(pa,
                           filename = "figure/lnd-animated.gif",
                           saver = "mp4")

# without imagemagick
dates = unique(lnd_f$date)
i = dates[3]
for(i in dates){
  print(i)
  lnd_tmp = lnd_f[lnd_f$date == i,]
  p = ggplot(data = lnd_tmp, # the input data
             aes(x = long, y = lat, fill = pop/1000, group = group, frame = date)) + # define variables
    geom_polygon() + # plot the boroughs
    geom_path(colour="black", lwd=0.05) + # borough borders
    coord_equal()
  ggsave(paste0("ggplots-", i, ".png"), p)
}

# using tmap - from example(animation_tmap)
data("Europe")
m1 <- tm_shape(Europe) + 
  tm_fill("yellow") + 
  tm_borders() + 
  tm_facets(by = "name", nrow=1,ncol=1)

animation_tmap(m1, filename="European countries.gif", width=800, delay=40)

names(Europe)
popvars = c("pop_est", "pop_est_dens", "gdp_md_est")
m <- tm_shape(Europe) + 
  tm_fill(popvars) + 
  tm_borders() + 
  tm_facets(nrow=1,ncol=1, free.scales = F)
animation_tmap(m, "animation_vnames.gif")

b = quantile(Europe$pop_est, na.rm = T)
m <- tm_shape(Europe) + 
  tm_fill(popvars, breaks = b) + 
  tm_borders() + 
  tm_facets(nrow=1, ncol=1)
animation_tmap(m, "animation_vnames.gif")

?animation_tmap
lnd_df = lnd@data
lnd_df_pop = left_join(lnd_df, london_data)
lnd@data = lnd_df_pop

lnd@data = lnd@data[sort(names(lnd))]
popvars = names(lnd)[grep("Pop", names(lnd))]
popvars = gsub(pattern = "Pop_", "Pop. ", popvars)
names(lnd)[grep("Pop", names(lnd))] = popvars
# lnd@data[popvars] = apply(lnd@data[popvars], 2, function(x) x/ 100000)
m = tm_shape(lnd) +
  tm_borders() +
  tm_fill(popvars, breaks = seq(0, 5e5, by = 1e5)) +
  tm_facets(ncol = 1, nrow = 1) +
  tm_layout(legend.outside = TRUE)
animation_tmap(m, filename = "figure/tmap_animation.gif", width=1200, delay=100)
