require "csv"

module Analog
  module Commands
    class Csv < Dry::CLI::Command
      option :dry_run, type: :boolean
      option :all, type: :boolean
      option :year, type: :int


      desc "CSV it"

      def call(roll_number: nil,**options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        rolls = []
        if options[:all]
          rolls = Analog::Roll.all
        elsif options[:year]
          rolls = Analog::Roll.year(options[:year])
        elsif roll_number.present?
          r = Analog::Roll.find(roll_number)
          if r.nil?
            puts "No roll found with roll number: #{roll_number}"
            return
          end
          rolls = Array(r)
        else
          puts "You need to either pass a ROLL_NUMBER or --all"
        end
        column_names = rolls.first.to_h.keys
        s = ::CSV.generate do |csv|
          csv << column_names
          rolls.each do |x|

            values = x.to_h
            values["places"] = values["places"].join(",")
            values["tags"] = values["tags"].join(",")
            csv << values.values
          end
        end
        File.write('rolls.csv', s)

        puts t if t.rows.any?
      end
    end
  end
end
