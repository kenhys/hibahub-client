module Yomou
  module NovelInfo

    class PageParser

      INFO_URL = 'http://ncode.syosetu.com/novelview/infotop/ncode/'

      attr_accessor :cache_path, :url

      include Yomou::Helper

      def initialize(ncode)
        @conf = Yomou::Config.new
        @cache_path = pathname_expanded([@conf.directory,
                                         'info',
                                         ncode.slice(1,2),
                                         "#{ncode.downcase}.html.xz"])
        @url = INFO_URL + ncode.dwoncase + '/'
      end
    end
  end
end
