require "spec_helper"

RSpec.describe "Film" do
  before do
    @dir = Dir.mktmpdir
    FileUtils.cp(%w{spec/fixtures/films.yml}, @dir)
    Analog::Config.path = @dir
  end

  it "works" do
    film = Analog::Film.first
    expect(film.id).to eql "portra-400"
    expect(film.name).to eql "Kodak Portra"
    expect(film.formats).to eql [135, 120]
    expect(film.iso).to eql 400
    expect(film.color).to eql true
  end

  after do
    FileUtils.remove_entry @dir
  end
end
