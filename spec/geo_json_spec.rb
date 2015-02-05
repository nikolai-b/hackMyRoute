require_relative './spec_helper'
require_relative '../app/geo_json'
require_relative '../app/coordinate'

RSpec.describe GeoJson do
  it 'can output geo json' do
    start = Coordinate.new(10.1, 20.2)
    finish = Coordinate.new(12.1, 20.3)
    subject = described_class.new(start, finish)

    geo_json = {
      'type' => 'LineString',
      'coordinates' => [[10.1, 20.2], [12.1, 20.3]],
    }

    expect(subject.to_line_string).to eq(geo_json)
  end
end

RSpec.describe GeoJsonFile do
  it 'can read coordinates from a file' do
    subject = GeoJsonFile.new('./spec/data/n-quiet.txt')
    coordinates = subject.read_coordinates
    expect(coordinates.first).to eq(Coordinate.new(-1.400514,53.929142))
    expect(coordinates.last).to eq(Coordinate.new(-1.400463,53.928829))
  end
end
