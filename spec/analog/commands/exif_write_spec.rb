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
    exif = instance_double("MiniExiftool")
    expect(MiniExiftool).to receive(:new).with("/root/dir/photo.jpg") { exif }
    expect(exif).to receive(:[]=).with(:model, "leica")
    expect(exif).to receive(:save)
    described_class.new.call_one(table, @roll, dry_run: false)
  end

  it "dry runs does not write exif" do
    exif = instance_double("MiniExiftool")
    expect(MiniExiftool).to_not receive(:new)
    expect(exif).to_not receive(:save)
    described_class.new.call_one(table, @roll, dry_run: true)
  end
end
