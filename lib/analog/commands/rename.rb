module Analog
  module Commands
    class Rename < Dry::CLI::Command
      desc "Rename roll pictures based on information"
      option :dry_run, type: :boolean

      def call(**options)
        Analog::Roll.each do |r|
          t = Terminal::Table.new
          t.style = { border: :unicode }
          t << [ r.roll_number + " " + r.dir]
          t << :separator
          files = Analog::Renamer.new(r, options).call
          files.each do |k, v|
            t << ["#{k} → #{v}"]
          end
          puts t
        end
      end
    end
  end
end
