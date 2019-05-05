# frozen_string_literal: true

require "yomou/helper"
require "yomou/config"
require "yomou/crawler/base"

module Yomou
  class IsekailistCrawler
    include Yomou::Helper
    GENRELIST_URL = 'https://yomou.syosetu.com/rank/isekailist/type'
    def initialize(options={})
      @options = options
      @output = options[:output] || $stdout
      @conf = Yomou::Config.new
    end

    def download(options={})
      periods = options[:periods] || all_periods
      periods.each do |period|
        ['1', '2', 'o'].each do |genre|
          period_genre = format("%<period>s_%<genre>s",
                                period: period, genre: genre)
          url = format("%<base>s/%<period_genre>s",
                       base: GENRELIST_URL, period_genre: period_genre)
          @output.puts("download #{url}")
          path = html_path(period, genre)
          save_as(url, path)
          @output.puts("save #{path}")
        end
      end
    end

    def base_path
      pathname_expanded([@conf.directory, "isekailist"])
    end

    def html_path(period, genre, yyyymmdd=nil)
      now = Time.now
      yyyymmdd = now.strftime("%Y%m%d") unless yyyymmdd
      path_to_period = format("%<period>s_%<genre>s",
                              period: period, genre: genre)
      pathname_expanded([base_path,
                         path_to_period,
                         now.year.to_s,
                         "#{yyyymmdd}.html.xz"])
    end

    private

    def all_periods
      ['daily', 'weekly', 'monthly', 'quarter', 'yearly']
    end
  end
end
  
