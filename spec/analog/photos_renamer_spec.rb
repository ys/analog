require "spec_helper"

RSpec.describe Analog::PhotosRenamer do

  before do
    @roll = Analog::Roll.new
    @roll.files = %w{photo.jpg photo2.jpg}
    @roll.dir = "/dir"
    @roll.scanned_at = Time.now
    @roll.roll_number = "20x01"
  end

  it "renames the files" do
    expect(FileUtils).to receive(:mv)
      .with("/dir/photo.jpg", "/dir/20x01-#{@roll.scanned_at.strftime('%m%d')}-1.jpg")
    expect(FileUtils).to receive(:mv)
      .with("/dir/photo2.jpg", "/dir/20x01-#{@roll.scanned_at.strftime('%m%d')}-2.jpg")
    described_class.new(@roll, dry_run: false).call
  end

  it "dry runs renames the files" do
    expect(FileUtils).to_not receive(:mv)
      .with("/dir/photo.jpg", "/dir/20x01-#{@roll.scanned_at.strftime('%m%d')}-1.jpg")
    expect(FileUtils).to_not receive(:mv)
      .with("/dir/photo2.jpg", "/dir/20x01-#{@roll.scanned_at.strftime('%m%d')}-2.jpg")
    described_class.new(@roll, dry_run: true).call
  end
end
