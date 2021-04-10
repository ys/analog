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
        reader = MultiExiftool::Reader.new
        reader.filenames = r.files.map { |f| File.join(r.dir, f) }
        results = reader.read
        unless reader.errors.empty?
          $stderr.puts reader.errors
        end
        results.each do |exif|
          t << [exif.make, exif.model, exif.iso, exif.captionabstract]
        end
        puts t
      end
    end
  end
end
