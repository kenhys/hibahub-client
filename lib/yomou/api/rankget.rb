module Yomou
  module Api
    module RankGet

      BASE_URL = "http://api.syosetu.com/rank/rankget"

       class RankDownloader
        include Yomou::Helper

        def initialize
          @since = Date.new(2013, 5, 1)
          @conf = Yomou::Config.new
        end

        def download_url(type, date)
          rtype = date.strftime("%Y%m%d-#{type}")
          [
            "#{BASE_URL}/?rtype=#{rtype}",
            "gzip=#{@conf.gzip}",
            "out=#{@conf.out}"
          ].join("&")
        end

        def download_path(type, type_name, date)
          rtype = date.strftime("%Y%m%d-#{type}")
          path = pathname_expanded([@conf.directory,
                                    "rankapi",
                                    date.strftime("#{type_name}/%Y/%m"),
                                    "#{rtype}.yaml.xz"])
          path
        end
      end

      class DailyDownloader < RankDownloader
        attr_accessor :since

        def initialize
          super
          @type = "d"
          @type_name = "daily"
        end

        def downloads
          date = @since
          while date < Date.today
            url = download_url(@type, date)
            path = download_path(@type, @type_name, date)
            unless path.exist?
              if date >= Date.new(2013, 5, 1)
                p url
                p path
                archive(yaml_gz(url), path)
              end
            end
            date = date.next_day
          end
        end
      end
    end
  end
end
