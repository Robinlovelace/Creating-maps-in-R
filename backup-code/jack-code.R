# Jack's first R script

??download # double ? means 'search help'

library(curl)
curl_download(url = "http://api.worldbank.org/v2/en/indicator/ag.lnd.agri.zs?downloadformat=csv", destfile = "here.csv")

# Ah it's a zip file - convert
file.rename(from = "here.csv", to = "here.zip")

unzip("here.zip")

??csv
library(readr)
df <- readr::read_csv("ag.lnd.agri.zs_Indicator_en_csv_v2.csv")
class(df)
names(w)