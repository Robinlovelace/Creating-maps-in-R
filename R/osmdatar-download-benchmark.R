bbox <- matrix (c (-0.10, 51.50, -0.08, 51.52), nrow=2, ncol=2)
bbox <- paste0 ('(', bbox [2,1], ',', bbox [1,1], ',',bbox [2,2], ',', bbox [1,2], ')')
key <- '[highway]'
query <- paste0 ('(node', key, bbox, ';way', key, bbox, ';rel', key, bbox, ';')
url_base <- 'http://overpass-api.de/api/interpreter?data='
query <- paste0 (url_base, query, ');(._;>;);out;')

dat <- httr::GET (query, timeout=60)
result <- httr::content (dat, "text", encoding='UTF-8')
microbenchmark::microbenchmark ( dat <- rcpp_get_lines (result), times=100L)

