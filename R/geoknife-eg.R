# install.packages("geoknife") # install geoknife package
library("geoknife")
query('webdata')
cmip = webdata(query('webdata')[13])
query(cmip, "variables")