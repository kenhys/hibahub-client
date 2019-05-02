# frozen_string_literal: true

require "yomou/helper"
require "yomou/crawler/base"

module Yomou
  class NoimpressionCrawler < BaseCrawler
    include Yomou::Helper
    include Yomou::Command::Isolated

    desc "download", ""
    option :min_page
    option :max_page
    option :min_bookmark
    def download
      @conf = Yomou::Config.new
      min_page = 1
      max_page = 100000
      min_bookmark = 1

      min_page = options[:min_page] if options[:min_page]
      max_page = options[:max_page] if options[:max_page]
      min_bookmark = options[:min_bookmark] if options[:min_bookmark]

      p options

      page = min_page
      n = 1
      total = 20
      bookmark = 0

      until n > total or page > max_page
        next if page < min_page

        path = pathname_expanded([@conf.directory,
                                   "noimpressionlist",
                                   "noimpressionlist_#{page}.html.xz"])
        url = sprintf("%s?p=%d",
                      "http://yomou.syosetu.com/nolist/noimpressionlist/index.php",
                      page)
        p url
        p path
        save_as(url, path, {:compress => true})
        if page == min_page
          html_xz(path.to_s) do |doc|
            total = extract_total_novels_from_each_page(doc)
            max_page = (total / 20) + 1 unless options[:max_page]
          end
        end
        n = n + 20
        page = page + 1
      end
    end

    desc "makecache", ""
    def makecache
      @conf = Yomou::Config.new
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

    desc "loadcache", ""
    def loadcache
      @conf = Yomou::Config.new
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
