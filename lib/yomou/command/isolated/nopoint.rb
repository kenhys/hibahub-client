# coding: utf-8

module Yomou
  module Command
    module Isolated

      class NoPoint < Thor
        namespace :nopoint

        include Yomou::Command::Isolated
        include Yomou::Helper

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
                                      "nopointlist",
                                      "nopointlist_#{page}.html.xz"])
            url = sprintf("%s?p=%d",
                          "http://yomou.syosetu.com/nolist/nopointlist/index.php",
                          page)
            p url
            p path
            save_as(url, path, {:compress => true})
            if page == min_page
              html_xz(path.to_s) do |doc|
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
          lists = Pathname.glob("#{@conf.directory}/nopointlist/nopointlist_*.html.xz").sort
          data = {}
          lists.each do |path|
            # TODO
            p path
            html_xz(path.to_s) do |doc|
              dat = extract_newreview(doc, "nopointlist")
              data.merge!(dat)
            end
          end
          group = group_by_sub_directory(data)
          archive_no_group("nopointlist", group)
          lists.each do |path|
            path.delete
          end
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
