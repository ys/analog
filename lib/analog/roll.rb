module Analog
  class Roll
    extend Enumerable
    include ActiveModel::Model

    YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m.freeze

    attr_accessor :file, :content, :files, :dir, :scanned_at, :shot_at,
      :roll_number,:format, :exported, :lab, :homescan, :tags, :places,
      :iso, :description, :name, :dev_id
    attr_writer :camera, :film

    def self.each
      all.each do |r|
        yield r
      end
    end

    def self.all
      rolls = Dir.glob("#{Analog::Config.path}/**/*.md")
      rolls.map { |f| a = new(file: f); a.populate; a }
    end

    def self.year(year)
      select do |r|
        begin
          r.date.year == year.to_i
        rescue StandardError
          puts r.dir
        end
      end
    end

    def self.find(id)
      detect { |r| r.id == id }
    end

    def id
      @roll_number
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
        "shot_at" => shot_at,
        "scanned_at" => scanned_at,
        "content" => content,
        "tags" => tags,
        "places" => places,
        "name" => name,
        "iso" => iso || film.iso,
        "directory" => dir,
        "files" => files,
      }
    end

    def camera
      Analog::Camera.find(camera_id) || raise("Camera not found for #{camera_id}")
    end

    def camera_id
      @camera
    end

    def film
      Analog::Film.find(film_id) || raise("Film not found for #{film_id}")
    end

    def film_id
      @film
    end

    def dirname
      File.basename(dir)
    end

    def date
      shot_at || scanned_at
    end

    def file_prefix
      "#{roll_number}-#{date.strftime('%m%d')}"
    end

    def exif
      @exif ||= {}.tap do |exif|
        exif["make"] = camera.brand
        exif["model"] = camera.model
        exif["iso"] = iso || film.iso
        exif["keywords"] = exif_tags
        exif["captionabstract"] = "#{camera.to_s} - #{film.to_s}"
        exif["description"] = exif["imagedescription"] = exif["captionabstract"]
        exif["DateTimeOriginal"] = date.strftime("%F %T")
        exif["FileCreateDate"] = date.strftime("%F %T")
        exif["ModifyDate"] = date.strftime("%F %T")
        exif["CreateDate"] = date.strftime("%F %T")
      end
    end

    def exif_tags
      self.tags.dup.tap do |tags|
        tags << roll_number
        tags << camera.to_s
        tags << film.name_with_brand
        tags += Array(places)
      end
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
      @files = Dir.children(dir).select {|f| f.match?(/jp(e)?g$/i) }.sort
    end
  end
end
