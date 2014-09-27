require "open-uri"

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
=begin
        path = Pathname.new(File.join(@conf.directory,
                                      "userapi",
                                      id,
                                      "novellist.html"))

        save_as(url, path)
=end
        p url
        ncodes = []
        open(url) do |context|
          doc = Nokogiri::HTML.parse(context.read)
          doc.xpath("//div[@id='novellist']/ul").each do |ul|
            ul.xpath("li[@class='title']/a").each do |a|
              p a.attribute("href").text
              if a.attribute("href").text =~ /.+\/(n.+)\//
                ncodes << $1
              end
            end
          end
        end
        p ncodes
        Yomou::Narou::Downloader.new.download(ncodes)
      end

    end
  end
end
