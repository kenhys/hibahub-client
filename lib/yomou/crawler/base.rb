# frozen_string_literal: true

require "yomou/helper"

module Yomou
  class BaseCrawler
    include Yomou::Helper
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
