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
      assert(info.cache_path.to_s, "/tmp/info/12/x12345.html.xz")
    end

    test "downcase ncode" do
      ncode = "X12345"
      info = Yomou::NovelInfo::PageParser.new(ncode)
      assert(info.cache_path.to_s, "/tmp/info/12/x12345.html.xz")
    end
  end
end
