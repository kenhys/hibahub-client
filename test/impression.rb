require 'test/unit'
require 'test/unit/rr'
require_relative '../lib/yomou'

class ImpressionTest < Test::Unit::TestCase

  setup do
    ENV["YOMOU_HOME"] = "/tmp"
  end

  sub_test_case "cache_path" do
    expected = "/tmp/impression/12/x12345.yaml.xz"
    data(
      'valid' => ["x12345", expected],
      'unified to downcase?' => ["X12345", expected]
    )
    def test_cache_path?(data)
      ncode, expected = data
      impression = Yomou::Impression::PageParser.new(ncode)
      assert_equal(expected, impression.cache_path.to_s)
    end
  end

  sub_test_case "comment date" do
    data(
    )
  end
end
