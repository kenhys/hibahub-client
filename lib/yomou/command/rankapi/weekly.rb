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
        @agent = Yomou::Api::RankGet::WeeklyDownloader.new
        if options.has_key?("since")
          @agent.since = Date.parse(options["since"])
        end
        @agent.downloads
      end

    end
  end
end
