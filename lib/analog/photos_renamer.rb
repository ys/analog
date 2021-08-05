module Analog
  class PhotosRenamer
    attr_reader :roll, :options

    def initialize(roll, options)
      @roll = roll
      @options = options
    end

    def call
      files = {}
      roll.files.each_with_index do |f, i|
        ext = File.extname(f)
        next if ext.match?(/md|html/)
        num = (i+1).to_s.rjust(2, "0")
        new_name = "#{roll.file_prefix}-#{num}#{ext.downcase}"
        files[f] = new_name
        next if options[:dry_run]
        next if f == new_name
        FileUtils.mv(File.join(roll.dir, f), File.join(roll.dir, new_name))
      end
      files
    end
  end
end
