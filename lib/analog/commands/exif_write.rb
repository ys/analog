module Analog
  module Commands
    class ExifWrite < Dry::CLI::Command
      include Analog::Helpers::Rolls
      desc "Write Exif from Roll"

      def call_one(t, r,**options)
        print_exif(t, r)
        return if options[:dry_run]
        apply_exif(r)
      end

      def print_exif(t, r)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        t << [ "#{r.roll_number}", r.scanned_at]
        t << :separator
        r.exif.each do |k, v|
          t << [k, v]
        end
        puts t
      end

      def apply_exif(r)
        r.files.each do |f|
          photo = MiniExiftool.new(File.join(r.dir, f))
          r.exif.each do |k, v|
            photo[k] = v
          end
          photo.save
        end
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
