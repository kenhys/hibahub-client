require "open-uri"

module Yomou
  module SecondRankapi

    class Quarter < Thor

      include Yomou::Helper
      include Yomou::SecondRankapi::Common

      desc "list", ""
      def list
        @conf = Yomou::Config.new

        url = "#{BASE_URL}/quarter_total"
        save_as(url, quarter_path)

        entries = extract_rank_h(quarter_path)

        entries.each do |entry|
          printf("%4d: %3dpt %s %s\n",
                 entry["rank"], entry["pt"], entry["ncode"], entry["title"])
        end
      end

      desc "download [OPTIONS]", ""
      def download
        @conf = Yomou::Config.new
        entries = extract_rank_h(quarter_path)
        ncodes = entries.collect do |entry|
          entry["ncode"]
        end
        Yomou::Narou::Downloader.new.download(ncodes)
      end

      private

      def quarter_path
        Pathname.new(File.join(@conf.directory,
                               "rankapi",
                               "secondlist/quarter_total.html"))
      end

    end
  end
end
