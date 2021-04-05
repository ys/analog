module Analog
  module Commands
    class RollsRename < Dry::CLI::Command
      desc "Rename roll based on information"
      option :dry_run, type: :boolean

      def call(**options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        Analog::Roll.each do |r|
          dir =  File.basename(r.dir)
          new_name = "#{r.roll_number}-#{r.scanned_at.strftime('%m%d')}-#{r.camera_id}-#{r.film_id}"
          t << ["#{dir} → #{new_name}"]
          t << :separator
        end
        puts t
      end
    end
  end
end
