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

lfast <- l[ l$color == "green", ]
lquiet <- l[ l$color == "red", ]

flows <- read.csv("flows.csv")
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

  #     addPopups(-1.549, 53.8, 'First ever popup in leaflet') # add popup

  observe({geojson <- RJSONIO::fromJSON(sprintf("%s.geojson", input$feature))
leeds
  output$myMap = renderLeaflet(leaflet() %>%
      addTiles() %>%
      setView(lng = map_centre[1], lat = map_centre[2], zoom = 10) %>%
      addPolygons(data = leeds
        , fillOpacity = 0.4
        , opacity = input$transp_zones
        , fillColor = leeds$color_pcycle
      ) %>%
      addPolylines(data = lfast, color = "red", opacity = input$transp_fast, popup = sprintf("<dl><dt>d (m) </dt><dd>%s</dd><dt>%% of journeys by bike</dt><dd>%s</dd>", flows$fastest_distance_in_m, flows$p_cycle)) %>%
      addPolylines(data = lquiet, color = "green", opacity = input$transp_fast, popup = sprintf("<dl><dt>d (m) </dt><dd>%s</dd><dt>%% of journeys by bike</dt><dd>%s</dd>", flows$quietest_distance_in_m, flows$p_cycle)) %>%
      addCircles(data = cents, color = "black") %>%
      addGeoJSON(geojson)
  )
  })
})