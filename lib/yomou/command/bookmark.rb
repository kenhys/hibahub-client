# coding: utf-8
module Yomou
  module Command
    class Bookmark < Thor
      namespace :bookmark

      include Yomou::Helper

      desc "add", ""
      def add(ncode, episode = 1)
        @browser = Yomou::Browser.new
        @browser.login
        @browser.add_bookmark(ncode, episode)
      end
    end
  end
end
