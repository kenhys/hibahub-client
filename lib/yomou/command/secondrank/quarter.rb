require "open-uri"

module Yomou
  module SecondRankapi

    class Quarter < Thor
      namespace "secondrank quarter"

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
        entries = extract_rank_h(quarter_url)
        p quarter_path
        archive(entries, quarter_path)
      end

      private

      def quarter_url
        "#{BASE_URL}/quarter_total"
      end

      def quarter_path
        pathname_expanded([@conf.directory,
                           "secondlist/quarter/#{yyyymmdd}.yaml.gz"])
      end

    end
  end
end
