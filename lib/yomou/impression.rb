# coding: utf-8
module Yomou
  module Impression

    class PageParser

      attr_accessor :cache_path
      attr_reader :current_page

      include Yomou::Helper

      BASE_URL = 'http://novelcom.syosetu.com/impression/list/ncode/'

      def initialize(ncode)
        @conf = Yomou::Config.new
        sub_directory = ncode[1..2]
        @cache_path = pathname_expanded([@conf.directory,
                                         "impression",
                                         sub_directory,
                                         "#{ncode.downcase}.yaml.xz"])
        @current_page = 1
        @impressions = []
      end

      def cached?
        @cache_path.exist? and
          @cache_path.mtime > Time.now - YOMOU_SYNC_INTERVAL_WEEK
      end

      def cache
        data = []
        if @cache_path.exist?
          data = yaml_xz(@cache_path.to_s)
        end
        data
      end

      def skipped?
        @skipped
      end

      def append(entries)
        @impressions.concat(entries)
      end

      def fetch(impression_id)
        url = "#{BASE_URL}#{impression_id}/"
        unless @current_page == 1
          url += sprintf("index.php?p=%d", @current_page)
        end
        p url
        html(url) do |doc|
          doc.xpath("//div[@class='waku']").each do |div|
            next if @skipped
            entry = parse_impression_entry(div)
            unless cache.empty?
              unless entry[:created_at] > cache[0][:created_at]
                p "skip #{entry[:created_at]} by #{entry[:user][:name]}"
                @skipped = true
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
            @impressions << entry
          end
        end
        @current_page += 1
      end


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
            unless entry[:user]
              comment_user = parse_comment_user(child)
              entry[:user] = {}
              entry[:user][:name] = comment_user
            end
            entry[:created_at] = parse_comment_date(child)
          when "res"
          end
        end
        entry
      end

      def parse_comment_user(div)
        label, comment_user, _ = div.text.strip.split(/\r\n/)
        comment_user
      end

      def parse_comment_date(div)
        label, commenter, date, _ = div.text.strip.split(/\r\n/)
        if date =~ /.+\[(.+)\].*/
          date = DateTime.strptime($1, "%Y年 %m月 %d日 %H時 %M分")
        end
        date
      end
    end
  end
end
