module Yomou

  class Bookshelf

    def initialize
      @conf = Yomou::Config.new

      Groonga::Context.default_options = {:encoding => :utf8}
      Groonga::Database.open(File.expand_path(@conf.database))
    end

    def ncode_exist?(ncode)
      novels = Groonga["NarouNovels"]
      novels.has_key?(ncode.upcase)
    end

    def register_ncode(ncode)
      novels = Groonga["NarouNovels"]
      ncodes = []
      if ncode.kind_of?(String)
        ncodes = [ncode]
      else
        ncodes = ncode
      end
      ncodes.each do |ncode|
        unless novels.has_key?(ncode.upcase)
          p "register ncode:#{ncode.upcase}"
          novels.add(ncode.upcase,
                     :yomou_status => YOMOU_NOVEL_NONE,
                     :yomou_sync_interval => YOMOU_SYNC_INTERVAL,
                     :yomou_sync_schedule => Time.now + YOMOU_SYNC_INTERVAL)
        end
      end
    end

  end
end
