require "spec_helper"

RSpec.describe "Roll" do
  before do
    @dir = Dir.mktmpdir
    FileUtils.cp_r("spec/fixtures/roll-1", @dir)
    FileUtils.cp(%w{spec/fixtures/cameras.yml spec/fixtures/films.yml}, @dir)
    Analog::Config.path = @dir
  end

  it "works" do
    expect(Analog::Roll.all.size).to eql(1)
    expect(Analog::Film.all.size).to eql(1)
    expect(Analog::Camera.all.size).to eql(1)
  end

  after do
    FileUtils.remove_entry @dir
  end
end
