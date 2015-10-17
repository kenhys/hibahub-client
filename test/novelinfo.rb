require 'test/unit'
require 'test/unit/rr'
require_relative '../lib/yomou'

class NovelInfoTest < Test::Unit::TestCase

  setup do
    ENV["YOMOU_HOME"] = "/tmp"
  end

  sub_test_case "cache_path" do
    expected = "/tmp/info/12/x12345.html.xz"
    data(
      'valid' => ["x12345", expected],
      'unified to downcase?' => ["X12345", expected]
    )
    def test_cache_path?(data)
      ncode, expected = data
      info = Yomou::NovelInfo::PageParser.new(ncode)
      assert_equal(expected, info.cache_path.to_s)
    end
  end

  sub_test_case "url" do
    expected = "http://ncode.syosetu.com/novelview/infotop/ncode/x12345/"
    data(
      'valid' => ["x12345", expected],
      'unified to downcase?' => ["X12345", expected]
    )
    def test_url?(data)
      ncode, expected = data
      info = Yomou::NovelInfo::PageParser.new(ncode)
      assert_equal(expected, info.url)
    end
  end
end
