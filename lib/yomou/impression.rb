module Yomou
  module Impression

    class PageParser

      attr_accessor :cache_path

      def initialize(ncode)
        @conf = Yomou::Config.new
        sub_directory = ncode[1..2]
        @cache_path = pathname_expanded([@conf.directory,
                                         "impression",
                                         sub_directory,
                                         "#{ncode.downcase}.yaml.xz"])
      end

      def cached?
        @cache_path.exist? and
          @cache_path.mtime > Time.now - YOMOU_SYNC_INTERVAL_WEEK
      end

      def cache
        data = []
        if @cache_path.exist?
          data = yaml_xz(@cache_path.to_s)
        end
        data
      end
    end
  end
end
