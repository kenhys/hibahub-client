require "nokogiri"
require "yomou/novelapi/nolist"

module Yomou
  module Novelapi

    class NoPointList < NoList

      attr_accessor :conf
      attr_accessor :bookshelf
      attr_accessor :downloader

      include Yomou::Helper

      def initialize
      end

      def download(options)
        min_page = 1
        max_page = 100000
        min_bookmark = 1

        min_page = options[:min_page] if options[:min_page]
        max_page = options[:max_page] if options[:max_page]
        min_bookmark = options[:min_bookmark] if options[:min_bookmark]

        p options

        page = min_page
        n = 1
        total = 20
        bookmark = 0

        until n > total or page > max_page
          next if page < min_page

          path = pathname_expanded([@conf.directory,
                                     "nopointlist",
                                     "nopointlist_#{page}.html.gz"])
          url = sprintf("%s?p=%d",
                        "http://yomou.syosetu.com/nolist/nopointlist/index.php",
                        page)
          save_as(url, path, {:compress => true})
          html_gz(path.to_s) do |doc|
            if page == min_page
              total = extract_total_novels_from_each_page(doc)
              max_page = (total / 20) + 1 unless options[:max_page]
            end

            doc.xpath("//div[@class='newreview']").each do |div|
              ncode = ""
              title = ""
              count = 1
              div.xpath("div[@class='review_title']/a").each do |a|
                ncode = extract_ncode_from_url(a.attribute("href").text)
                title, bracket, status, count_label, _ = a.text.split("\n")
                count_label =~ /.+?(\d+)/
                count = $1.to_i
              end
              bookmark = 0
              div.xpath("div[3]").each do |div|
                items = div.text.split("\n").reject do |item|
                  not item.include?("：")
                end
                items[1] =~ /.+?(\d+)/
                bookmark = $1.to_i
              end
              printf("%7d: %s: %s (%d) bookmark:%d\n", n, ncode, title, count, bookmark)

              unless @bookshelf and @bookshelf.ncode_exist?(ncode)
                @bookshelf.register_ncode(ncode)
              end
              n = n + 1
            end
          end
          page = page + 1
        end
      end
    end
  end
end
