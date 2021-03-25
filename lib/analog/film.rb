class Analog::Film
  extend Enumerable
  include ActiveModel::Model
  attr_accessor :id, :name, :formats, :iso, :color

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

  def rolls
    Analog::Roll.select { |roll| roll.film_id == id }
  end

  def to_s
    name + " " + iso.to_s
  end
end
