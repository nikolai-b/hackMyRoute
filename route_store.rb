require 'csv'
require './coordinate'

class RouteStore
  attr_reader :in_path, :out_path

  def initialize(in_path = File.join('data', 'msoa-test.csv'),
                 out_path = File.join('data', 'msoa-leeds-with_route.csv'))
    @in_path  = in_path
    @out_path = out_path
  end

  def open
    CSV.foreach(in_path, headers: true, converters: :numeric) do |row|
      yield Coordinate.new(row['lat_origin'], row['lon_origin']), Coordinate.new(row['lat_dest'], row['lon_dest'])
    end
  end

  def save
    csv_out ||= CSV.open(out_path, 'w')
  end
end
