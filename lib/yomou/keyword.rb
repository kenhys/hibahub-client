module Yomou
  module Keyword

    class KeywordList

      include Yomou::Helper

      attr_accessor :keywords

      def initialize
        @conf = Yomou::Config.new
        @keywords_path = pathname_expanded([@conf.directory,
                                            "keyword",
                                            "keywords.yaml.xz"])
        @classified_path = pathname_expanded([@conf.directory,
                                              "keyword",
                                              "classified.html.xz"])
      end

      def download
        @keywords = {}
        url = "http://yomou.syosetu.com/search/classified/"
        save_as(url, @classified_path, {:compress => true})
        html_xz(@classified_path.to_s) do |doc|
          doc.xpath("//div[@id='touroku']/div[@class='word']/a").each_with_index do |a,index|
            @keywords[a.text] = index + 1
          end
        end
        archive(@keywords, @keywords_path)
      end

    end
  end
end
