module Analog
  module Commands
    class Html < Dry::CLI::Command
      desc "Add a contact sheet per roll"

      def call(**options)
        Analog::Roll.all.each do |r|
          r.add_contact_sheet
        end
      end
    end
  end
end
