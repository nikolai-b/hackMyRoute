library(shiny)
library(leaflet)
library(ggmap)
library(rgdal)
library(RColorBrewer)
library(dplyr)

# setwd("R/fixMyPath") # go into the directory if running in rstudio

# Load data
map_centre <- geocode("Leeds")
l <- readRDS("al.Rds")

l$color <- "green"
l$color[grepl("fast", rownames(l@data))] <- "red"

lfast <- l[ l$color == "green", ]
lquiet <- l[ l$color == "red", ]

flows <- read.csv("al-flow.csv")
leeds <- readRDS("leeds-msoas-simple.Rds") %>%
  spTransform(CRS("+init=epsg:4326"))

  # Add census data to leeds
  ldata <- read.csv("leeds-msoa-data.csv")
  ldata <- rename(ldata, geo_code = CODE)
  ldata <- inner_join(leeds@data, ldata)
  leeds@data <- ldata
  leeds$color_pcycle <- cut(leeds$pCycle, breaks = quantile(leeds$pCycle), labels = brewer.pal(4, "PiYG") )


shinyServer(function(input, output){

cents <- coordinates(leeds)
cents <- SpatialPointsDataFrame(cents, data = leeds@data, match.ID = F)

 observe({geojson <- RJSONIO::fromJSON(sprintf("%s.geojson", input$feature))

  output$myMap = renderLeaflet(leaflet() %>%
      addTiles() %>%
      addPolygons(data = leeds
        , fillOpacity = 0.4
        , opacity = input$transp_zones
        , fillColor = leeds$color_pcycle
      ) %>%
      addPolylines(data = lfast, color = "red"
                   , opacity = input$transp_fast
        , popup = sprintf("<dl><dt>Distance </dt><dd>%s km</dd><dt>Journeys by bike</dt><dd>%s%%</dd>", round(flows$fastest_distance_in_m / 1000, 1), round(flows$p_cycle * 100, 2))
                   ) %>%
      addPolylines(data = lquiet, color = "green",
                   , opacity = input$transp_fast, popup = sprintf("<dl><dt>Distance </dt><dd>%s km</dd><dt>Journeys by bike</dt><dd>%s%%</dd>", round(flows$quietest_distance_in_m / 1000, 1), round(flows$p_cycle*100,2))
                   ) %>%
      addCircleMarkers(data = cents
                 , radius = 2
                 , color = "black"
                 , popup = sprintf("<b>Journeys by bike: </b>%s%%", round(ldata$pCycle*100,2))) %>%
      addGeoJSON(geojson)
  )})
})

