require 'httparty'
require_relative './coordinate'
require_relative './route_store'

class CycleStreet
  include HTTParty
  base_uri 'http://www.cyclestreets.net/'
  attr_reader :token, :store
  #debug_output $stdout

  def initialize(token = ENV['CYCLESTREET'], in_file = File.join('data', 'msoa-flow-leeds-all.csv'),
                 out_file = File.join('data', 'msoa-leeds-all-with_route.csv'))
    @token = token
    @store = RouteStore.new(in_file, out_file)
  end

  def query
    store.open do |route|
      if route.orig == route.dest
        fastest = {'time' => 0, 'length' => 0 }
        quietest = fastest
      else
        fastest  = api_call(route, 'fastest')
        quietest = api_call(route, 'quietest')
      end

      sleep(1) # don't hammer CycleStreets

      store.save do |csv|
        csv << route.to_a +
          [fastest['time'], fastest['length'], quietest['time'], quietest['length']]
      end
    end
  end

  private

  def api_call(route, plan)
    self.class.get('/api/journey.xml', query: {
      key: token,
      plan: plan,
      itinerarypoints: "#{route.orig.lat},#{route.orig.long}|#{route.dest.lat},#{route.dest.long}",
      segments: '0',
    })['markers']['marker']
  end
end
