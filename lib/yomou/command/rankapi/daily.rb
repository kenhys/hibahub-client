require "open-uri"

module Yomou
  module Rankapi

    class Daily < Thor
      namespace "rank daily"

      include Yomou::Helper

      desc "list", ""
      def list
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
        @agent = Yomou::Api::RankGet::DailyDownloader.new
        if options.has_key?("since")
          @agent.since = Date.parse(options["since"])
        end
        @agent.downloads
      end

      private

    end
  end
end
