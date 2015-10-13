module Yomou
  module Impression

    class PageParser

      attr_accessor :cache_path

      include Yomou::Config

      def initialize(ncode)
        sub_directory = ncode[1..2]
        @cache_path = pathname_expanded([@conf.directory,
                                         "impression",
                                         sub_directory,
                                         "#{ncode.downcase}.yaml.xz"])
      end

      def skip?
        @cache_path.exist? and
          @cache_path.mtime > Time.now - YOMOU_SYNC_INTERVAL_WEEK
      end
    end
  end
end
