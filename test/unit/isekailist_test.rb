# frozen_string_literal: true

require 'tmpdir'
require_relative '../../lib/yomou/crawler/isekailist'

class IsekailistCrawlerTest < Test::Unit::TestCase
  setup do
  end

  sub_test_case "directory" do
    def test_directory
      sandbox do
        output = StringIO.new
        crawler = Yomou::IsekailistCrawler.new(output: output)
        crawler.download(periods: ['yearly'])
        crawler.base_path
        now = Time.now
        paths = []
        Find.find(crawler.base_path) do |fpath|
          paths << fpath if File.file?(fpath)
        end
        expected = []
        ['yearly_1', 'yearly_2', 'yearly_o'].each do |entry|
          expected << File.join(crawler.base_path,
                                entry, now.year.to_s, now.strftime("%Y%m%d.html.xz"))
        end
        assert_equal(expected, paths)
      end
    end
  end
end
