# frozen_string_literal: true

require "yomou/config"
require "yomou/helper"
require "yomou/crawler/base"

module Yomou
  class NoimpressionCrawler < BaseCrawler
    include Yomou::Helper

    NOIMPRESSIONLIST_URL = "http://yomou.syosetu.com/nolist/noimpressionlist/index.php"

    def initialize(options={})
      @options = options
      @output = options[:output] || $stdout
      @conf = Yomou::Config.new
    end

    def download(options)
      @min_page = options[:min_page] || 1
      @max_page = options[:max_page] || 9999
      @min_bookmark = options[:min_bookmark] || 1

      page = @min_page
      n = 1
      bookmark = 0

      loop do
        next if page < @min_page
        break if page > @max_page
        path = noimpressionlist_path(page)
        url = noimpressionlist_url(page)
        p path
        save_as(url, path)
        n = n + 20
        page += 1
      end
    end

    def noimpressionlist_url(page)
      format("%<url>s?p=%<page>d", url: NOIMPRESSIONLIST_URL, page: page)
    end

    def noimpressionlist_path(page)
      pathname_expanded([@conf.directory,
                         "noimpressionlist",
                         "noimpressionlist_#{page}.html.xz"])
    end

    def makecache
      lists = Pathname.glob("#{@conf.directory}/noimpressionlist/noimpressionlist_*.html.xz")
      data = {}
      lists.sort.each do |path|
        html_xz(path.to_s) do |doc|
          dat = extract_newreview(doc, "noimpressionlist")
          data.merge!(dat)
        end
      end
      group = group_by_sub_directory(data)
      archive_no_group("noimpressionlist", group)
      lists.each do |path|
        path.delete
      end
    end

    def loadcache
      @bookshelf = Bookshelf.new
      Dir.glob("#{@conf.directory}/noimpressionlist/*.yaml.xz").sort.each do |xz|
        p xz
        yaml_xz(xz).each do |entry|
          ncode = entry[1][:ncode]
          record = entry[1]

          params = record.select do |key|
            %i(title writer global_point all_point).include?(key)
          end
          translate = {
            :bookmark => :fav_novel_cnt,
            :review => :review_cnt,
            :chars => :length,
            :count => :general_all_no,
          }
          translate.each do |key, value|
            params[value] = record[key] if record.has_key?(key)
          end
          params[:keyword] = record[:keywords]
          params[:genre] = YOMOU_GENRE_TABLE[record[:genre]]
          if record[:mypage] =~ /.+\/(\d+)\//
            params[:userid] = $1.to_i
          end
          @bookshelf.register_ncode(ncode, params)
        end
      end
    end

  end
end
