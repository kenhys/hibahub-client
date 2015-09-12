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
          lists = Pathname.glob("#{@conf.directory}/nopointlist/nopointlist_*.html.gz")
          lists.each do |path|
            # TODO
            html_gz(path.to_s) do |doc|
              dat = {}
              n = 1
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
                dat[ncode.upcase] = {
                  :ncode => ncode.upcase,
                  :title => title,
                  :bookmark => bookmark,
                  :count => count
                }
                printf("%7d: %s: %s (%d) bookmark:%d\n", n, ncode, title, count, bookmark)
                n = n + 1
              end
              yaml_path  = path.to_s.sub(".html.gz", ".yaml.lz4")
              p yaml_path
              open(yaml_path, "w+") do |file|
                file.puts(LZ4.encode(YAML.dump(dat)))
              end
            end
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
