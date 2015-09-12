# coding: utf-8
module Yomou
  module Command
    module Isolated

      class NoImpression < Thor
        namespace :noimpression

        attr_accessor :conf
        attr_accessor :bookshelf
        attr_accessor :downloader

        include Yomou::Helper
        include Yomou::Command::Isolated

        desc "download", ""
        option :min_page
        option :max_page
        option :min_bookmark
        def download
          @conf = Yomou::Config.new
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
                                      "noimpressionlist",
                                      "noimpressionlist_#{page}.html.gz"])
            url = sprintf("%s?p=%d",
                          "http://yomou.syosetu.com/nolist/noimpressionlist/index.php",
                          page)
            p url
            p path
            save_as(url, path, {:compress => true})
            if page == min_page
              html_gz(path.to_s) do |doc|
                total = extract_total_novels_from_each_page(doc)
                max_page = (total / 20) + 1 unless options[:max_page]
              end
            end
            n = n + 20
            page = page + 1
          end
        end

        desc "makecache", ""
        def makecache
          @conf = Yomou::Config.new
          lists = Pathname.glob("#{@conf.directory}/nopointlist/nopointlist_*.html.gz")
          lists.each do |path|
            data = {}
            html_gz(path.to_s) do |doc|
              dat = extract_newreview(doc)
              data.merge!(dat)
            end
          end
          group = group_by_sub_directory(data)
          archive_no_group("noimpression", group)
        end

        desc "load", ""
        def load
          unless @bookshelf and @bookshelf.ncode_exist?(ncode)
            @bookshelf.register_ncode(ncode)
          end
        end

      end
    end
  end
end
