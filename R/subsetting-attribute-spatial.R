object.size(lnd_f)
object.size(lnd)
lnd@proj4string

lnd@polygons[[1]]@Polygons[[1]]@coords

plot(lnd@polygons[[1]]@Polygons[[1]]@coords)
plot(lnd)
points(lnd@polygons[[1]]@Polygons[[1]]@coords)

lnd_many = lnd[c(10, 4, 13, 22),]
plot(lnd)
plot(lnd_many, add = T, col = "red")

sel = lnd$Pop_2001 > median(lnd$Pop_2001)
class(sel)
lnd_highpop = lnd[sel,]
nrow(lnd_highpop)

# select zones near central London
lnd_cent = gCentroid(lnd)
lnd_cents = gCentroid(lnd, byid = T)
class(lnd_cent)
lnd_central = lnd[lnd_cent,]
plot(lnd_central, add = T, col = "black")
points(lnd_cent, col = "blue")

cent_buffer = gBuffer(lnd_cent, width = 10000)
plot(cent_buffer)

plot(lnd, add = T)

lnd_near_cent = lnd[cent_buffer,]
plot(lnd_near_cent, add = T, col = "red")

plot(lnd_cents)
cents_central = lnd_cents[cent_buffer,]
plot(cents_central)

lnd_near_cent = lnd[cents_central,]
plot(lnd)
plot(cent_buffer, add = T)
plot(lnd_near_cent, add = T, col = "black")
