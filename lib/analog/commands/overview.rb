module Analog
  module Commands
    class Overview < Dry::CLI::Command
      desc "See all"

      def call(**options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        Analog::Roll.each do |r|
          t << [ "##{r.roll_number}", r.scanned_at ]
          t << [ "camera", r.camera.to_s ]
          t << [ "film", r.film.to_s ]
          t << [ "dir", r.dir ]
          t << :separator
        end
        puts t
      end
    end
  end
end

