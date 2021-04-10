module Analog
  module Commands
    class ExifRead < Dry::CLI::Command
      desc "Read Exif from Roll"

      argument :roll_number, desc: "Roll Number"

      def call(roll_number:,**options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        r = Analog::Roll.find(roll_number)

        t << [ "#{r.roll_number}", r.scanned_at]
        t << :separator
        r.files.each do |f|
          exif = MiniExiftool.new(File.join(r.dir, f))
          t << [exif.make, exif.model, exif.iso, exif.captionabstract]
        end
        puts t
      end
    end
  end
end
