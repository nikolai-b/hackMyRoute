require 'fileutils'
require_relative './spec_helper'
require_relative '../app/cycle_street'

RSpec.describe CycleStreet do
  let(:out_file) { File.join('spec', 'data', 'msoa-test-with_route.csv') }
  let(:in_file)  { File.join('spec', 'data', 'msoa-test.csv') }
  subject        { described_class.new(ENV['CYCLESTREET'], in_file, out_file) }

  it 'query should create a new file with data' do
    FileUtils.rm(out_file) if File.file?(out_file)
    FileUtils.touch(out_file)
    expect{ subject.query }.to change{File.size(out_file)}.by_at_least(300)
    FileUtils.rm(out_file)
  end
end
