# Extracting cycle routing from CycleStreets.net
pkgs <- c("ggmap", "jsonlite")
lapply(pkgs, library, character.only = TRUE)

# Example start - end points
from <- geocode("Buckingham Palace")
to <- geocode("Westminster Abbey")

from_string <- paste(from, collapse = ",")
to_string <- paste(to, collapse = ",")

from_to_string <- paste(from_string, to_string, sep = "|")

key <- readLines("~/Dropbox/dotfiles/cyclestreets-api-key-rl") # where is your key

api_request_base <- sprintf("https://%s@api.cyclestreets.net/v2/", key)

plan <- c("quietest", "balanced", "fastest")[1]

journey_plan <- sprintf("journey.plan?waypoints=%s&plan=%s", from_to_string, plan)


request <- paste0(api_request_base, journey_plan)

json_object <- jsonlite::fromJSON(request, simplifyVector = F)
# json_object <- jsonlite::fromJSON("bikeshops.geojson", simplifyVector = F) # test

# Test the output
library(leaflet)
leaflet() %>%
  addTiles() %>%
  addGeoJSON(json_object)
