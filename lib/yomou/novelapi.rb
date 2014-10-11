require "thor"
require "open3"
require "yomou/novelapi/ncode"

module Yomou
  module Novelapi

    class Novel < Thor

      BASE_URL = "http://api.syosetu.com/novelapi/api/"

      include Yomou::Helper

      desc "novel [SUBCOMMAND]", "Get novel data"
      option :ncode
      def get
        p options
        @conf = Yomou::Config.new
        p @conf.directory
        Dir.chdir(@conf.directory) do
          p options["ncode"]
          IO.popen(["narou", "download", options["ncode"]], "r+") do |io|
            io.puts
            io.close_write
            puts io.read
          end
        end
      end

      desc "genre", "Get metadata about genre code"
      option :download
      def genre(arg = nil)
        @conf = Yomou::Config.new
        url = BASE_URL + [
          "gzip=#{@conf.gzip}",
          "out=#{@conf.out}"
        ].join("&")
        codes = extract_codes_from_argument(arg)
        p codes

        downloader = Yomou::Narou::Downloader.new
        bookshelf = Yomou::Bookshelf.new

        codes.each do |code|
          [
            "favnovelcnt",
            "reviewcnt",
            "hyoka",
            "impressioncnt",
            "hyokacnt"
          ].each do |order|
            first = true
            offset = 1
            limit = 500
            allcount = 10
            p code

            while offset < 2000

              of = "of=n-u-g-f-r-a-ah-sa-ka"
              url = sprintf("%s?genre=%d&gzip=%d&out=%s&lim=%d&st=%d&%s&order=%s",
                            BASE_URL, code, @conf.gzip, @conf.out, limit, offset, of, order)
              path = Pathname.new(File.join(@conf.directory,
                                            "novelapi",
                                            "genre_#{code}_#{order}_#{offset}-.yaml.gz"))
              p url
              p path
              save_as(url, path)
              yaml = yaml_gz(path.to_s)
              if first
                allcount = yaml.first["allcount"]
              end
              p allcount
              #pp yaml
              ncodes = yaml[1..-1].collect do |entry|
                entry["ncode"]
              end
              if options["download"]
                downloader.download(ncodes)
              else
                bookshelf.register_ncode(ncodes)
              end
              offset += 500
            end
          end
        end
      end

      desc "keyword", ""
      def keyword(arg)
        case arg
        when "list"
          keywordlist
        end
      end

      desc "keywordlist", ""
      option :download
      def keywordlist
        keywords = []
        open("http://yomou.syosetu.com/search/classified/") do |context|
          doc = Nokogiri::HTML.parse(context.read)
          doc.xpath("//div[@class='word']/a").each do |a|
            keywords << a.text
          end
        end

        downloader = Narou::Downloader.new
        p downloader
        keywords.each_with_index do |keyword, index|
          puts "#{index+1}/#{keywords.size}"
          page = 1
          total = nil
          p keyword
          while page <= 100 do
            url = sprintf("%s?word=%s&order=hyoka&p=%d",
                          "http://yomou.syosetu.com/search.php",
                          URI.escape(keyword),
                          page)
            p url
            ncodes = []
            open(url) do |context|
              doc = Nokogiri::HTML.parse(context.read)
              unless not total
                doc.xpath("//div[@id='main2']/b").each do |b|
                  b.text =~ /([\d,]+)/
                  pages = $1.delete(",").to_i / 20
                end
              end
              doc.xpath("//div[@class='novel_h']/a").each do |a|
                a.attribute("href").text =~ /.+\/(n.+)\//
                ncode = $1
                ncodes << ncode
              end
            end
            p keyword
            downloader.download(ncodes)
            break if page >= 100
            page = page + 1
          end
        end
      end
    end

  end
end
