# frozen_string_literal: true

require 'tmpdir'
require_relative '../../lib/yomou/crawler/genrelist'

class GenrelistCrawlerTest < Test::Unit::TestCase
  setup do
  end

  sub_test_case "directory" do
    def test_directory
      sandbox do
        output = StringIO.new
        crawler = Yomou::GenrelistCrawler.new(output: output)
        crawler.download(periods: ['yearly'], genres: ['201'])
        assert_equal(true, File.exist?(crawler.html_path('yearly', '201')))
      end
    end
  end

  private

end
