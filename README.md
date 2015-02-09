# hackMyRoute

Our entry into the #HackMyRoute 'hackathon' organised by Leeds ODI.

Write-up of event: http://www.leedsdatamill.org/hacks-events/hack-my-route-live-blog/

Working version of the app: https://robinlovelace.shinyapps.io/fixMyPath/
This should be reproducible (see in the R folder, try and let us know).

More on context: http://www.r-bloggers.com/the-leaflet-package-for-online-mapping-in-r/

## Ruby stuff

To run ruby and bundler are prerequisits
Prerequisites: ruby and bundler.  Then `bundle install`

To query run in irb shell

    require './app/cycle_street'
    cycle_street = CycleStreet.new
    cycle_street.query

To convert a txt file in "-1.12,60.1 -1.03,63.1" format to GeoJson (the file will be overwritten)

    require './app/geo_json'
    geo_json = GeoJson.new('./path/to/file/filename')
    geo_json.convert

To run tests

    rspec
