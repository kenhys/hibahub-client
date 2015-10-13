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

          info = fetch_info_from_ncode(ncode)
          p info
          next if info.empty?
          next if info[:impression_count] == 0
          n_pages = info[:impression_count] / 10 + 1
          impressions = []
          skip = false
          n_pages.times do |index|
            next if skip
            sleep YOMOU_REQUEST_INTERVAL_MSEC
            url = "#{BASE_URL}#{info[:impression_id]}/"
            unless index == 0
              url += sprintf("index.php?p=%d", index + 1)
            end
            p url
            open(url) do |context|
              doc = Nokogiri::HTML.parse(context.read)
              doc.xpath("//div[@class='waku']").each do |div|
                entry = parse_impression_entry(div)
                unless entries.empty?
                  unless entry[:created_at] > entries[0][:created_at]
                    p "skip #{entry[:created_at]} by #{entry[:user][:name]}"
                    skip = true
                    next
                  end
                end
                user_name = ""
                if entry[:user] and entry[:user][:name]
                  user_name = entry[:user][:name]
                end
                printf("%s good:%d bad:%d hint:%d %s\n",
                       entry[:created_at].to_s,
                       entry[:good] ? 1 : 0,
                       entry[:bad] ? 1 : 0,
                       entry[:hint] ? 1 : 0,
                       user_name)
                impressions << entry
              end
            end
          end
          entries = impressions.concat(entries)
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

      def fetch_info_from_ncode(ncode)
        hash = {}
        @info = NovelInfo:PageParser.new(ncode)

        p @info.url
        begin
          @info.download
        rescue
          return hash
        end
        hash = @info.parse
        hash
      end
    end

  end
end
