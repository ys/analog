module Analog
  module Commands
    class Offline < Dry::CLI::Command
      include Analog::Helpers::Rolls
      desc "Create an offline HTML contact sheet per folder"

      def call_one(t, r, **options)
        CLI::UI::StdoutRouter.enable
        spin_group = CLI::UI::SpinGroup.new
        spin_group.add("Generating Contact sheet for #{r.roll_number}") do
          Analog::ContactSheet.new(r, destination).generate
        end
        spin_group.wait
      end

      def destination
        Analog::Config.offline_path || roll.dir
      end
    end
  end
end
