require "open-uri"
require "nokogiri"

require "yomou/secondrank/daily"
require "yomou/secondrank/weekly"
require "yomou/secondrank/monthly"
require "yomou/secondrank/quarter"
require "yomou/secondrank/yearly"

module Yomou
  module SecondRankapi

    class SecondRank < Thor

      desc "daily [OPTIONS]", ""
      subcommand "daily", Yomou::SecondRankapi::Daily

      desc "weekly [OPTIONS]", ""
      subcommand "weekly", Yomou::SecondRankapi::Weekly

      desc "monthly [OPTIONS]", ""
      subcommand "monthly", Yomou::SecondRankapi::Monthly

      desc "quarter [OPTIONS]", ""
      subcommand "quarter", Yomou::SecondRankapi::Quarter

      desc "yearly [OPTIONS]", ""
      subcommand "yearly", Yomou::SecondRankapi::Yearly

      desc "get", "get novel which is ranked on secondlist"
      option :type
      def get
        @conf = Yomou::Config.new
        return unless options['type']

        types = ["daily", "weekly", "monthly", "quarter", "yearly"]
        return unless types.include?(options['type'])

        query = options['type'] + "_total"
        url = sprintf("%s/%s", BASE_URL, query)
        path = Pathname.new(File.join(@conf.directory,
                                      "rankapi",
                                      "secondlist/#{query}.html"))
        p url
        download_html(url, path)

        p path
        entries = extract_rank_h(path)
        pp entries

        ncodes = entries.collect do |entry|
          entry["ncode"]
        end
        p ncodes
        Yomou::Narou::Downloader.new.download(ncodes)
      end

      private

      def download_html(url, path)
        p url
        p path
        if File.exists?(path.to_s)
          if path.mtime > Time.now - 60 * 60 * 24
            return
          end
        end
        FileUtils.mkdir_p(path.dirname)
        open(url) do |context|
          p path
          File.open(path.to_s, "w+") do |file|
            file.puts(context.read)
          end
        end
      end


    end
  end
end
