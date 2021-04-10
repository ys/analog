module Analog
  module Commands
    class PhotosRename < Dry::CLI::Command
      include Analog::Helpers::Rolls

      desc "Rename roll pictures based on information"

      def call_one(t, r, **options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        t << [ r.roll_number + " " + r.dir]
        t << :separator
        files = Analog::PhotosRenamer.new(r, options).call
        files.each do |k, v|
          t << ["#{k} → #{v}"]
        end
        puts t
      end
    end
  end
end
