module Analog
  module Commands
    class RollsRename < Dry::CLI::Command
      desc "Rename roll based on information"
      option :dry_run, type: :boolean

      def call(**options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        Analog::Roll.each do |r|
          new_name = "#{r.file_prefix}-#{r.camera_id}-#{r.film_id}"
          if r.name
            new_name = "#{r.file_prefix}-#{r.name}"
          end
          t << ["#{r.dirname} → #{new_name}"]
          t << :separator
        end
        puts t
      end
    end
  end
end
