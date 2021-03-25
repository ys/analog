module Analog
  class Roll
    extend Enumerable
    include ActiveModel::Model

    YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m.freeze

    attr_accessor :file, :content, :files, :dir, :scanned_at,
      :roll_number,:format, :exported, :lab, :homescan, :tags, :places
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

    def populate
      @content = File.read(file)
      if content =~ YAML_FRONT_MATTER_REGEXP
        @content = Regexp.last_match.post_match
        metadata = YAML.load(Regexp.last_match(1))
        metadata.each {|k, v| send("#{k}=", v) }
      end
      @dir = File.dirname(file)
      @files = Dir.children(dir).select {|f| f.match?(/jp(e)?g$/i) }
    end
  end
end
