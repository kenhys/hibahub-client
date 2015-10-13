module Yomou
  module NovelInfo

    class PageParser

      attr_accessor :cache_path

      include Yomou::Helper

      def initialize(ncode)
        @conf = Yomou::Config.new
        @cache_path = pathname_expanded([@conf.directory,
                                         'info',
                                         ncode.slice(1,2),
                                         "#{ncode.downcase}.html.xz"])
      end
    end
  end
end
