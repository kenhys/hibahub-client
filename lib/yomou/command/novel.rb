# coding: utf-8
require "thor"
require "open3"
require "fileutils"
require "yomou/bookshelf"

module Yomou
  module Command

    class Novel < Thor
      namespace :novel

      BASE_URL = "http://api.syosetu.com/novelapi/api/"

      include Yomou::Helper

      desc "get [SUBCOMMAND]", "Get novel data"
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

      desc "download [SUBCOMMAND]", "Download novel data"
      option :ncode
      def download(*ncodes)
        @conf = Yomou::Config.new
        downloader = Narou::Downloader.new
        bookshelf = Yomou::Bookshelf.new

        if ncodes.empty?
          novels = Groonga["NarouNovels"]
          records = novels.select("yomou_status:#{YOMOU_NOVEL_NONE}")
          ncodes = []
          records.each do |record|
            ncodes << record._key
          end
        end
        downloader.download(ncodes)
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
              path = pathname_expanded([@conf.directory,
                                         "novelapi",
                                         "genre_#{code}_#{order}_#{offset}-.yaml.xz"])
              p url
              p path
              save_as(url, path)
              yaml = yaml_xz(path.to_s)
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
      option :verbose
      option :nth
      def keywordlist
        @conf = Yomou::Config.new

        @agent = Yomou::Keyword::KeywordList.new
        @agent.download

        if @agent.keywords.empty?
          p "no keywords"
          return
        end

        downloader = Narou::Downloader.new
        bookshelf = Yomou::Bookshelf.new

        @agent.load_keywords.each do |word,index|
          p word
          p index
          @agent.novels_with_keyword(word)
        end
      end

      desc "nopointlist [--download|--makecache]", ""
      option :download
      option :makecache
      def nopointlist
        @conf = Yomou::Config.new

        downloader = Narou::Downloader.new
        bookshelf = Yomou::Bookshelf.new
        nopointlist = Yomou::Novelapi::NoPointList.new

        nopointlist.conf = @conf
        nopointlist.bookshelf = bookshelf
        nopointlist.downloader = downloader

        if options[:download]
          parameters = {
            :min_page => 1,
          }
          nopointlist.download(parameters)
        end
        if options[:makecache]
          nopointlist.makecache
        end
      end

      desc "noimpressionlist [--download|--makecache]", ""
      option :download
      option :makecache
      def noimpressionlist
        @conf = Yomou::Config.new

        noimpressionlist = Yomou::Novelapi::NoImpressionList.new

        no_common_action(noimpressionlist, options)
      end

      private

      def no_common_action(object, options)
        object.conf = @conf
        downloader = Narou::Downloader.new
        bookshelf = Yomou::Bookshelf.new
        object.bookshelf = bookshelf
        object.downloader = downloader

        if options[:download]
          parameters = {
            :min_page => 1,
          }
          object.download(parameters)
        end
        if options[:makecache]
          object.makecache
        end
      end

      def load_keywords_yaml(path, keywords)
        assoc = {}
        if path.exist?
          assoc = yaml_xz(path.to_s)
        else
          keywords.each_with_index do |keyword, index|
            page = 1
            while page <= 100 do
              filename = "#{URI.escape(keyword)}_hyoka_#{page}.html.xz"
              path = pathname_expanded([@conf.directory,
                                         "keyword",
                                         URI.escape(keyword),
                                         filename])
              if path.exist?
                ncodes = extract_ncode_from_each_page_with_keyword(path)
                if assoc[keyword]
                  assoc[keyword].concat(ncodes)
                else
                  assoc[keyword] = ncodes
                end
              end
              page = page + 1
            end
          end
        end
        assoc
      end

    end
  end
end
