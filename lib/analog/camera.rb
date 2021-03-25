class Analog::Camera
  extend Enumerable
  include ActiveModel::Model
  attr_accessor :id, :model, :brand, :format

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
    YAML.load_file(File.join(Analog::Config.path, "cameras.yml"))
  end

  def self.find(id)
    detect { |r| r.id == id }
  end

  def rolls
    Analog::Roll.select { |roll| roll.camera_id == id }
  end

  def to_s
    brand + " " + model
  end

  def dir
    File.join(Analog::Config.path, "cameras", to_s)
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
