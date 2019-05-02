module Yomou
  module Clawer
    class BaseCrawler
      def extract_total_novels(doc)
        total = 0
        doc.xpath("//div[@class='site_h2']").each do |div|
          div.text =~ /.+?(\d+)/
          total = $1.to_i
        end
        total
      end
    end
  end
end
