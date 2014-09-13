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
      @keys = []
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

    def load(arg = nil)
      YAML.load_file(path).each do |key, value|
        @keys << key
        instance_variable_set("@#{key}", value)
      end
    end

    def save
      config = {}
      instance_variables.each do |var|
        key = var.to_s.sub(/^@/, '')
        unless key == "keys"
          config[key] = instance_variable_get(var.to_s)
        end
      end
      File.open(path, "w+") do |file|
        file.puts(YAML.dump(config))
      end
    end

    def method_missing(method, *args)
      method_name = method.to_s
      if method_name.end_with?("=")
        property = method_name.sub(/=$/, '')
        @keys << property
        instance_variable_set("@#{property}", *args)
      else
        instance_variable_get("@#{method_name}")
      end
    end
  end
end