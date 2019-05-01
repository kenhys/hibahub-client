# frozen_string_literal: true

require 'yomou/helper'
require 'rroonga'
require 'find'

module Yomou
  class Blacklist
    include Yomou::Helper
    YOMOU_BLACKLIST = 'blacklist.yaml'
    def initialize(options={})
      @conf = Yomou::Config.new
      @options = options
      @output = options[:output] || $stdout
    end

    def init
      path = File.join(@conf.directory, 'blacklist.yaml')
      unless File.exist?(path)
        source = File.dirname(__FILE__) + "/../../data/#{YOMOU_BLACKLIST}"
        FileUtils.cp(source, path)
      end
    end

    def import
      base_dir = File.join(@conf.directory, 'narou')
      path = File.join(@conf.directory, 'blacklist.yaml')
      yaml = YAML.load_file(path)
      ncodes = yaml['ncodes']
      99.times.each do |i|
        seq = format("%02d", i)
        database_path = File.join(base_dir, seq, '.narou', 'database.yaml')
        next unless File.exist?(database_path)
        YAML.load_file(database_path).each do |_, entry|
          if entry.key?('tags') and entry['tags'].include?('404')
            ncode = extract_ncode(entry['toc_url'])
            ncodes << ncode unless ncode.empty?
          end
        end
      end
      File.open(path, 'w+') do |file|
        file.puts(YAML.dump('ncodes': ncodes.sort.uniq))
      end
    end

    private

    def extract_ncode(toc_url)
      ncode = ""
      if toc_url =~ /.+\/(n.+)\/$/
        ncode = $1
      end
      ncode
    end
  end
end
