module Analog
  module Commands
    class ExifWrite < Dry::CLI::Command
      desc "Write Exif from Roll"

      argument :roll_number, desc: "Roll Number"

      def call(roll_number:,**options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        r = Analog::Roll.find(roll_number)

        t << [ "#{r.roll_number}", r.scanned_at]
        t << :separator
        write(r).each do |k, v|
          t << [k, v]
        end
        puts t
      end

      def write(roll)
        exif = {}
        exif["make"] = roll.camera.brand
        exif["model"] = roll.camera.model
        exif["iso"] = roll.iso || roll.film.iso
        exif["keywords"] = (roll.tags|| []) << roll.camera.brand << roll.camera.model << roll.film.brand << roll.film.name << roll.film.iso
        exif["captionabstract"] = "#{roll.camera.to_s} - #{roll.film.to_s}"
        exif["description"] = exif["imagedescription"] = exif["captionabstract"]
        exif
      end

      def possible_keys
        %w{
          focallength
          lensinfo
          lensmake
          lensmodel
          lens
        }
      end
    end
  end
end
