require "spec_helper"

RSpec.describe Analog::Commands::ExifWrite do
  let(:table) { [] }

  before do
    @roll = Analog::Roll.new
    @roll.files = %w{photo.jpg}
    @roll.dir = "/root/dir"
    @roll.scanned_at = Time.now
    @roll.roll_number = "20x01"
    @roll.camera = "leica-m6"
    @roll.film = "portra-400"
  end

  before do
    allow(@roll).to receive(:exif) { { model: "leica" } }
  end

  it "write exif" do
    exif = instance_double("MultiExiftool::Writer")
    expect(MultiExiftool::Writer).to receive(:new) { exif }
    expect(exif).to receive(:overwrite_original=).with(true)
    expect(exif).to receive(:filenames=).with(%w{/root/dir/photo.jpg})
    expect(exif).to receive(:values=).with({model: "leica"})
    expect(exif).to receive(:write)
    expect(exif).to receive(:errors)
    described_class.new.call_one(table, @roll, dry_run: false)
  end

  it "dry runs does not write exif" do
    exif = instance_double("MultiExiftool::Writer")
    expect(MultiExiftool::Writer).to_not receive(:new) { exif }
    described_class.new.call_one(table, @roll, dry_run: true)
  end
end
