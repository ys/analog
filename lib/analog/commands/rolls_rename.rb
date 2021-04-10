module Analog
  module Commands
    class RollsRename < Dry::CLI::Command
      include Analog::Helpers::Rolls

      desc "Rename roll based on information"

      def call_one(t, r, **options)
        new_name = "#{r.file_prefix}-#{r.camera_id}-#{r.film_id}"
        if r.name
          new_name = "#{r.file_prefix}-#{r.name}"
        end
        t << ["#{r.dirname} → #{new_name}"]
        t << :separator
        return if options[:dry_run]
        FileUtils.mv(r.dir, File.join(File.dirname(r.dir), new_name))
      end
    end
  end
end
