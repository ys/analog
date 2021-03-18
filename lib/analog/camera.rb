class Analog::Camera
  include ActiveModel::Model
  attr_accessor :id, :model, :brand, :format

  def self.all
    content.map do |k, v|
      new(v.merge(id: k))
    end
  end

  def self.content
    YAML.load_file(File.join(Analog::Config.path, "cameras.yml"))
  end

  def rolls
    Analog::Roll.select { |roll| roll.camera_id == id }
  end

  def to_s
    brand + " " + model
  end
end
