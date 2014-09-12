require "yaml"

module Yomou

  class Config

    YOMOU_CONFIG = "yomou.yaml"
    DOT_YOMOU = ".yomou"

    def initialize
      unless File.exist?(path)
        src = File.dirname(__FILE__) + "/../../examples/#{YOMOU_CONFIG}"
        FileUtils.cp(src, path)
      end
      load
    end

    def directory
      directory = File.join(ENV['HOME'], DOT_YOMOU)
      unless Dir.exist?(directory)
        Dir.mkdir(directory)
      end
      directory
    end

    def path
      File.join(directory, YOMOU_CONFIG)
    end

    def load
      YAML.load_file(path).each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def save
      config = {}
      instance_variables.each do |symbol|
        key = symbol.to_s.delete("@")
        config[key] = instance_variable_get("@#{key}")
      end
      File.open(path, "w+") do |file|
        file.puts(YAML.dump(config))
      end
    end
  end
end
