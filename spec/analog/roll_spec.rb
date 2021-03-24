require "spec_helper"
require "tempfile"

RSpec.describe Analog::Roll do
  after do
    tmproll.unlink
  end
  let(:tmproll) do
    r = Tempfile.new("roll")
    r.write(%Q{---
camera: leica-m6
film: ilford-hp5
format: 135
scanned_at: 2020-12-29
exported: true
lab: mori-film
roll_number: 20x24
---
    })
    r.close
    r
  end
  let(:roll) { Analog::Roll.new(file: tmproll.path)}
  let(:camera) { Analog::Camera.new(id: "leica-m6") }
  let(:film) { Analog::Film.new(id: "ilford-hp5") }

  it "populates from file" do
    roll.populate
    expect(roll.camera_id).to eql("leica-m6")
    expect(roll.film_id).to eql("ilford-hp5")
    expect(roll.format).to eql(135)
    expect(roll.exported).to eql(true)
    expect(roll.scanned_at).to eql(Date.parse("2020-12-29"))
    expect(roll.lab).to eql("mori-film")
    expect(roll.roll_number).to eql("20x24")
  end

  it "find the camera and film based on id" do
    roll.populate
    expect(Analog::Camera).to receive(:all).and_return([camera])
    expect(Analog::Film).to receive(:all).and_return([film])
    expect(roll.camera).to eql(camera)
    expect(roll.film).to eql(film)
  end
end
