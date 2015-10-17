# coding: utf-8
module Yomou
  module Command
    class Impression < Thor
      namespace :impression

      include Yomou::Helper

      BASE_URL = 'http://novelcom.syosetu.com/impression/list/ncode/'

      desc "download", ""
      def download(*ncodes)
        @conf = Yomou::Config.new

        if ncodes.empty?
          @downloader = Yomou::Narou::Downloader.new
          ncodes = @downloader.downloaded_ncodes
        end

        ncodes.each do |ncode|

          @impression = Impression::PageParser.new(ncode)

          next if @impression.skip?

          entries = @impression.cache

          @info = NovelInfo::PageParser.new(ncode)
          info = @info.fetch_info
          p info
          next if info.empty?
          next if info[:impression_count] == 0
          n_pages = info[:impression_count] / 10 + 1
          impressions = []
          skip = false
          n_pages.times do |index|
            next if @impression.skipped?
            sleep YOMOU_REQUEST_INTERVAL_MSEC
            @impression.fetch(info[:impression_id])
          end
          entries = @impression.append(entries)
          archive(entries, path)
        end
      end

      private


      def parse_impression_entry(div)
        entry = {}
        label = ""
        div.xpath('div').each do |child|
          klass = child.attribute('class')
          next unless klass
          case klass.text
          when "comment_h2"
            label = child.text
          when "comment"
            body = child.text
            case label
            when "良い点"
              entry[:good] = body
            when "悪い点"
              entry[:bad] = body
            when "一言"
              entry[:hint] = body
            end
          when "comment_user"
            user = {}
            child.xpath('a').each do |a|
              user[:mypage] = mypage = a.attribute('href').text
              user[:name] = a.text
              entry[:user] = user
            end
            label, commenter, date, _ = child.text.strip.split(/\r\n/)
            if date =~ /.+\[(.+)\].*/
              date = DateTime.strptime($1, "%Y年 %m月 %d日 %H時 %M分")
              entry[:created_at] = date
            end
          when "res"
          end
        end
        entry
      end

    end

  end
end
