
module Yomou
  module Userapi

    class Bookmark < Thor

      desc "", ""
      def bookmark
      end

      def self.show(user_id, option = nil)
        collect_bookmark(user_id).each do |key,novel|
          printf("%8s: %s (%d)\n",
                 key, novel[:title], novel[:elements])
        end
      end

      def self.collect_bookmark(user_id)
        base_url = "http://mypage.syosetu.com/mypagefavnovelmain/list/userid"

        url = base_url + "/#{user_id}/"
        novels = {}
        open(url) do |context|
          doc = Nokogiri::HTML.parse(context.read)
          doc.xpath("//div[@id='main']").each do |div|

            total_page = 0
            div.xpath("div[@class='pager_kazu']").each do |div_pager|
              div_pager.text =~ /(\d+).+(\d+)/
              total_page = $1.to_i
            end

            div.xpath("div[@id='novellist']").each do |div_novellist|
              novels.merge!(parse_novellist(div_novellist))
            end
            if total_page > 1
              2.upto(total_page) do |n|
                pager_url = url + "index.php?p=#{n}"
                open(pager_url) do |pager_context|
                  page = Nokogiri::HTML.parse(pager_context.read)
                  page.xpath("//div[@id='novellist']").each do |div|
                    novels.merge!(parse_novellist(div))
                  end
                end
              end
            end

          end
        end
        novels
      end

      def self.parse_novellist(node)
        novels = {}
        node.xpath("ul").each do |ul|
          title = ""
          ncode = nil
          ul.xpath("li[@class='title']/a").each do |a|
            title = a.text
            if a.attribute("href").text =~ /.+\/(n.+)\//
              ncode = $1
              novels[ncode] = {
                :title => title,
              }
            end
          end
          ul.xpath("li[@class='date1']").each do |li|
            if li.text =~ /(\d+)/
              novels[ncode][:elements] = $1.to_i
            else
              novels[ncode][:elements] = 1
            end
          end
        end
        novels
      end

    end

  end
end
