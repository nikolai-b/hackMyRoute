require 'httparty'

# Create coodinate reference system structure
Coordinate = Struct.new(:lat, :long)

class CycleStreet
  include HTTParty
  base_uri 'http://www.cyclestreets.net/'
  # debug_output $stdout

  def initialize(token)
    @token = token
  end

  def get_route
    orgi = Coordinate.new(-1.382217, 53.836727)
    dest = Coordinate.new(-1.495513, 53.861031)
    route(orgi, dest)
  end

  def route(orig, dest)
    self.class.get('/api/journey.xml', query: {
      key: @token,
      plan: 'fastest',
      itinerarypoints: "#{orig.lat},#{orig.long}|#{dest.lat},#{dest.long}",
      segments: '0',
    })
  end
end
