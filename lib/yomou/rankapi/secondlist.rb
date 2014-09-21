require "open-uri"
require "nokogiri"

module Yomou
  module Rankapi

    class SecondList < Thor

      BASE_URL = "http://yomou.syosetu.com/rank/secondlist/type"

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
        if path.mtime > Time.now - 60 * 60 * 24
          FileUtils.mkdir_p(path.dirname)
          open(url) do |context|
            p path
            File.open(path.to_s, "w+") do |file|
              file.puts(context.read)
            end
          end
        end
      end

      def extract_rank_h(path)
        entries = []
        File.open(path.to_s, "r") do |file|
          doc = Nokogiri::HTML.parse(file.read, nil, nil)
          doc.xpath("//div[@class='rank_h']").each do |div|
            node = div.xpath("a[@class='tl']")
            title = node.text
            p title
            url = node.attribute("href").text
            ncode = nil
            if url =~ /syosetu\.com\/(.+)\//
              ncode = $1
            end
            next unless ncode

            entries << {
              'ncode' => ncode,
              'url' => url,
              'title' => title
            }
          end
        end
        entries
      end

    end
  end
end
