module Yomou
  module Userapi

    class Novellist < Thor

      desc "", ""
      def novellist
      end

      def self.show(user_id)
        collect_novellist(user_id).each do |key,novel|
          printf("%8s: %s (%d)\n",
                 novel[:ncode], novel[:title], novel[:elements])
        end

      end

      def self.collect_novellist(user_id, option = nil)

        types = option || ["ter", "er", "re", "r", "t"]
        base_url = "http://mypage.syosetu.com/mypage/novellist/userid"

        url = base_url + "/#{user_id}/"
        novels = {}
        open(url) do |context|
          doc = Nokogiri::HTML.parse(context.read)
          doc.xpath("//div[@id='novellist']/ul").each do |ul|
            title = ""
            ncode = nil
            ul.xpath("li[@class='title']/a").each do |a|
              title = a.text
              if a.attribute("href").text =~ /.+\/(n.+)\//
                ncode = $1
                novels[ncode] = {
                  :ncode => ncode,
                  :title => title,
                }
              end
            end
            ul.xpath("li[@class='date1']").each do |li|
              li.text =~ /(\d+)/
              novels[ncode][:elements] = $1
            end
          end
        end
        novels
      end

    end

  end
end
