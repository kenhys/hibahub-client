require 'tmpdir'
require_relative '../../lib/yomou/blacklist'

class BlacklistTest < Test::Unit::TestCase
  setup do
  end

  sub_test_case "directory" do
    def test_directory
      Dir.mktmpdir do |dir|
        ENV['YOMOU_HOME'] = File.join(dir, '.yomou')
        path = File.join(ENV['YOMOU_HOME'], 'blacklist.yaml')
        blacklist = Yomou::Blacklist.new
        blacklist.init
        assert_equal(true, File.exist?(path))
      end
    end
  end
end
