module Analog
  module Commands
    class Stats < Dry::CLI::Command
      desc "See some stats"

      argument :year, desc: "See that year only"

      def call(year: "*", **options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        rolls = if year == "*"
                  Analog::Roll.all
                else
                  Analog::Roll.select { |r| r.scanned_at.year == year.to_i }
                end
        t << ["", "# rolls", "# pictures"]
        t << :separator
        rolls.group_by(&:camera_id).each do |camera_id, rolls|
          t << [ Analog::Camera.find(camera_id), rolls.size, rolls.sum { |r| r.files.size }]
        end
        t << :separator
        rolls.group_by(&:film_id).each do |film_id, rolls|
          t << [ Analog::Film.find(film_id), rolls.size, rolls.sum { |r| r.files.size }]
        end
        puts t
      end
    end
  end
end

