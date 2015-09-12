# coding: utf-8
require "yomou/command/isolated/nopoint"
require "yomou/command/isolated/noimpression"

module Yomou
  module Command
    module Isolated

      def group_by_sub_directory(hash)
        group = {}
        hash.keys.each do |ncode|
          ncode =~ /n(\d\d).+/
          sub_directory = $1
          if group.has_key?(sub_directory)
            group[sub_directory][ncode] = hash[ncode]
          else
            group[sub_directory] = {
              ncode => data[ncode]
            }
          end
        end
        group
      end

      def archive_no_group(category, group)
        group.keys.sort.each do |key|
          path = pathname_expanded([@conf.directory,
                                    category,
                                    "n#{key}.yaml.gz"])
          p path
          entries = []
          if path.exist?
            entries = yaml_gz(path.to_s)
            entries.merge!(group[key])
          else
            entries = group[key]
          end
          archive(entries, path)
        end
      end

      def extract_total_novels_from_each_page(doc)
        total = 0
        doc.xpath("//div[@class='site_h2']").each do |div|
          div.text =~ /.+?(\d+)/
          total = $1.to_i
        end
        total
      end

      def extract_ncode_from_each_page_with_keyword(path, total = nil)
        ncodes = []
        html_gz(path.to_s) do |context|
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
        ncodes
      end

        def extract_newreview(doc)
          dat = {}
          doc.xpath("//div[@class='newreview']").each_with_index do |div, n|
            ncode = ""
            title = ""
            count = 1
            status = nil
            div.xpath("div[@class='review_title']/a").each do |a|
              ncode = extract_ncode_from_url(a.attribute("href").text)
              title, bracket, status, count_label, _ = a.text.split("\n")
              count_label =~ /.+?(\d+)/
              count = $1.to_i
            end
            mypage = nil
            writer = nil
            div.xpath("a[1]").each do |a|
              mypage = a.attribute("href").text
              writer = a.text
            end
            bookmark = 0
            chars = 0
            review = 0
            impression = 0
            genre = ""
            keywords = []
            div.xpath("div[2]").each do |div|
              div.text.split("\n").each do |entry|
                case entry
                when /^ジャンル：(.+)/
                  genre = $1
                when /^キーワード：(.+)\s*$/
                  keywords = $1.split
                end
              end
            end
            div.xpath("div[3]").each do |div|
              items = div.text.split("\n").reject do |item|
                not item.include?("：")
              end
              items.each do |item|
                case item
                when /文字数：([0-9,]+)/
                  chars = $1.delete(',').to_i
                when /ブックマーク：(\d+)/
                  bookmark = $1.to_i
                when /レビュー：(\d+)/
                  review = $1.to_i
                when /感想：(\d+)/
                  impression = $1.to_i
                end
              end
            end
            dat[ncode.downcase] = {
              :ncode => ncode.downcase,
              :status => status,
              :genre => genre,
              :keywords => keywords,
              :title => title,
              :mypage => mypage,
              :writer => writer,
              :bookmark => bookmark,
              :chars => chars,
              :review => review,
              :impression => impression,
              :count => count
            }
          end
          dat
        end
      end
    end
  end
end
