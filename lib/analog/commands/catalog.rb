module Analog
  module Commands
    class Catalog < Dry::CLI::Command
      desc "Build symlinks to rolls per camera and per film"

      def call(**options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        t << :separator
        t << ["📷"]
        t << :separator
        Analog::Camera.all.each do |c|
          camera_path = File.join(Analog::Config.path, "cameras", c.to_s)
          FileUtils.mkdir_p(camera_path)
          t << [ c.to_s ]
          c.rolls.each do |r|
            FileUtils.ln_s(r.dir, File.join(camera_path, File.basename(r.dir)))
          end
        end
        t << ["🎞"]
        t << :separator
        Analog::Film.all.each do |c|
          film_path = File.join(Analog::Config.path, "films", c.to_s)
          FileUtils.mkdir_p(film_path)
          t << [c.to_s]
          c.rolls.each do |r|
            FileUtils.ln_s(r.dir, File.join(film_path, File.basename(r.dir)))
          end
        end
        puts t
      end
    end
  end
end
