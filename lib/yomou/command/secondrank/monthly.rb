require "open-uri"
require "date"

module Yomou
  module SecondRankapi

    class Monthly < Thor
      namespace "secondrank monthly"

      include Yomou::Helper
      include Yomou::SecondRankapi::Common

      desc "list", ""
      def list
        @conf = Yomou::Config.new

        url = "#{BASE_URL}/monthly_total"
        save_as(url, monthly_path)

        entries = extract_rank_h(monthly_path)

        entries.each do |entry|
          printf("%4d: %3dpt %s %s\n",
                 entry["rank"], entry["pt"], entry["ncode"], entry["title"])
        end
      end

      desc "download [OPTIONS]", ""
      def download
        @conf = Yomou::Config.new
        entries = extract_rank_h(monthly_path)
        ncodes = entries.collect do |entry|
          entry["ncode"]
        end
        Yomou::Narou::Downloader.new.download(ncodes)
      end

      private

      def monthly_path
        pathname_expanded([@conf.directory,
                            "rankapi",
                            "secondlist/monthly_total.html"])
      end
    end
  end
end
