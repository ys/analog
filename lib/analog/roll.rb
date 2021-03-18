module Analog
  class Roll
    YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m.freeze
    include ActiveModel::Model

    attr_accessor :file, :content, :files, :dir, :scanned_at,
      :roll_number,:format, :exported, :lab, :homescan, :tags, :places
    attr_writer :camera, :film

    def self.all
      rolls = `find #{Analog::Config.path} -name roll.md`.split("\n")
      rolls.map { |f| a = new(file: f); a.populate; a }
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
      Analog::Camera.all.detect { |c| c.id == @camera }
    end

    def film
      Analog::Film.all.detect { |c| c.id == @film }
    end

    def populate
      @content = File.read(file)
      if content =~ YAML_FRONT_MATTER_REGEXP
        @content = Regexp.last_match.post_match
        metadata = YAML.load(Regexp.last_match(1))
        metadata.each {|k, v| send("#{k}=", v) }
      end
      @dir = File.dirname(file)
      @files = Dir.children(dir)
    end
  end
end
