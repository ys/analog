require "spec_helper"

RSpec.describe "Cameras" do
  before do
    @dir = Dir.mktmpdir
    FileUtils.cp_r("spec/fixtures/roll-1", @dir)
    FileUtils.cp(%w{spec/fixtures/cameras.yml}, @dir)
    Analog::Config.path = @dir
  end
  let(:camera) { Analog::Camera.first }

  it "reads the file" do
    expect(Analog::Camera.all.size).to eql(1)
  end

  it "fills the fields" do
    expect(camera.id).to eql "leica-m6"
    expect(camera.brand).to eql "Leica"
    expect(camera.model).to eql "m6"
    expect(camera.format).to eql 135
  end

  it "has a dir for symlinks" do
    expect(camera.dir).to eql(File.join(@dir, "cameras", camera.to_s))
  end

  it "ensure dir presence" do
    expect do
      camera.ensure_dir
    end.to change { File.exists? camera.dir }.from(false).to(true)
  end

  it "links rolls" do
    roll = Analog::Roll.first
    expect(FileUtils).to receive(:ln_s).with(roll.dir, File.join(camera.dir, File.basename(roll.dir)))
    camera.link_rolls
  end

  after do
    FileUtils.remove_entry @dir
  end
end
