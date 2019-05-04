# frozen_string_literal: true

require "yomou/helper"
require "yomou/config"
require "yomou/crawler/base"

module Yomou
  class NopointCrawler < BaseCrawler
    NOPOINTLIST_URL = 'http://yomou.syosetu.com/nolist/nopointlist/index.php'
    NOVELS_PER_PAGE = 20
    def initialize(options={})
      @options = options
      @output = options[:output] || $stdout
      @conf = Yomou::Config.new
    end

    def download(options={})
      @min_page = options[:min_page] || 1
      @max_page = options[:max_page] || 10000
      @min_bookmark = options[:min_bookmark] || 1

      page = @min_page
      n = 1
      loop do
        break if page > @max_page
        next if page < @min_page
        path = pathname_expanded([@conf.directory,
                                   "nopointlist",
                                   "nopointlist_#{page}.html.xz"])
        url = format("%<url>s?p=%<page>d", url: NOPOINTLIST_URL, page: page)
        @output.puts("fetch nopoint list page[#{page}]: #{url}")
        @output.puts("save nopoint list page[#{page}]: #{path}")
        save_as(url, path)
        n += NOVELS_PER_PAGE
        page += 1
      end
    end

    def makecache
      pattern = "#{@conf.directory}/nopointlist/nopointlist_*.html.xz"
      lists = Pathname.glob(pattern).sort
      data = {}
      lists.each do |path|
        @output.puts("Extract #{path}...")
        html_xz(path.to_s) do |doc|
          data.merge!(parse_no_list(doc))
        end
      end
      group = group_by_sub_directory(data)
      archive_group(group)
      lists.each do |path|
        @output.puts("Remove already cached: <#{path}>")
        #path.delete
      end
    end

    private

    def parse_no_list(doc)
      data = {}
      doc.xpath("//div[@class='no_list clearfix']").each_with_index do |div, index|
        entry = {}
        ncode = ""
        div.xpath("div[@class='no_list_head']/a[@class='novel_title']").each do |a|
          ncode = extract_ncode_from_url(a.attribute("href").text)
          entry = {
            ncode: ncode,
            title: a.text
          }
        end
        data[ncode.downcase] = entry
      end
      data
    end

    def group_by_sub_directory(hash)
      group = {}
      hash.keys.each do |ncode|
        ncode =~ /n(\d\d).+/
        sub_directory = $1
        if group.key?(sub_directory)
          group[sub_directory][ncode] = hash[ncode]
        else
          group[sub_directory] = {
            ncode => hash[ncode]
          }
        end
      end
      group
    end

    def archive_group(group)
      group.keys.sort.each do |key|
        path = pathname_expanded([@conf.directory,
                                  "nopointlist",
                                  "n#{key}.yaml.xz"])
        entries = []
        if path.exist?
          entries = yaml_xz(path.to_s)
          entries.merge!(group[key])
        else
          entries = group[key]
        end
        pp entries
        exit
        #archive(entries, path)
      end
    end

    def load
      unless @bookshelf and @bookshelf.ncode_exist?(ncode)
        @bookshelf.register_ncode(ncode)
      end
    end

    def parse(path)
      data = {}
      html_xz(path.to_s) do |doc|
        total = extract_total_novels(doc)
        data = {
          total: total,
          max_page: (total / NOVELS_PER_PAGE) + 1
        }
      end
      data
    end
  end
end
