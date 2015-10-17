# coding: utf-8
module Yomou
  module NovelInfo

    class PageParser

      INFO_URL = 'http://ncode.syosetu.com/novelview/infotop/ncode/'

      attr_accessor :cache_path, :url

      include Yomou::Helper

      def initialize(ncode)
        @conf = Yomou::Config.new
        @cache_path = pathname_expanded([@conf.directory,
                                         'info',
                                         ncode.slice(1,2),
                                         "#{ncode.downcase}.html.xz"])
        @url = INFO_URL + ncode.downcase + '/'
      end

      def download
        save_as(@info.url, @cache_path, {:compress => true})
      end

      def fetch_info
        p @url
        hash = {}
        begin
          download
          hash = parse
        rescue
          # TODO:
        end
        hash
      end

      def parse
        hash = {}
        html_xz(path.to_s) do |doc|
          doc.xpath("//ul[@id='head_nav']/li/a").each do |a|
            case a.text
            when '感想'
              hash[:impression_url] = a.attribute('href').value
              hash[:impression_url] =~ /.+\/(\d+)\/$/
              hash[:impression_id] = $1
            when 'レビュー'
              hash[:review_url] = a.attribute('href').value
            end
          end
          doc.xpath("//table[@id='noveltable2']/tr").each_with_index do |tr,i|
            label = ""
            text = ""
            tr.xpath('th').each do |th|
              label = th.text
            end
            tr.xpath('td').each do |td|
              text = td.text
            end
            case label
            when '感想'
              hash[:impression_count] = text.gsub(/\n|件/, "").to_i
            when 'レビュー'
              hash[:review_count] = text.gsub(/,|件/, "").to_i
            when 'ポイント評価'
              unless text.end_with?("非公開")
                hash[:writing_point] = text.split[0].gsub(/,|pt/, "").to_i
                hash[:story_point] = text.split[2].gsub(/,|pt/, "").to_i
              end
            when 'ブックマーク登録'
              unless text.end_with?("非公開")
                hash[:bookmark_count] = text.gsub(/,|件/, "").to_i
              end
            end
          end
        end
        hash
      end
    end
  end
end
