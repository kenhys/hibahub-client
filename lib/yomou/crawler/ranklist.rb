# frozen_string_literal: true

require "yomou/helper"
require "yomou/config"
require "yomou/crawler/base"

module Yomou
  class RanklistCrawler
    include Yomou::Helper
    GENRELIST_URL = 'https://yomou.syosetu.com/rank/list/type'
    def initialize(options={})
      @options = options
      @output = options[:output] || $stdout
      @conf = Yomou::Config.new
    end

    def download(options={})
      periods = options[:periods] || all_periods
      periods.each do |period|
        path_to_period = format("%<period>s_total", period: period)
        url = format("%<base>s/%<period>s",
                     base: GENRELIST_URL, period: path_to_period)
        @output.puts("download #{url}")
        path = html_path(period)
        save_as(url, path)
        @output.puts("save #{path}")
      end
    end

    def base_path
      pathname_expanded([@conf.directory, "ranklist"])
    end

    def html_path(period, yyyymmdd=nil)
      now = Time.now
      yyyymmdd = now.strftime("%Y%m%d") unless yyyymmdd
      path_to_period = format("%<period>s_total", period: period)
      pathname_expanded([base_path,
                         path_to_period,
                         now.year.to_s,
                         now.month.to_s
                         "#{yyyymmdd}.html.xz"])
    end

    private

    def all_periods
      ['daily', 'weekly', 'monthly', 'quarter', 'yearly', 'total']
    end
  end
end
  
