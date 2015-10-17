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

      def fetch(impression_id)
        url = "#{BASE_URL}#{impression_id}/"
        unless @current_page == 1
          url += sprintf("index.php?p=%d", @current_page + 1)
        end
        html(url) do |doc|
          doc.xpath("//div[@class='waku']").each do |div|
            entry = parse_impression_entry(div)
            unless cache.empty?
              unless entry[:created_at] > cache[0][:created_at]
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
            @impressions << entry
          end
        end
      end

    end
  end
end
