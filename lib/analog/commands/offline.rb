module Analog
  module Commands
    class Offline < Dry::CLI::Command
      desc "Create an offline HTML contact sheet per folder"

      def call(**options)
        Analog::Roll.each do |r|
          r.add_contact_sheet
        end
      end
    end
  end
end
