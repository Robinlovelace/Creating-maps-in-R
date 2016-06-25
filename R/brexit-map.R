# Aim: create regional map of election results
library(purrr)

# Packages we'll use
pkgs = c("rvest", "geojsonio", "tmap", "dplyr",
         "stringdist")

# @hrbrmstr note
# walk() has no output side effects, so it's like a true list version
# of a for loop
walk(pkgs, library, character.only = T)

# 1: Get local authority data

# @hrbrmstr note
# with url() being a function, many new folks to R have trouble
# debugging errors when they've mistakenly used it in the wrong
# context, so this helps provide a better practice for them.
# also adding the "if" for the download as it's both bandwidth
# friendly for the server and helps those R stats folks who aren't
# on speedy connections (like some entire countries and even half of the
# U.S. state I live in)
URL = "https://github.com/npct/pct-bigdata/raw/master/las-dbands.geojson"
fil = "las.geojson"
if (!file.exists(fil)) download.file(URL, fil)
las = geojson_read(fil, what = "sp")

# 2: Get and test results data
URL = "http://www.bbc.co.uk/news/politics/eu_referendum/results/local/a"
bbc = read_html(URL)

la_name = bbc %>%
  html_nodes(".eu-ref-result-bar__title") %>%
  html_text()
vote_leave = bbc %>%
  html_nodes(".eu-ref-result-bar__party-votes--percentage") %>%
  html_text() %>%
  gsub(pattern = " |%", replacement = "") %>%
  as.numeric()
vote_leave = vote_leave[(1:length(la_name)) * 2 - 1]

ref_result = data_frame(geo_label = la_name, `% vote leave` = vote_leave)

# @hrbrmstr note: `local_authority` is not defined

summary(local_authority %in% las$geo_label) # looks good
las@data = left_join(las@data, ref_result)
summary(las$vote_leave)
qtm(las, "% vote leave")

# 3: Run for all data points

# @hrbrmstr note
# avoids the need for RCurl URL check (see use inside map_df below)
S_read_html <- safely(read_html)

# @hrbrmstr note
# this doesn't take too long but progress bars are always nice
p <- progress_estimated(length(letters))

# @hrbrmstr note
# map_df() will let you return data[_.]frames and it will
# efficiently do the rbinding. Also, since the BBC shows the
# letters j, q, x & z grayed out, we can just not use them which
# shld avoid any errant URL grabs.
map_df(setdiff(letters, c("j", "q", "x", "z")), function(i) {
  p$tick()$print()
  URL = sprintf("http://www.bbc.co.uk/news/politics/eu_referendum/results/local/%s", i)
  bbc = S_read_html(URL)
  if (is.null(bbc$result)) return(data_frame(geo_label = NULL, `% vote leave` = NULL))
  bbc <- bbc$result
  la_name = bbc %>%
    html_nodes(".eu-ref-result-bar__title") %>%
    html_text()
  vote_leave = bbc %>%
    html_nodes(".eu-ref-result-bar__party-votes--percentage") %>%
    html_text() %>%
    gsub(pattern = " |%", replacement = "") %>%
    as.numeric()
    vote_leave = vote_leave[(1:length(la_name)) * 2 - 1]
  data_frame(geo_label = la_name, `% vote leave` = vote_leave)
}) -> ref_result
ref_result_orig = ref_result
las = geojson_read("las.geojson", what = "sp")
las$geo_label = as.character(las$geo_label)

# Manual fixes
ref_result$geo_label[grep("Corn", ref_result$geo_label)] =
  las$geo_label[grep("Corn", las$geo_label)]
ref_result$geo_label[grep("Heref", ref_result$geo_label)] =
  las$geo_label[grep("Heref", las$geo_label)]

# @hrbrmstr note: `ams`` isn't defined yet
ref_result$geo_label[msel] = las$geo_label[ams]

# Auto fixes
msel = !ref_result$geo_label %in% las$geo_label
mismatches = ref_result$geo_label[msel]
ams = amatch(mismatches, las$geo_label, method = "osa", maxDist = 3)
pmatches = cbind(as.character(las$geo_label[ams]),
                 ref_result$geo_label[msel])


las$geo_label[grep("and", las$geo_label)]

las@data = left_join(las@data, ref_result)

summary(las$`% vote leave`)
las$`% vote leave` = las$`% vote leave` - 50
tm_shape(las) +
  tm_fill("% vote leave", palette = "RdBu",
    title = "% vote leave\n(swing)") +
  tm_borders(lwd = 0.1)

