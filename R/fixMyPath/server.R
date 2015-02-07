library(shiny)
library(leaflet)
library(ggmap)
library(rgdal)
library(dplyr)

# setwd("R/fixMyPath") # go into the directory if running in rstudio

# Load data
map_centre <- geocode("Leeds")
l <- readRDS("al.Rds")

l$color <- "green"
l$color[grepl("fast", rownames(l@data))] <- "red"

leeds <- readRDS("leeds-msoas-simple.Rds") %>%
  spTransform(CRS("+init=epsg:4326"))
  feature = "cycleparking"

  # Add census data to leeds
  ldata <- read.csv("leeds-msoa-data.csv")
  ldata <- rename(ldata, geo_code = CODE)
  ldata <- inner_join(leeds@data, ldata)
  leeds@data <- ldata
  leeds$color_pcycle <- cut(leeds$pCycle, breaks = quantile(leeds$pCycle), labels = brewer.pal(4, "PiYG") )


shinyServer(function(input, output){

cents <- coordinates(leeds)
cents <- SpatialPointsDataFrame(cents, data = leeds@data, match.ID = F)

  #     addPopups(-1.549, 53.8, 'First ever popup in leaflet') # add popup

  observe({geojson <- RJSONIO::fromJSON(sprintf("%s.geojson", input$feature))

  output$myMap = renderLeaflet(leaflet(data = l) %>%
      addTiles() %>%
      setView(lng = map_centre[1], lat = map_centre[2], zoom = 10) %>%
      addPolygons(data = leeds
        , fillOpacity = 0.4
        , opacity = input$transp_zones
        , fillColor = leeds$color_pcycle
      ) %>%
      addPolylines(color = l$color, opacity = input$transp_fast) %>%
      addCircles(data = cents, color = "black") %>%
      addGeoJSON(geojson)
  )
  })
})