module Analog
  module Helpers
    module Rolls
      def self.included(base)
        base.option :dry_run, type: :boolean
        base.option :all, type: :boolean

        base.argument :roll_number, desc: "Roll Number"

        base.attr_accessor :roll
      end

      def call(roll_number: nil,**options)
        t = Terminal::Table.new
        t.style = { border: :unicode }
        if options[:all]
          Analog::Roll.all.each do |roll|
            call_one(t, roll, **options)
          end
        elsif roll_number.present?
          r = Analog::Roll.find(roll_number)
          if r.nil?
            puts "No roll found with roll number: #{roll_number}"
            return
          end
          call_one(t, r, **options)
        else
          puts "You need to either pass a ROLL_NUMBER or --all"
        end
        puts t
      end
    end
  end
end
