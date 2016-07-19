# download CAUTHs
# combined authorities (CAUTH) in England as at 17 June 2016
u = "https://data.gov.uk/dataset/combined-authorities-eng-jun-2016-boundaries-generalised-clipped/datapackage.zip"
download.file(url = u, destfile = "cuath.zip")
unzip("cuath.zip")
unzip("data/Combinned_Authorities_(Eng)_Jun_2016_boundaries_(generalised_clipped).zip")
cauth = read_shape("CAUTH_JUN_2016_EN_BGC.shp")
qtm(cauth, fill = "blue")
object.size(cauth) / 1000000 # less than a MB
saveRDS(cauth, "data/cauth.Rds")
f = list.files(pattern = "CAUTH")
file.remove(f)
