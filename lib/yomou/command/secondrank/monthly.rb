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
        entries = extract_rank_h(monthly_url)
        p monthly_path
        archive(entries, monthly_path)
      end

      private

      def monthly_url
        "#{BASE_URL}/monthly_total"
      end

      def monthly_path
        pathname_expanded([@conf.directory,
                           "secondlist/monthly/#{yyyymmdd}.yaml.gz"])
      end
    end
  end
end
