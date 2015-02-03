require 'httparty'
require './coordinate'
require './route_store'

class CycleStreet
  include HTTParty
  base_uri 'http://www.cyclestreets.net/'
  attr_reader :token, :store
  #debug_output $stdout

  def initialize(token)
    @token = token
    @store = RouteStore.new
  end

  def query
    store.open do |orig, dest|
      if orig == dest
        fast = {'time' => 0, 'length' => 0}
        quiet = fast
      else
        fast = route(orig, dest, 'fastest')
        quiet = route(orig, dest, 'quietest')
      end
      store.save << [
        orig.lat, orig.long,
        dest.lat, dest.long,
        fast['time'], fast['length'],
        quiet['time'], quiet['length'],
      ]
    end
  end

  private

  def route(orig, dest, plan)
    res = self.class.get('/api/journey.xml', query: {
      key: token,
      plan: plan,
      itinerarypoints: "#{orig.lat},#{orig.long}|#{dest.lat},#{dest.long}",
      segments: '0',
    })
    puts [orig, dest, plan, res]
    res['markers']['marker']
  end
end
