module Analog
  module Commands
    class ExifWrite < Dry::CLI::Command
      desc "Write Exif from Roll"

      argument :roll_number, desc: "Roll Number"

      attr_accessor :roll

      def call(roll_number:,**options)
        @roll = Analog::Roll.find(roll_number)
        print_exif
      end

      def print_exif
        t = Terminal::Table.new
        t.style = { border: :unicode }
        t << [ "#{roll.roll_number}", roll.scanned_at]
        t << :separator
        exif.each do |k, v|
          t << [k, v]
        end
        puts t
      end

      def exif
        exif = {}
        exif["make"] = roll.camera.brand
        exif["model"] = roll.camera.model
        exif["iso"] = roll.iso || roll.film.iso
        exif["keywords"] = exif_tags
        exif["captionabstract"] = "#{roll.camera.to_s} - #{roll.film.to_s}"
        exif["description"] = exif["imagedescription"] = exif["captionabstract"]
        exif
      end

      def exif_tags
        tags = roll.tags
        tags << roll.camera.brand
        tags << roll.camera.model
        tags << roll.film.brand
        tags << roll.film.name
        tags << roll.film.iso
        tags += roll.places
        tags
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
