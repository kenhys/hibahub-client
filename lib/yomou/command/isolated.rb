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

    end
  end
end
