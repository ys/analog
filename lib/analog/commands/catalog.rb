module Analog
  module Commands
    class Catalog < Dry::CLI::Command
      desc "Build symlinks to rolls per camera and per film"

      def call(**options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        [Analog::Camera, Analog::Film].each_with_index do |klass, i|
          t << :separator if i > 0
          t << [klass.to_s.split("::")[1]]
          t << :separator
          klass.each do |o|
            o.ensure_dir
            t << [ o.to_s ]
            o.link_rolls
          end
        end
        puts t
      end
    end
  end
end
