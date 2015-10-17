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
                                         "#{ncode.downcase}.yaml.xz"])
        @url = INFO_URL + ncode.downcase + '/'
      end

      def download
        save_as(@info.url, @cache_path, {:compress => true})
      end

      def cached?
        @cache_path.exist? and
          @cache_path.mtime > Time.now - YOMOU_SYNC_INTERVAL_WEEK
      end

      def fetch_info
        p @url
        hash = {}
        begin
          hash = parse
          archive(hash, @cache_path)
        rescue
          # TODO:
        end
        hash
      end

      def parse
        hash = {}
        html(@url) do |doc|
          header = parse_novel_header(doc)
          hash.merge!(header)
          hash.merge!(parse_novel_table2(doc))
        end
        hash
      end

      def parse_novel_table2_label(tr)
        label = ""
        tr.xpath('th').each do |th|
          label = th.text
        end
        label
      end

      def parse_novel_table2_text(tr)
        text = ""
        tr.xpath('td').each do |td|
          text = td.text
        end
        text
      end

      def parse_novel_table2(doc)
        doc.xpath("//table[@id='noveltable2']/tr").each do |tr|
          label = parse_novel_table2_label(tr)
          text = parse_novel_table2_text(tr)
          case label
          when '感想'
            hash[:impression_count] = text.gsub(/\n|件/, "").to_i
          when 'レビュー'
            hash[:review_count] = text.gsub(/,|件/, "").to_i
          when '総合評価'
            hash[:total_point] = parse_point(text.split[0])
          when 'ポイント評価'
            unless text.end_with?("非公開")
              hash[:writing_point] = parse_point(text.split[0])
              hash[:story_point] = parse_point(text.split[2])
            end
          when 'ブックマーク登録'
            unless text.end_with?("非公開")
              hash[:bookmark_count] = text.gsub(/,|件/, "").to_i
            end
          end
        end
      end

      def parse_point(text)
        text.gsub(/,|pt/, "").to_i
      end

      def parse_novel_header(doc)
        hash = {}
        doc.xpath("//ul[@id='head_nav']/li/a").each do |a|
          case a.text
          when '感想'
            hash[:impression_url] = a.attribute('href').value
            hash[:impression_url] =~ /.+\/(\d+)\/$/
            hash[:impression_id] = $1
          when 'レビュー'
            hash[:review_url] = a.attribute('href').value
          when '縦書きPDF'
            hash[:pdfnovel_url] = a.attribute('href').value
          when 'ブックマーク'
            hash[:bookmark_url] = a.attribute('href').value
          end
        end
        hash
      end
    end
  end
end
