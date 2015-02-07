library(shiny)
library(leaflet)
library(ggmap)
library(rgdal)
library(foreign)

# setwd("R/fixMyPath") # go into the directory if running in rstudio

# Load data
map_centre <- geocode("Leeds")
l <- readRDS("al.Rds")
# source("colorsave.R")
l$color <- "green"
l$color[grepl("fast", rownames(l@data))] <- "red"

leeds <- readRDS("leeds-msoas-simple.Rds") %>%
  spTransform(CRS("+init=epsg:4326"))

shinyServer(function(input, output){

cents <- coordinates(leeds)
cents <- SpatialPointsDataFrame(cents, data = leeds@data)

  #     addPopups(-1.549, 53.8, 'First ever popup in leaflet') # add popup

  output$myMap = renderLeaflet(leaflet( data = l) %>%
      addTiles("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png") %>%
      setView(lng = map_centre[1], lat = map_centre[2], zoom = 10) %>%
      addPolygons(data = leeds
        , opacity = input$transp_zones
      ) %>%
      addPolylines(color = l$color, opacity = input$transp_fast) %>%
      addCircles(data = cents, color = "black")
  )

})