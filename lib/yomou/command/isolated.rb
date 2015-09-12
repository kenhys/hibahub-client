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
              ncode => hash[ncode]
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

      def extract_newreview(doc, category)
        dat = {}
        doc.xpath("//div[@class='newreview']").each_with_index do |div, n|
          ncode = ""
          title = ""
          count = 1
          status = nil
          case category
          when "nopointlist"
            crlf = "\n"
          else
            crlf = "\r\n"
          end
          div.xpath("div[@class='review_title']/a").each do |a|
            ncode = extract_ncode_from_url(a.attribute("href").text)
            title, bracket, status, count_label, _ = a.text.split(crlf)
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
          global_point = nil
          all_point = nil
          all_hyoka_count = nil
          genre = ""
          keywords = []
          div.xpath("div[2]").each do |div|
            div.text.split(crlf).each do |entry|
              case entry
              when /^ジャンル：(.+)/
                genre = $1
              when /^キーワード：(.+)\s*$/
                keywords = $1.split
              end
            end
          end
          entry = {
            :ncode => ncode.downcase,
            :status => status,
            :genre => genre,
            :keywords => keywords,
            :title => title,
            :mypage => mypage,
            :writer => writer,
            :bookmark => bookmark,
            :count => count
          }
          entry.merge!(send("extract_#{category}_properties", div))
          dat[ncode.downcase] = entry
        end
        dat
      end

      def extract_nopointlist_properties(div)
        data = {}
        div.xpath("div[3]").each do |div|
          div.text.split("\n").each do |item|
            case item
            when /文字数：([0-9,]+)/
              data[:chars] = $1.delete(',').to_i
            when /ブックマーク：(\d+)/
              data[:bookmark] = $1.to_i
            when /レビュー：(\d+)/
              data[:review] = $1.to_i
            when /感想：(\d+)/
              data[:impression] = $1.to_i
            end
          end
        end
        data
      end

      def extract_noimpressionlist_properties(div)
        data = {}
        div.xpath("div[3]").each do |div|
          div.text.split("\r\n").each do |item|
            case item
            when /文字数：([0-9,]+)/
              data[:chars] = $1.delete(',').to_i
            end
          end
          div.children.map do |element|
            case element.text.delete("\r\n")
            when /ブックマーク：(\d+)/
              data[:bookmark] = $1.to_i
            when /レビュー：(\d+)/
              data[:review] = $1.to_i
            when /感想：(\d+)/
              data[:impression] = $1.to_i
            when /評価点：(\d+)/
              data[:all_point] = $1.to_i
            when /評価人数：(\d+)/
              data[:all_hyoka_count] = $1.to_i
            when /総合評価ポイント：(\d+)/
              data[:global_point] = $1.to_i
            end
          end
        end
        data
      end
    end
  end
end
