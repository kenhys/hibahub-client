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

      INFO_URL = 'http://ncode.syosetu.com/novelview/infotop/ncode/'

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
        path = pathname_expanded([@conf.directory,
                                  'info',
                                  ncode.slice(1,2),
                                  "#{ncode.downcase}.html.xz"])
        info_url = INFO_URL + ncode + '/'
        p info_url
        begin
          save_as(info_url, path, {:compress => true})
        rescue
          return hash
        end
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
