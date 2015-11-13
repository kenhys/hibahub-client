require "open-uri"
require "date"

module Yomou
  module Rankapi

    class Monthly < Thor
      namespace "rank monthly"

      include Yomou::Helper

      desc "list", ""
      def list
        @conf = Yomou::Config.new
        date = Date.today
        date = Date.new(date.year, date.month, 1)
        url = monthly_url(date)
        yaml_gz(url).each do |entry|
          printf("%3d: %3dpt %s\n",
                 entry["rank"], entry["pt"], entry["ncode"])
        end
      end

      desc "download [--since YYYYMMDD|all]", ""
      option :since
      def download
        @agent = Yomou::Api::RankGet::MonthlyDownloader.new
        if options.has_key?("since")
          @agent.since = Date.parse(options["since"])
        end
        @agent.downloads
      end

    end
  end
end
