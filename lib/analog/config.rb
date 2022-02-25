module Analog
  class Config

    def self.load
      YAML.load(File.read("#{ENV["HOME"]}/.analog")).each do |k, v|
        send("#{k}=", v)
      end
    end

    def self.offline_path=(path)
      @offline_path = path
    end

    def self.offline_path
      @offline_path
    end

    def self.path=(path)
      @path = path
    end

    def self.path
      @path
    end
  end
end
