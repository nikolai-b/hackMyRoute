# hackMyRoute
To convert gml to geoJSON

    curl -X POST -F upload=@journey.gml -F skipFailures='true' http://ogre.adc4gis.com/convert

To run ruby and bundler are prerequisitss
Prerequisites: ruby and bundler.  Then `bundle install`
To run in irb shell
    require './app/cycle_street'
    cycle_street = CycleStreet.new
    cycle_street.query

To run tests
    rspec
