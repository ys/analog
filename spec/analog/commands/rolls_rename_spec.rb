require "spec_helper"

RSpec.describe Analog::Commands::RollsRename do
  let(:table) { [] }

  before do
    @roll = Analog::Roll.new
    @roll.files = %w{photo.jpg photo2.jpg}
    @roll.dir = "/root/dir"
    @roll.scanned_at = Time.now
    @roll.roll_number = "20x01"
    @roll.camera = "leica-m6"
    @roll.film = "portra-400"
  end

  it "renames the dir" do
    expect(FileUtils).to receive(:mv)
      .with("/root/dir", "/root/20x01-#{@roll.scanned_at.strftime('%m%d')}-leica-m6-portra-400")
    described_class.new.call_one(table, @roll, dry_run: false)
  end

  it "dry runs renames the files" do
    expect(FileUtils).to_not receive(:mv)
      .with("/root/dir", "/root/20x01-#{@roll.scanned_at.strftime('%m%d')}-leica-m6-portra-400")
    described_class.new.call_one(table, @roll, dry_run: true)
  end
end
