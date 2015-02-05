# hackMyRoute
To run ruby and bundler are prerequisitss
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
