module Analog
  class ContactSheet
    attr_reader :roll

    def initialize(roll, destination = nil)
      @roll = roll
      @destination = destination || roll.dir
    end

    def generate
      montage = MiniMagick::Tool::Montage.new
      montage.fill("gray")
      montage.background("#fff")
      montage.define("jpeg:size=200x200")
      montage.geometry("200x200+2+2")
      montage.auto_orient
      montage << "#{roll.dir}/*.jpg"
      montage << "#{roll.dir}/#{roll.roll_number}.jpg"
      montage.call
    end
  end
end
