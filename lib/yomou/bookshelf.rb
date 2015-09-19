module Yomou

  class Bookshelf

    def initialize
      @conf = Yomou::Config.new

      Groonga::Context.default_options = {:encoding => :utf8}
      Groonga::Database.open(File.expand_path(@conf.database))
    end

    def ncode_exist?(ncode)
      novels = Groonga["NarouNovels"]
      novels.has_key?(ncode.downcase)
    end

    def ncodes_from_realpath
      ncodes = []
      Dir.chdir(File.expand_path(@conf.directory)) do
        `find . -maxdepth 3 -name 'n[0-9]*'`.split.each do |entry|
          if entry =~ /\/(n.+)$/
            ncode = $1
            p ncode
            ncodes << ncode
          end
        end
      end
      ncodes
    end

    def register_ncode(ncode, options = {})
      novels = Groonga["NarouNovels"]
      ncodes = []
      if ncode.kind_of?(String)
        ncodes = [ncode]
      else
        ncodes = ncode
      end
      ncodes.each do |ncode|
        unless novels.has_key?(ncode.downcase)
          p "register ncode:#{ncode.downcase}"
          status = YOMOU_NOVEL_NONE
          status = options[:yomou_status] if options.has_key?(:yomou_status)
          novels.add(ncode.downcase,
                     :yomou_status => status,
                     :yomou_sync_interval => YOMOU_SYNC_INTERVAL,
                     :yomou_sync_schedule => Time.now + YOMOU_SYNC_INTERVAL)
        else
          print "skip #{ncode.downcase}" if options[:verbose]
        end
      end
    end

    def update_status(ncode, status)
      p "update #{ncode}"
      novels = Groonga["NarouNovels"]
      if novels.has_key?(ncode)
        novels[ncode.downcase].yomou_status = status
        novels[ncode.downcase].yomou_sync_schedule = Time.now + YOMOU_SYNC_INTERVAL
      else
        novels.add(ncode.downcase,
                   :yomou_status => status,
                   :yomou_sync_interval => YOMOU_SYNC_INTERVAL,
                   :yomou_sync_schedule => Time.now + YOMOU_SYNC_INTERVAL)
      end
    end

  end
end
