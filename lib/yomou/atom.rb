require 'yomou/helper'
require 'yomou/config'
require 'feedjira'

module Yomou
  module Atom
    class Downloader
      include Yomou::Helper
      def initialize(options={})
        @conf = Yomou::Config.new
        @output = options[:output] || $stdout
      end

      def download(type="allnovel")
        types = ["allnovel", "noc_allnovel", "mnlt_allnovel"]
        @conf = Yomou::Config.new
        return unless types.include?(type)

        url = "http://api.syosetu.com/#{type}.Atom"
        feed = Feedjira::Feed.fetch_and_parse(url)
        sub_directory = Time.now.strftime("atomapi/%Y/%m/%d/#{type}-%H%M.Atom.yaml.xz")
        path = pathname_expanded([@conf.directory,
                                  sub_directory])
        @output.puts("download #{path.to_s}")
        archive(feed.to_yaml, path)
      end
    end
  end
end
