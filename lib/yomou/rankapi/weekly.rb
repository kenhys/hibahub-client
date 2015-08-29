require "open-uri"

module Yomou
  module Rankapi

    class Weekly < Thor
      namespace "rank weekly"

      include Yomou::Helper

      desc "list", ""
      def list
        @conf = Yomou::Config.new
        date = Date.today
        until date.tuesday?
          date = date.prev_day(1)
        end
        url = weekly_url(date)
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
          until date.tuesday?
            date = date.next_day(1)
          end
        else
          date = Date.new(2013, 5, 7)
        end
        while date < Date.today
          rtype = date.strftime("%Y%m%d-w")
          url = weekly_url(date)
          path = weekly_path(date)
          p url
          p path
          save_as(url, path)
          date = date.next_day(7)
        end
      end

      private

      def weekly_url(date)
        rtype = date.strftime("%Y%m%d-w")
        [
          "#{BASE_URL}/?rtype=#{rtype}",
          "gzip=#{@conf.gzip}",
          "out=#{@conf.out}"
        ].join("&")
      end

      def weekly_path(date)
        rtype = date.strftime("%Y%m%d-w")
        path = Pathname.new(File.join(@conf.directory, "rankapi",
                                      date.strftime("weekly/%Y/#{rtype}.yaml.gz")))
        FileUtils.mkdir_p(path.dirname)
        path
      end

    end
  end
end
