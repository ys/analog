module Analog
  module Commands
    class Debug < Dry::CLI::Command
      include Analog::Helpers::Rolls
      desc "See rolls debug"

      def call_one(t, r, **options)
        pp r.to_h
      end
    end
  end
end

