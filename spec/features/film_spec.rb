require "spec_helper"

RSpec.describe "Film" do
  before do
    @dir = Dir.mktmpdir
    FileUtils.cp_r("spec/fixtures/roll-1", @dir)
    FileUtils.cp(%w{spec/fixtures/films.yml}, @dir)
    Analog::Config.path = @dir
  end
  let(:film) { Analog::Film.first }

  it "reads the file" do
    expect(Analog::Film.all.size).to eql(1)
  end

  it "sets the fields" do
    expect(film.id).to eql "portra-400"
    expect(film.name).to eql "Kodak Portra"
    expect(film.formats).to eql [135, 120]
    expect(film.iso).to eql 400
    expect(film.color).to eql true
  end

  it "has a dir for symlinks" do
    expect(film.dir).to eql(File.join(@dir, "films", film.to_s))
  end

  it "doesn't delete the roll" do
    expect do
      film.ensure_dir
    end.to_not change { File.exists? Analog::Roll.first.dir }
  end

  it "ensure dir presence" do
    expect do
      film.ensure_dir
    end.to change { File.exists? film.dir }.from(false).to(true)
  end

  it "links rolls" do
    roll = Analog::Roll.first
    expect(FileUtils).to receive(:ln_s).with(roll.dir, File.join(film.dir, File.basename(roll.dir)))
    film.link_rolls
  end

  after do
    FileUtils.remove_entry @dir
  end
end
