Coordinate = Struct.new(:lat, :long) do
  def ==(other)
    self.lat.round(5) == other.lat.round(5) && self.long.round(5) == other.long.round(5)
  end
end
