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
        entries = extract_rank_h(daily_url)
        p daily_path
        archive(entries, daily_path)
      end

      private

      def daily_url
        "#{BASE_URL}/daily_total"
      end

      def daily_path
        yyyymmdd = Date.today.strftime("%Y%m%d")
        pathname_expanded([@conf.directory,
                           "secondlist/daily/#{yyyymmdd}.yaml.gz"])
      end
    end
  end
end
