# frozen_string_literal: true

require "yomou/config"
require "yomou/helper"
require "yomou/crawler/base"

module Yomou
  class AvgranklistCrawler < BaseCrawler
    include Yomou::Helper

    AVGRANKLIST_URL = "https://yomou.syosetu.com/userlist/avgranklist/"
    AVGRANKLIST_PER_PAGE = 20

    def initialize(options={})
      @options = options
      @output = options[:output] || $stdout
      @conf = Yomou::Config.new
    end

    def download(options)
      @min_page = options[:min_page] || 1
      @max_page = options[:max_page] || 9999

      page = @min_page

      total = @max_page - @min_page + 1
      loop do
        next if page < @min_page
        break if page > @max_page
        path = avgranklist_path(page)
        url = avgranklist_url(page)
        @output.puts("download #{url}")
        save_as(url, path)
        @output.puts("save #{path}")
        page += 1
      end
    end

    def avgranklist_url(page)
      format("%<url>s?p=%<page>d", url: AVGRANKLIST_URL, page: page)
    end

    def avgranklist_path(page)
      pathname_expanded([@conf.directory,
                         "avgranklist",
                         "avgranklist_#{page}.html.xz"])
    end
  end
end
