module Analog
  module Commands
    class Offline < Dry::CLI::Command
      include Analog::Helpers::Rolls
      desc "Create an offline HTML contact sheet per folder"

      def call_one(t, r, **options)
        r.add_contact_sheet
      end
    end
  end
end
