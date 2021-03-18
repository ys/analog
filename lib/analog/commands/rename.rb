module Analog
  module Commands
    class Rename < Dry::CLI::Command
      desc "Rename roll pictures based on information"
      option :dry_run, type: :boolean

      def call(**options)
        Analog::Roll.all.each do |r|
          t = Terminal::Table.new
          t.style = { border: :unicode }
          t << [ r.roll_number + " " + r.dir]
          t << :separator
          r.files.each_with_index do |f, i|
            ext = File.extname(f)
            next if ext.match? /md|html/
            new_name = "#{r.scanned_at.strftime('%Y%m%d')}-#{r.roll_number}-#{i+1}#{ext.downcase}"
            unless options[:dry_run]
              Fileutils.mv(File.join(dir, f), File.join(dir, new_name))
            end
            t << ["#{f} → #{new_name}"]
          end
          puts t
        end
      end
    end
  end
end
