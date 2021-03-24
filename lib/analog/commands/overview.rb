module Analog
  module Commands
    class Overview < Dry::CLI::Command
      desc "See all"

      def call(**options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        Analog::Roll.each do |r|
          t << [ "#{r.roll_number}", r.scanned_at ]
          t << [ "camera", r.camera || r.camera_id ]
          t << [ "film", r.film || r.film_id ]
          t << [ "dir", r.dir ]
          t << [ "new_dir", "#{r.roll_number}-#{r.camera_id}" ]
          t << :separator
        end
        puts t
      end
    end
  end
end

