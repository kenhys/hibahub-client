require "open-uri"
require "yomou/userapi/command"

module Yomou
  module Userapi

    # This is unofficial dummy api

    class User < Thor

      include Yomou::Helper

      desc "novellist", ""
      def novellist(id, arg = nil)
        @conf = Yomou::Config.new

        types = arg || ["ter", "er", "re", "r", "t"]
        base_url = "http://mypage.syosetu.com/mypage/novellist/userid"

        url = base_url + "/#{id}/"
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
        novels.each do |key,novel|
          printf("%8s: %s (%d)\n",
                 novel[:ncode], novel[:title], novel[:elements])
        end
      end

    end
  end
end
