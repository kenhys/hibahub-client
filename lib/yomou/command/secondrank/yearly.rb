require "open-uri"

module Yomou
  module SecondRankapi

    class Yearly < Thor
      namespace "secondrank yearly"

      include Yomou::Helper
      include Yomou::SecondRankapi::Common

      desc "list", ""
      def list
        @conf = Yomou::Config.new

        url = "#{BASE_URL}/yearly_total"
        save_as(url, yearly_path)

        entries = extract_rank_h(yearly_path)

        entries.each do |entry|
          printf("%4d: %3dpt %s %s\n",
                 entry["rank"], entry["pt"], entry["ncode"], entry["title"])
        end
      end

      desc "download [OPTIONS]", ""
      def download
        @conf = Yomou::Config.new
        entries = extract_rank_h(yearly_path)
        ncodes = entries.collect do |entry|
          entry["ncode"]
        end
        Yomou::Narou::Downloader.new.download(ncodes)
      end

      private

      def yearly_path
        pathname_expanded([@conf.directory,
                            "rankapi",
                            "secondlist/yearly_total.html"])
      end

    end
  end
end
