pkgs <- c("rgdal", "rgeos", "shiny", "leaflet", "dplyr")
reqs <- as.numeric(lapply(pkgs, require, character.only = TRUE))
# Install packages we require
if(sum(!reqs) > 0) install.packages(pkgs[!reqs])

# Load data
leeds <- readRDS("~/repos/pct/pct-data/leeds/leeds-msoas-simple.Rds") %>%
  spTransform(CRS("+init=epsg:4326"))

map_centre <- leeds %>%
  gCentroid() %>%
  coordinates()

function(input, output){

  a <- reactive({input$display})
  # a <- input$display
  # What's loaded?
#   if(a()){
#     leeds <- leeds[1,]
#   }

  map = leaflet() %>%
    addTiles() %>%
    setView(lng = map_centre[1], lat = map_centre[2], zoom = 11, ) %>%
    addPolygons(data = leeds)
#     addPolylines()
  #     addPopups(-1.549, 53.8, 'First ever popup in leaflet') # add popup

  output$myMap = renderLeaflet(map)
  output$text = renderText(a())

}