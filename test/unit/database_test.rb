require 'tmpdir'
require_relative '../../lib/yomou/database'

class DatabaseTest < Test::Unit::TestCase
  setup do
  end

  sub_test_case "directory" do
    def test_db_file
      Dir.mktmpdir do |dir|
        ENV['YOMOU_HOME'] = File.join(dir, '.yomou')
        database = Yomou::Database.new
        database.init
        path = File.join(ENV['YOMOU_HOME'], 'db/yomou.db')
        assert_equal(true, File.exist?(path))
      end
    end
  end
end
