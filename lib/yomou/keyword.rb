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

      def load_keywords
        unless @keywords_path.exist?
          download
        end
        @keywords = yaml_xz(@keywords_path)
      end

      def novels_with_keyword(keyword)
        load_keywords
        unless @keywords.has_key?(keyword)
          return
        end
        index = @keywords[keyword]
        params = {
          "keyword" => keyword,
          "id" => index
        }
        @agent = KeywordSearcher.new(params)
        @agent.last_page = 10
        @agent.crawl
      end
    end

    class KeywordSearcher
      attr_accessor :keyword
      attr_accessor :page
      attr_accessor :last_page

      include Yomou::Helper

      def initialize(params)
        @conf = Yomou::Config.new
        @keyword = params["keyword"]
        @id = params["id"]
        url = sprintf("%s?word=%s&order=hyoka&p=1",
                      "http://yomou.syosetu.com/search.php",
                      URI.escape(keyword))
        @page = 1
        open(url) do |context|
          doc = Nokogiri::HTML.parse(context.read)
          doc.xpath("//div[@id='main_search']/b").each do |b|
            total = b.text.delete(',').to_i
            @last_page = (total - 1) / 20 + 1
          end
          p @last_page
        end
      end

      def crawl
        page = @page
        until page > @last_page
          url = sprintf("%s?word=%s&order=hyoka&p=#{page}",
                        "http://yomou.syosetu.com/search.php",
                        URI.escape(@keyword))
          path = pathname_expanded([@conf.directory,
                                    "keyword",
                                    @id.to_s,
                                    "#{page}.html.xz"])
          p url
          p path
          save_as(url, path, {:compress => true})
          page = page + 1
          sleep YOMOU_REQUEST_INTERVAL_MSEC
        end
      end

      def makecache
        page = 1
        until page > @last_page
        end
      end
    end
  end
end
