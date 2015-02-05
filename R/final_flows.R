# # # # # # # # #
# Flows to plot #
# # # # # # # # #

# # # # # # # # # # # # # # # # #
# Stage 1: manipulate the data  #
# # # # # # # # # # # # # # # # #

f <- read.csv("data/msoa-leeds-all-with-route.csv")
# which cols do we want from f?
names(f) # id and last 4 are new

fl <- read.csv("data/msoa-flow-leeds-all.csv")
names(fl)
fl$lon_dest[1:5] == f$lon_dest[1:5]
summary(fl$lon_dest == f$lon_dest)
summary(fl$lat_origin == f$lat_origin)
summary(fl$lat_origin == f$lat_origin)

fl$lat_dest <- f$lat_dest

f <- f[c(1, 6:9)]
names(f)
ids <- f$id
f$id <- NULL

flows <- cbind(ids, fl, f)

# Is this the final df?
summary(flows$dist) # na - we kanye be doing with 0 dists
flows <- flows[flows$dist > 10, ]

head(flows) # yay we have the final data frame

# # # # # # # # # # # # #  #
# Extract the ones to plot #
# # # # # # # # # # # # #  #

# Top ecp (extra cycling potential)
t10 <- head(order(flows$ecp, decreasing = TRUE), 10)
top_ecp <- flows[t10,]
summary(top_ecp$ecp)
summary(flows$ecp)

# How good is the estimate of cycling potential?
plot(flows$pc, flows$Bicycle)
cor(flows$pc, flows$Bicycle)

# Top difference in distances

# Top Cycled distances







# Saving the routes
library(rgdal)
library("maptools")
source("R/sp-patch.R")
fns <- paste0(top_ecp$ids, "-")

al <-  readOGR("local-data/10022-quiet.txt", layer = "OGRGeoJSON")

for(i in fns){
  rfile <- list.files(path = "local-data/", pattern = i, full.names = T)
  for(j in rfile){
    l <- readOGR(j, layer = "OGRGeoJSON")
    # l@lines # why?
    spChFIDs(l) <- j
    # if(is.null(al)) al <- l
    # else al <- spRbind(al, l)
    al <- spRbind(al, l)

  }
}

plot(al[-1,])
writeOGR(al, layer = "shape1", dsn = "/tmp/", driver = "ESRI Shapefile")
