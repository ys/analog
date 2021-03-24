require "spec_helper"

RSpec.describe Analog::Renamer do

  before do
    @roll = Analog::Roll.new
    @roll.files = %w{photo.jpg photo2.jpg}
    @roll.dir = "/dir"
    @roll.scanned_at = Time.now
    @roll.roll_number = "20x01"
  end

  it "renames the files" do
    expect(FileUtils).to receive(:mv)
      .with("/dir/photo.jpg", "/dir/#{@roll.scanned_at.strftime('%Y%m%d')}-20x01-1.jpg")
    expect(FileUtils).to receive(:mv)
      .with("/dir/photo2.jpg", "/dir/#{@roll.scanned_at.strftime('%Y%m%d')}-20x01-2.jpg")
    Analog::Renamer.new(@roll, dry_run: false).call
  end

  it "dry runs renames the files" do
    expect(FileUtils).to_not receive(:mv)
      .with("/dir/photo.jpg", "/dir/#{@roll.scanned_at.strftime('%Y%m%d')}-20x01-1.jpg")
    expect(FileUtils).to_not receive(:mv)
      .with("/dir/photo2.jpg", "/dir/#{@roll.scanned_at.strftime('%Y%m%d')}-20x01-2.jpg")
    Analog::Renamer.new(@roll, dry_run: true).call
  end
end
