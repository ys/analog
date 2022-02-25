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
          add_contact_sheet(r)
        end
        spin_group.wait
      end

      def destination
        Analog::Config.offline_path || roll.dir
      end

      def add_contact_sheet(roll)
        File.open(File.join(destination, "#{roll.roll_number}.html"), "w") do |f|
          html = Liquid::Template.parse(File.read("./tmpl/roll.html.liquid")).render(roll.to_h)
          f.write(html)
        end
      end

      def structur
        {
          index: true,
          2018 => {},
          2019 => {},
          2020 => {},
          2021 => {},
          2022 => {},
          cameras: {},
          films: {},
        }
      end
    end
  end
end
