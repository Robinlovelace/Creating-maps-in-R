Test

```r
plot(Dens, main = "")
plot(lnd, border = "grey", lwd = 2, add = T)
plot(SLDF, col = terrain.colors(8), add = T)
plot(cAg, col = "red", border = "white", add = T)
graphics::text(coordinates(cAg) + 1000, labels = cAg$CODE)
```
