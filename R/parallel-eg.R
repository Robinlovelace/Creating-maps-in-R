library(foreach)
library(doParallel)
(nc = detectCores())
cl = makeCluster(nc)
registerDoParallel(cl)
system.time(foreach(i = 1:10) %do% 
              print(mean(rnorm(10e6, i, 10))))
system.time({
  res = foreach(i = 1:10) %dopar%
    mean(rnorm(10e6, i, 10))
  print(res)
}
)