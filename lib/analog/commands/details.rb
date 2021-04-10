module Analog
  module Commands
    class Details < Dry::CLI::Command
      include Analog::Helpers::Rolls
      desc "See Roll details"
      def call_one(t, r,**options)
        t = Terminal::Table.new
        t.style = { border: :unicode }

        t << [ "#{r.roll_number}", r.scanned_at]
        t << :separator
        t << [ "camera", (r.camera || r.camera_id)]
        t << [ "film", (r.film || r.film_id)]
        t << [ "folder", File.basename(r.dir) ]
        t << [ "size", "#{r.files.size} pictures" ]
        puts t
      end
    end
  end
end

