module Analog
  module Commands
    class Archive < Dry::CLI::Command
      include Analog::Helpers::Rolls

      desc "Rename, exif and make it clean"

      def call_one(t, r, **options)
        Analog::Commands::PhotosRename.new.call_one(t,r, **options)
        Analog::Commands::ExifWrite.new.call_one(t,r,**options)
        Analog::Commands::RollsRename.new.call_one(t,r,**options)
      end
    end
  end
end
