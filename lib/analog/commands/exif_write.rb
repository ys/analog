module Analog
  module Commands
    class ExifWrite < Dry::CLI::Command
      include Analog::Helpers::Rolls
      desc "Write Exif from Roll"

      def call_one(t, r,**options)
        if options[:dry_run]
          print_exif(t, r)
        else
          apply_exif(r)
          print_exif(t, r)
        end
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
        CLI::UI::StdoutRouter.enable
        spin_group = CLI::UI::SpinGroup.new
        spin_group.add(r.roll_number) do
          writer = MultiExiftool::Writer.new
          writer.filenames = r.files.map { |f| File.join(r.dir, f) }
          writer.values = r.exif
          unless writer.write
            puts writer.errors
          end
        end
        spin_group.wait
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
