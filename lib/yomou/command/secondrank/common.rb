# coding: utf-8
module Yomou
  module SecondRankapi
    module Common

      BASE_URL = "http://yomou.syosetu.com/rank/secondlist/type"

      def extract_rank_h(path)
        entries = []
        open(path) do |context|
          doc = Nokogiri::HTML.parse(context.read, nil, nil)
          doc.xpath("//div[@class='rank_h']").each do |div|
            node = div.xpath("a[@class='tl']")
            title = node.text
            url = node.attribute("href").text
            ncode = nil
            if url =~ /syosetu\.com\/(.+)\//
              ncode = $1
            end
            next unless ncode

            node = div.xpath("span[@class='name']")
            name = node.text.split("：")[1]
            mypage = node.xpath("a").attribute("href").text

            if div.xpath("a[2]").attribute("href").text =~ /genre=(\d+)/
              genre = $1.to_i
            end
            entries << {
              "ncode" => ncode.downcase,
              "url" => url,
              "title" => title,
              "name" => name,
              "mypage" => mypage,
              "genre" => genre
            }
          end

          rank = 0
          doc.xpath("//table[@class='rank_table']").each do |table|
            table.xpath("tr[1]/td[1]").each do |td|
              td.xpath("span[@class='attention']").each do |span|
                entries[rank]["pt"] = span.text.delete("pt").to_i
                entries[rank]["rank"] = rank + 1
              end
            end
            properties = table.xpath("tr[1]/td[@class='left']").text.split
            case properties.count
            when 2
              episodes = 1
            when 3
              if properties[2] =~ /(\d+)/
                episodes = $1.to_i
              end
            end
            entries[rank]["episodes"] = episodes
            table.xpath("tr[2]/td[@class='s']").each do |td|
              keywords = td.xpath("a").collect do |a|
                a.text
              end
              entries[rank]["keywords"] = keywords
            end
            rank = rank + 1
          end

        end
        entries
      end

    end
  end
end
