require "open-uri"

module Yomou
  module Rankapi

    class Daily < Thor
      namespace "rank daily"

      include Yomou::Helper

      desc "list", ""
      def list
        @conf = Yomou::Config.new
        date = Date.today
        url = daily_url(date)
        yaml_gz(url).each do |entry|
          printf("%3d: %3dpt %s\n",
                 entry["rank"], entry["pt"], entry["ncode"])
        end
      end

      desc "download [--since YYYYMMDD]", ""
      option :since
      def download
        @conf = Yomou::Config.new
        date = nil
        if options.has_key?("since")
          date = Date.parse(options["since"])
        else
          date = Date.new(2013, 5, 7)
        end
        while date < Date.today
          url = daily_url(date)
          path = daily_path(date)
          if path.exist?
            date = date.next_day
            next
          end

          p url
          p path
          save_as(url, path)
          date = date.next_day
        end
      end

      private

      def daily_url(date)
        rtype = date.strftime("%Y%m%d-d")
        [
          "#{BASE_URL}/?rtype=#{rtype}",
          "gzip=#{@conf.gzip}",
          "out=#{@conf.out}"
        ].join("&")
      end

      def daily_path(date)
        rtype = date.strftime("%Y%m%d-d")
        path = Pathname.new(File.join(@conf.directory,
                                      "rankapi",
                                      date.strftime("daily/%Y/%m"),
                                      "#{rtype}.yaml.gz"))
        path
      end
    end
  end
end
