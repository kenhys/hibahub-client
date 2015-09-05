require "open-uri"

require "yomou/command/secondrank/common"

module Yomou
  module SecondRankapi

    class Daily < Thor
      namespace "secondrank daily"

      include Yomou::Helper
      include Yomou::SecondRankapi::Common

      desc "list", ""
      def list
        @conf = Yomou::Config.new

        url = "#{BASE_URL}/daily_total"
        save_as(url, daily_path)

        entries = extract_rank_h(daily_path)

        entries.each do |entry|
          printf("%4d: %3dpt %s %s\n",
                 entry["rank"], entry["pt"], entry["ncode"], entry["title"])
        end
      end

      desc "download [OPTIONS]", ""
      def download
        @conf = Yomou::Config.new
        entries = extract_rank_h(daily_path)
        ncodes = entries.collect do |entry|
          entry["ncode"]
        end
        Yomou::Narou::Downloader.new.download(ncodes)
      end

      private

      def daily_path
        yyyymmdd = Date.today.strftime("%Y%m%d")
        pathname_expanded([@conf.directory,
                            "rankapi",
                            "secondlist/daily/#{yyyymmdd}.yaml.gz"])
      end
    end
  end
end
