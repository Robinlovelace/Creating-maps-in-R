library("rnoaa")
library("ggplot2")
yrs = seq(1985, 2015, by = 10)
urls = sapply(yrs, function(x)
  seaiceeurls(yr = x, mo = 'Sep', pole = 'N'))
out = lapply(urls, seaice)
names(out) <- yrs
# saveRDS(out, "data/out-ice.Rds")
df = dplyr::rbind_all(out, id = "Year")
xlims = quantile(df$lat, probs = c(0.01, 0.90))
ylims = quantile(df$long, probs = c(0.01, 0.99))
ggplot(df, aes(long, lat, group = paste(group, Year))) +
  geom_path() +
  geom_polygon(aes(fill = Year), alpha = 0.3) +
  theme_ice() +
  xlim(xlims) +
  ylim(ylims) +
  scale_fill_brewer(type = "seq")
ggsave("figures/icesheet-change.png")
# Alternative ways of doing the df rbind
# df = do.call(rbind, out)
# df = rbind_all(out, id = "id")