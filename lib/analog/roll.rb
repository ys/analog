module Analog
  class Roll
    extend Enumerable
    include ActiveModel::Model

    YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m.freeze

    attr_accessor :file, :content, :files, :dir, :scanned_at,
      :roll_number,:format, :exported, :lab, :homescan, :tags, :places,
      :iso, :description, :name
    attr_writer :camera, :film

    def self.each
      all.each do |r|
        yield r
      end
    end

    def self.all
      rolls = `find #{Analog::Config.path} -name roll.md`.split("\n")
      rolls.map { |f| a = new(file: f); a.populate; a }
    end

    def self.find(id)
      detect { |r| r.id == id }
    end

    def id
      @roll_number
    end

    def to_html
      Liquid::Template.parse(File.read("./tmpl/roll.html.liquid"))
        .render(to_h)
    end

    def add_contact_sheet
      File.open(File.join(dir, "roll.html"), "w") do |f|
        f.write(to_html)
      end
    end

    def partitioned_files
      partitioning(files.collect { |file| asset(file) }, 3).collect { |row| row.collect { |asset| [asset] } }
    end

    def partitioning(items = [], buckets = 1, property = 'ratio')
      if buckets <= 0 || items.empty?
        []
      elsif buckets == 1
        [items]
      elsif buckets >= items.count
        items.collect { |item| [item] }
      else
        dividers = []
        sums = [0]
        conditions = []
        (1..items.count).each do |i|
          sums[i] = sums[i - 1] + items[i - 1][property]
        end
        (1..items.count).each do |i|
          conditions[i] = []
          conditions[i][1] = sums[i]
        end
        (1..buckets).each do |i|
          conditions[1][i] = items[0][property]
        end
        (2..items.count).each do |i|
          (2..buckets).each do |j|
            conditions[i][j] = nil
            (1...i).each do |k|
              l = [conditions[k][j - 1], sums[i] - sums[k]].max
              dividers[i] = dividers[i] || []
              if (conditions[i][j].nil? || conditions[i][j] >= l)
                conditions[i][j] = l
                dividers[i][j] = k
              end
            end
          end
        end
        partitions = []
        while buckets > 1
          if dividers[items.count]
            divider = dividers[items.count][buckets]
            part = items.slice!(divider, items.count)
            partitions.unshift(part)
          end
          buckets = buckets - 1
        end
        partitions.unshift(items)
        partitions
      end
    end
    def asset(file)
      width, height = Dimensions.dimensions(File.join(dir, file))
      OpenStruct.new(file: file, width: width, height: height, ratio: width.to_f / height.to_f)
    end

    def to_h
      {
        "roll_number" => roll_number,
        "camera" => camera.to_s,
        "film" => film.to_s,
        "scanned_at" => scanned_at,
        "content" => content,
        "files" => files,
        "dir" => dir,
      }
    end

    def camera
      Analog::Camera.find(camera_id)
    end

    def camera_id
      @camera
    end

    def film
      Analog::Film.find(film_id)
    end

    def film_id
      @film
    end

    def dirname
      File.basename(dir)
    end

    def file_prefix
      "#{roll_number}-#{scanned_at.strftime('%m%d')}"
    end

    def populate
      @content = File.read(file)
      if content =~ YAML_FRONT_MATTER_REGEXP
        @content = Regexp.last_match.post_match
        metadata = YAML.load(Regexp.last_match(1))
        metadata.each {|k, v| send("#{k}=", v) }
      end
      @places ||= []
      @tags ||= []
      @dir = File.dirname(file)
      @files = Dir.children(dir).select {|f| f.match?(/jp(e)?g$/i) }
    end
  end
end
