Quick web maps in R
------------------------
Increasingly, data analysts are being requested to tailor their work to the web offering improved usability and accessibility. For this there are a growing number of packages in R offering wrappers to common web visualization libraries such as D3 and Leaflet.

In this exercise, a quick Leaflet Map will be produced showing population density in each of the London boroughs. The steps are roughly as follows. 1) import and project your shapefile. 2) Convert the shapefile to geojson. 3) Specify graphics parameters. 4) Create your map. This method is suited to smalled datasets which do not require large spatial data resources. 
  
```
library(maptools)
library(leafletR)
library(RColorBrewer)
```
Once you have loaded the libraries above, set your working directory to the data file you downloaded. In this example, the Creating-maps-in-R file has been placed on the desktop.

```
setwd("C:/Users/AlistairPC/Desktop/Creating-maps-in-R")
lndbor <- readShapePoly("data/LondonBoroughs.shp", proj4string=CRS("+init=epsg:27700"))
```

With the spatial data loaded, the next step is to convert the spatial data to geojson; an open standard for encoding spatial data. The toGeoJSON function performs this operation and writes the geojson file to the working directory. This file is temporary and will not be required when display/publishing the results. The LeafletR package embeds the geojson data inside the html document meaning no additional data is required. This may lead to 

```
toGeoJSON(lndbor, overwrite=T, name="lndbor")
```

With the data processing now complete, the next step is to decide on styling. In this example, the data is cut into quantiles. Next, the attributes to be displayed in the callouts should be specified. In this case area name, population density and total population have been included. Finally, the style parameters must be set. The main parameters are prop, breaks, style.val, leg and alpha. prop specifies the attribute to display, cut the break to use, style.val is the colour ramp, leg is the legend title and fill.apha is the fill transparancy. Alternative color ramps can be found on the colorbrewer website. 

```
cuts<-ceiling(quantile(lndbor@data$PopDen, probs = seq(0, 1, 0.20), na.rm = FALSE))+1
cuts[1]<-cuts[1]-1

popup<-c("name", "PopDen","Pop_2001")

sty<-styleGrad(prop="PopDen", breaks=cuts, right=TRUE, style.par="col",
               style.val=(brewer.pal(6, 'Blues')), leg="Pop Density", lwd=0,  fill.alpha=0.6)
```
The final step brings everything together. Importantly, the geojson file created previously should be in the working directory.

```
map<-leaflet(data="lndbor.geojson", dest=getwd(), style=sty,
             title="londonpopmap", base.map="osm",
             incl.data=TRUE,  popup=popup,
             size=c(800,600))
```
The following line of code will launch the map in your browser and should look like the example displayed below. 


```
browseURL(map)
```

![picture alt](https://dl.dropboxusercontent.com/u/8890726/leafletRmap.JPG)   




It should be noted that to incorporate the map into an existing web page, the scripts, css components and map data must be copied into the new document. Failure to do this will result in the map failing to be displayed correctly.

Pasted into the **head** section of the html document
```
  <link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.7.2/leaflet.css" />
	<script src="http://cdn.leafletjs.com/leaflet-0.7.2/leaflet.js?2"></script>
```
Pasted into the **css** section of the html document

```
      #map {
  		width: 800px;
			height: 600px;
		}
		table, td {
			border-collapse: collapse;
			border-style: solid;
			border-width: 1px;
			border-color: #e9e9e9;
			padding: 5px;
		}
		.evenrowcol{
			background-color: #f6f6f6;
		}
		.legend {
			padding: 6px 8px;
			font: 14px/16px Arial, Helvetica, sans-serif;
			background: white;
			background: rgba(255,255,255,0.8);
			box-shadow: 0 0 15px rgba(0,0,0,0.2);
			border-radius: 5px;
			line-height: 18px;
			color: #555;
		}
		.legend i {
			width: 18px;
			height: 18px;
			float: left;
			margin-right: 8px;
			opacity: 0.6;
		}
```
Pasted into the **body** section of the html document.Everything from:
```
<div id="map"></div>
  <script type="text/javascript">
		var map = L.map('map')
		var baseMap1 = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
			attribution: '&copy; <a href="http://openstreetmap.org/copyright", target="_blank">OpenStreetMap contributors</a>'
		});
		baseMap1.addTo(map);
    
```
Down to.
```
  				grades[i] + '&ndash;' + grades[i + 1] + '<br>';
			}
			return div;
		};
		legend.addTo(map);
	</script>
```

















