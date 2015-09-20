require "open-uri"

module Yomou
  module SecondRankapi

    class Weekly < Thor
      namespace "secondrank weekly"

      include Yomou::Helper
      include Yomou::SecondRankapi::Common

      desc "list", ""
      def list
        @conf = Yomou::Config.new

        url = "#{BASE_URL}/weekly_total"
        save_as(url, weekly_path)

        entries = extract_rank_h(weekly_path)

        entries.each do |entry|
          printf("%4d: %3dpt %s %s\n",
                 entry["rank"], entry["pt"], entry["ncode"], entry["title"])
        end
      end

      desc "download [OPTIONS]", ""
      def download
        @conf = Yomou::Config.new
        entries = extract_rank_h(weekly_url)
        p weekly_path
        archive(entries, weekly_path)
      end

      private

      def weekly_url
        "#{BASE_URL}/weekly_total"
      end

      def weekly_path
        yyyymmdd = Date.today.strftime("%Y%m%d")
        pathname_expanded([@conf.directory,
                           "secondlist/weekly/#{yyyymmdd}.yaml.xz"])
      end
    end
  end
end
