# coding: utf-8
require 'yomou/helper'
require 'rroonga'

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
  end
end
