module Analog
  class Renamer
    attr_reader :roll, :options

    def initialize(roll, options)
      @roll = roll
      @options = options
    end

    def call
      prefix = "#{roll.scanned_at.strftime('%Y%m%d')}-#{roll.roll_number}"
      files = {}
      roll.files.each_with_index do |f, i|
        ext = File.extname(f)
        next if ext.match? /md|html/
        new_name = "#{prefix}-#{i+1}#{ext.downcase}"
        files[f] = new_name
        unless options[:dry_run]
         #  Fileutils.mv(File.join(roll.dir, f), File.join(roll.dir, new_name))
        end
      end
      files
    end
  end
end
