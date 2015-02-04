class GeoJson
  attr_reader :coordinates
  def initialize(*coordinates)
    @coordinates = coordinates
  end

  def to_line_string
    {
      'type' => 'LineString',
      'coordinates' => coordinates.map(&:to_a),
    }
  end
end

