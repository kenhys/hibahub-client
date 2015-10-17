require 'test/unit'
require 'test/unit/rr'
require_relative '../lib/yomou'

class NovelInfoTest < Test::Unit::TestCase

  setup do
    ENV["YOMOU_HOME"] = "/tmp"
  end

  sub_test_case "cache_path" do
    test "valid" do
      ncode = "x12345"
      info = Yomou::NovelInfo::PageParser.new(ncode)
      expected = "/tmp/info/12/x12345.html.xz"
      assert_equal(expected, info.cache_path.to_s)
    end

    test "downcase ncode" do
      ncode = "X12345"
      info = Yomou::NovelInfo::PageParser.new(ncode)
      expected = "/tmp/info/12/x12345.html.xz"
      assert_equal(expected, info.cache_path.to_s)
    end
  end

  sub_test_case "url" do
    test "valid" do
      ncode = "x12345"
      info = Yomou::NovelInfo::PageParser.new(ncode)
      expected = "http://ncode.syosetu.com/novelview/infotop/ncode/x12345/"
      assert_equal(expected, info.url)
    end

    test "downcase ncode" do
      ncode = "X12345"
      info = Yomou::NovelInfo::PageParser.new(ncode)
      expected = "http://ncode.syosetu.com/novelview/infotop/ncode/x12345/"
      assert_equal(expected, info.url)
    end
  end
end
