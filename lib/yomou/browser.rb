require 'mechanize'
require 'yaml'

module Yomou

  class Browser

    def initialize
      @agent = Mechanize.new
      @agent.user_agent = 'Narou Browser'

      @conf = Yomou::Config.new
      unless File.exist?(@conf.ca_file)
        p "CA file is not found"
      end
    end

    def login(id = nil, password = nil)
      unless id
        id = @conf.id
      end
      unless password
        password = @conf.password
      end

      @agent.ca_file = @conf.ca_file
      page = @agent.get('https://ssl.syosetu.com/login/input/')
      next_page = page.form_with do |form|
        form.id = id
        form.pass = password
      end.submit
      p next_page.title()
    end

    def add_bookmark(ncode, episode = 1)
      url = "http://ncode.syosetu.com/#{ncode.downcase}/#{episode}/"
      page = @agent.get(url)
      p url
      page.search("li[class='booklist']/a").each do |a|
        url = a.attribute('href').text
        next_page = @agent.get(url)
        p next_page.title()
      end
    end

    def delete_bookmark(ncode, episode)
      url = "http://ncode.syosetu.com/#{ncode.downcase}/#{episode}/"
      page = @agent.get(url)
      p url
      page.search("li[class='booklist_now']/a").each do |a|
        url = a.attribute('href').text
        next_page = @agent.get(url)
        p next_page.title()
        next_page.search("input[name='token']").each do |input|
          token = input.attribute('value').text
          p token
          url = "http://syosetu.com/favnovelmain/delete"
          params = {
            token: token
          }
          @agent.post(url, params)
        end
      end
    end
  end
end
