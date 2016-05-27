# Aim: load and visualise netcdf data

# download data from nasa, as described here:
# http://disc.sci.gsfc.nasa.gov/recipes/?q=recipes/How-to-Read-Data-in-netCDF-Format-with-R

# install ncdf4
# install.packages("ncdf4")

# load the data
r = raster("data/nc_3B42.20060101.03.7A.HDF.Z.ncml.nc")
class(r)
plot(r)
plot(r, ylim = c(100, 150))
