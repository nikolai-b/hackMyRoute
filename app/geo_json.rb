require_relative './coordinate'
require 'json'

class GeoJson
  attr_reader :file
  def initialize(file)
    @file = file
  end

  def convert
    new_file_contents = to_line_string.to_json
    File.open(file, 'w') do |file|
      file << new_file_contents
    end
  end

  def coordinates
    @coordinates ||= File.read(file).split(' ').map do |str_coordinate|
      Coordinate.new(*str_coordinate.split(',').map(&:to_f))
    end
  end

  def to_line_string
    {
      'type' => 'LineString',
      'coordinates' => coordinates.map(&:to_a),
    }
  end
end
