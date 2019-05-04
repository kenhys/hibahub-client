# frozen_string_literal: true

require "yomou/helper"
require "yomou/config"
require "yomou/crawler/base"

module Yomou
  class GenrelistCrawler
    include Yomou::Helper
    GENRELIST_URL = 'https://yomou.syosetu.com/rank/genrelist/type'
    def initialize(options={})
      @options = options
      @output = options[:output] || $stdout
      @conf = Yomou::Config.new
    end

    def download(options={})
      periods = options[:periods] || all_periods
      genres = options[:genres] || all_genres
      periods.each do |period|
        genres.each do |genre|
          period_genre = format("%<period>s_%<genre>s",
                                period: period, genre: genre)
          url = format("%<base>s/%<period_genre>s",
                       base: GENRELIST_URL, period_genre: period_genre)
          yyyymmdd = Time.now.strftime("%Y%m%d")
          path = pathname_expanded([@conf.directory,
                                    "genrelist",
                                    genre,
                                    period,
                                    "#{yyyymmdd}.html.xz"])
          @output.puts("download #{url}")
          save_as(url, path)
          @output.puts("save #{path}")
        end
      end
    end

    private

    def all_periods
      ['daily', 'weekly', 'monthly', 'quarter', 'yearly']
    end

    def all_genres
      [
        '101',
        '102',
        '201',
        '202',
        '301',
        '302',
        '303',
        '304',
        '305',
        '306',
        '307',
        '401',
        '402',
        '403',
        '404',
        '9901',
        '9902',
        '9903',
        '9999'
      ]
    end

  end
end
  
