require 'httparty'
require_relative './coordinate'
require_relative './route_store'

class CycleStreet
  include HTTParty
  base_uri 'http://www.cyclestreets.net/'
  attr_reader :token, :store, :dir
  #debug_output $stdout

  def initialize(token = '231bb1eb320c1e66', dir = 'data')
    @token, @dir = token, dir
    @store = RouteStore.new(File.join(dir, 'msoa-flow-leeds-all.csv'), File.join(dir, 'msoa-leeds-all-with-route.csv'))
  end

  def query
    route_id = 0
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
        csv << [route_id] + route.to_a +
          [fastest['time'], fastest['length'], quietest['time'], quietest['length']]
      end

      File.open(File.join(dir, "#{route_id}-fast.txt"), 'w')  { |file| file.write(fastest['coordinates']) }
      File.open(File.join(dir, "#{route_id}-quiet.txt"), 'w') { |file| file.write(quietest['coordinates']) }
      route_id += 1
    end
  end

  private

  def api_call(route, plan)
    self.class.get('/api/journey.xml', query: {
      key: token,
      plan: plan,
      itinerarypoints: "#{route.orig.long},#{route.orig.lat}|#{route.dest.long},#{route.dest.lat}",
      segments: '0',
    })['markers']['marker']
  end
end
