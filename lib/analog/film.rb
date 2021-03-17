class Film
  include ActiveModel::Model
  attr_accessor :id, :name, :formats, :iso

  def self.all
    content.map do |k, v|
      new(v.merge(id: k))
    end
  end

  def self.content
    YAML.load_file(File.join(ENV["ROLLS_BASE_PATH"], "films.yml"))
  end

  def rolls
    Roll.all.select { |roll| roll.metadata["film"] == id }
  end

  def to_s
    name + " " + iso.to_s
  end
end
