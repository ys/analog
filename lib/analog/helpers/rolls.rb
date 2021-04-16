module Analog
  module Helpers
    module Rolls
      def self.included(base)
        base.option :dry_run, type: :boolean
        base.option :all, type: :boolean
        base.option :year, type: :int

        base.argument :roll_number, desc: "Roll Number"

        base.attr_accessor :roll
      end

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
        rolls.each do |roll|
          call_one(t, roll, **options)
        end
        puts t if t.rows.any?
      end
    end
  end
end
