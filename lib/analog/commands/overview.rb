module Analog
  module Commands
    class Overview < Dry::CLI::Command
      desc "See all"

      argument :year, desc: "See that year only"

      def call(year: "*", **options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        t << %w{id scanned_at camera film folder}
        t << :separator
        rolls = if year == "*"
                  Analog::Roll.all
                else
                  Analog::Roll.select { |r| r.scanned_at.year == year.to_i }
                end
        rolls.each do |r|
          t << [ "#{r.roll_number}", r.scanned_at, (r.camera || r.camera_id), (r.film || r.film_id), File.basename(r.dir) ]
        end
        puts t
      end
    end
  end
end

