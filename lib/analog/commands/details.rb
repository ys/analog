module Analog
  module Commands
    class Details < Dry::CLI::Command
      desc "See Roll details"
      argument :roll_number, desc: "Roll Number"
      def call(roll_number:,**options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        r = Analog::Roll.find(roll_number)

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

