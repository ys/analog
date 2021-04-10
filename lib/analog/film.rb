class Analog::Film
  extend Enumerable
  include ActiveModel::Model
  attr_accessor :id, :brand, :name, :formats, :iso, :color

  def self.each
    all.each do |r|
      yield r
    end
  end

  def self.all
    content.map do |k, v|
      new(v.merge(id: k))
    end
  end

  def self.content
    YAML.load_file(File.join(Analog::Config.path, "films.yml"))
  end

  def self.find(id)
    detect { |r| r.id == id }
  end

  def rolls
    Analog::Roll.select { |roll| roll.film_id == id }
  end

  def to_s
    brand + " " + name + " " + iso.to_s
  end

  def dir
    File.join(Analog::Config.path, "films", to_s)
  end

  def ensure_dir
    FileUtils.rm_rf(dir)
    FileUtils.mkdir_p(dir)
  end

  def link_rolls
    rolls.each do |r|
      FileUtils.ln_s(r.dir, File.join(dir, File.basename(r.dir)))
    end
  end
end
