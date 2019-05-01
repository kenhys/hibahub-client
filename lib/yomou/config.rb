require "yaml"

module Yomou

  class Config

    YOMOU_CONFIG = 'yomou.yaml'
    DOT_YOMOU = '.yomou'

    def initialize
      @keys = []
      unless File.exist?(path)
        src = File.dirname(__FILE__) + "/../../examples/#{YOMOU_CONFIG}"
        FileUtils.cp(src, path)
        load
        if ENV['YOMOU_HOME']
          path = File.join(ENV['YOMOU_HOME'], 'db/yomou.db')
          instance_variable_set('@database', path)
        end
        save
      else
        load
      end
    end

    def directory
      directory = File.join(ENV['HOME'], DOT_YOMOU)
      if ENV['YOMOU_HOME']
        directory = ENV['YOMOU_HOME']
      end
      unless Dir.exist?(directory)
        Dir.mkdir(directory)
      end
      directory
    end

    def path
      File.join(directory, YOMOU_CONFIG)
    end

    def narou_novel_directory(category)
      path = File.join(narou_category_directory(category),
                       @narou_novel)
      path
    end

    def narou_category_directory(category)
      path = File.join(directory,
                       'narou',
                       sprintf("%02d", category.to_i))
      path
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
        unless key == 'keys'
          config[key] = instance_variable_get(var.to_s)
        end
      end
      File.open(path, 'w+') do |file|
        file.puts(YAML.dump(config))
      end
    end

    def method_missing(method, *args)
      method_name = method.to_s
      if method_name.end_with?('=')
        property = method_name.sub(/=$/, '')
        @keys << property
        instance_variable_set("@#{property}", *args)
      else
        instance_variable_get("@#{method_name}")
      end
    end
  end
end
