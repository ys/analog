module Analog
  module Commands
    class Stats < Dry::CLI::Command
      desc "See some stats"

      argument :year, type: :int, desc: "See that year only"

      def call(year: "*", **options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        rolls = if year == "*"
                  Analog::Roll.all
                else
                  Analog::Roll.year(year)
                end
        t << ["", "# rolls", "# pictures"]
        t << :separator
        rolls.group_by(&:camera_id).map do |camera_id, rolls|
          Struct.new(:camera, :number_of_rolls, :number_of_frames)
                .new(Analog::Camera.find(camera_id), rolls.size, rolls.sum { |r| r.files.size })
        end.sort_by(&:number_of_frames).reverse.each do |c|
          t << [c.camera, c.number_of_rolls, c.number_of_frames]
        end
        t << :separator
        rolls.group_by(&:film_id).map do |film_id, rolls|
          Struct.new(:film, :number_of_rolls, :number_of_frames)
                .new(Analog::Film.find(film_id), rolls.size, rolls.sum { |r| r.files.size })
        end.sort_by(&:number_of_frames).reverse.each do |c|
          t << [c.film, c.number_of_rolls, c.number_of_frames]
        end
        puts t
      end
    end
  end
end

