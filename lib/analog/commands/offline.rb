module Analog
  module Commands
    class Offline < Dry::CLI::Command
      include Analog::Helpers::Rolls
      desc "Create an offline HTML contact sheet per folder"

      def call_one(t, r, **options)
        r.add_contact_sheet
      end

      def structur
        {
          index: true,
          2018 => {},
          2019 => {},
          2020 => {},
          2021 => {},
          cameras: {},
          films: {},
        }
      end
    end
  end
end
