module Yomou
  module SecondRankapi
    module Common

      BASE_URL = "http://yomou.syosetu.com/rank/secondlist/type"

      def extract_rank_h(path)
        entries = []
        File.open(path.to_s, "r") do |file|
          doc = Nokogiri::HTML.parse(file.read, nil, nil)
          doc.xpath("//div[@class='rank_h']").each do |div|
            node = div.xpath("a[@class='tl']")
            title = node.text
            url = node.attribute("href").text
            ncode = nil
            if url =~ /syosetu\.com\/(.+)\//
              ncode = $1
            end
            next unless ncode

            entries << {
              "ncode" => ncode.upcase,
              "url" => url,
              "title" => title,
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
            rank = rank + 1
          end

        end
        entries
      end

    end
  end
end
