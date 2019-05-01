# frozen_string_literal: true

require 'tmpdir'
require_relative '../../lib/yomou/config'

class ConfigTest < Test::Unit::TestCase
  setup do
  end

  sub_test_case "directory" do
    def test_directory
      Dir.mktmpdir do |dir|
        ENV['YOMOU_HOME'] = File.join(dir, '.yomou')
        config = Yomou::Config.new
        expected = ENV['YOMOU_HOME']
        assert_equal(expected, config.directory)
      end
    end

    def test_path
      Dir.mktmpdir do |dir|
        ENV['YOMOU_HOME'] = File.join(dir, '.yomou')
        config = Yomou::Config.new
        expected = File.join(ENV['YOMOU_HOME'], 'yomou.yaml')
        assert_equal(expected, config.path)
      end
    end
  end
end
