# Set-up folder for shiny app
dir.create("fixMyPath")
file.create("fixMyPath/ui.R")
file.create("fixMyPath/server.R")

# Test data for shiny app
setwd("~/repos/pct/")
# 500 lines in Leeds city centre!
l <- readRDS("shiny-test/spatial-lines-test/l.Rds")
nrow(l)


