Coordinate = Struct.new(:lat, :long) do
  def ==(other)
    self.lat.round(5) == other.lat.round(5) && self.long.round(5) == other.long.round(5)
  end
end

Route = Struct.new(:orig, :dest) do
  def to_a
    [orig.long, orig.lat, dest.long, dest.lat]
  end

  def a_point
    orig = Coordinate.new(0,0)
    dest = orig
  end
end
