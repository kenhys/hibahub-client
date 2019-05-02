# frozen_string_literal: true

module Yomou
  module Crawler
    class NopointCrawler < BaseCrawler
      NOPOINTLIST_URL = 'http://yomou.syosetu.com/nolist/nopointlist/index.php'
      def initialize(options={})
        @options = options
        @output = options[:output] || $stdout
      end

      def download(options={})
        @min_page = options[:min_page] || 1
        @max_page = options[:max_page] || 10000
        @min_bookmark = options[:min_bookmark] || 1

        until n > total or page > max_page
          next if page < min_page

          path = pathname_expanded([@conf.directory,
                                     "nopointlist",
                                     "nopointlist_#{page}.html.xz"])
          url = format("%s?p=%d", NOPOINTLIST_URL, page)
          p url
          p path
          save_as(url, path, {:compress => true})
          if page == min_page
            html_xz(path.to_s) do |doc|
              total = extract_total_novels_from_each_page(doc)
              max_page = (total / 20) + 1 unless options[:max_page]
            end
          end
          n += 20
          page += 1
        end
      end

      def makecache
        @conf = Yomou::Config.new
        pattern = "#{@conf.directory}/nopointlist/nopointlist_*.html.xz"
        lists = Pathname.glob(pattern).sort
        data = {}
        lists.each do |path|
          @output.puts("Extract #{path}...")
          html_xz(path.to_s) do |doc|
            dat = extract_newreview(doc, "nopointlist")
            data.merge!(dat)
          end
        end
        group = group_by_sub_directory(data)
        archive_no_group("nopointlist", group)
        lists.each do |path|
          @output.puts("Remove already cached: <#{path}>")
          path.delete
        end
      end

      def load
        unless @bookshelf and @bookshelf.ncode_exist?(ncode)
          @bookshelf.register_ncode(ncode)
        end
      end
    end
  end
end
