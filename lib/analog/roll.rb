class Roll
  YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m.freeze
  include ActiveModel::Model

  attr_accessor :file, :content, :files, :dir,
    :roll_number,:format, :exported, :lab, :homescan, :tags, :places
  attr_writer :camera, :film, :scanned_at

  def self.all
    rolls = `find #{ENV["ROLLS_BASE_PATH"]} -name roll.md`.split("\n")
    rolls.map { |f| a = new(file: f); a.populate; a }
  end

  def camera
    Camera.all.detect { |c| c.id == @camera }
  end

  def film
    Film.all.detect { |c| c.id == @film }
  end

  def scanned_at
    @scanned_at
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
