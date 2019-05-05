# frozen_string_literal: true

require 'tmpdir'
require_relative '../../lib/yomou/crawler/nopoint'

class NopointCrawlerTest < Test::Unit::TestCase
  setup do
  end

  sub_test_case "directory" do
    def test_directory
      sandbox do
        output = StringIO.new
        crawler = Yomou::NopointCrawler.new(output: output)
        crawler.download(max_page: 1)
      end
    end
  end

  private

end
