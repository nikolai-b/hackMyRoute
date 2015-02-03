require 'csv'
require_relative './coordinate'

class RouteStore
  attr_reader :in_file, :out_file

  def initialize(in_file, out_file)
    @in_file  = in_file
    @out_file = out_file
  end

  def open
    CSV.foreach(in_file, headers: true, converters: :numeric) do |row|
      yield Route.new(
        Coordinate.new(row['lon_origin'], row['lat_origin']),
        Coordinate.new(row['lon_dest'], row['lat_dest'])
      )
    end
  end

  def save
    wipe_file unless @wiped_file
    CSV.open(out_file, 'a') do |csv|
      yield csv
    end
  end

  def wipe_file
    CSV.open(out_file, "w") {}
    @wiped_file = true
  end
end
