require "spec_helper"

RSpec.describe "Roll" do
  before do
    @dir = Dir.mktmpdir
    FileUtils.cp_r("spec/fixtures/roll-1", @dir)
    FileUtils.cp(%w{spec/fixtures/cameras.yml spec/fixtures/films.yml}, @dir)
    Analog::Config.path = @dir
  end

  let(:roll) { Analog::Roll.first }

  it "reads the roll.md" do
    expect(Analog::Roll.all.size).to eql(1)
  end

  it "converts to html" do
    sheet = roll.to_html
    expect(sheet).to include(roll.id)
    expect(sheet).to include(roll.camera.to_s)
    expect(sheet).to include(roll.film.to_s)
  end

  it "creates a contact sheet" do
    sheet_path = File.join(@dir, "roll-1", "roll.html")
    expect do
      roll.add_contact_sheet
    end.to change { File.exist? sheet_path }.to(true)
    sheet = File.read(sheet_path)
    expect(sheet).to eql(roll.to_html)
  end

  after do
    FileUtils.remove_entry @dir
  end
end
