require "spec_helper"

RSpec.describe "Cameras" do
  before do
    @dir = Dir.mktmpdir
    FileUtils.cp(%w{spec/fixtures/cameras.yml}, @dir)
    Analog::Config.path = @dir
  end

  it "works" do
    camera = Analog::Camera.first
    expect(camera.id).to eql "leica-m6"
    expect(camera.brand).to eql "Leica"
    expect(camera.model).to eql "m6"
    expect(camera.format).to eql 135
  end

  after do
    FileUtils.remove_entry @dir
  end
end
