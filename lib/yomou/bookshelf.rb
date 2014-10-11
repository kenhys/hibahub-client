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

    def ncodes_from_realpath
      Dir.chdir(File.expand_path(@conf.directory)) do
        `find . -maxdepth 3 -name 'n[0-9]*'`.split.each do |entry|
          if entry =~ /\/(n.+)$/
            ncode = $1
            p ncode
            ncodes << ncode
          end
        end
      end
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
        unless novels.has_key?(ncode.upcase)
          p "register ncode:#{ncode.upcase}"
          status = YOMOU_NOVEL_NONE
          status = options[:status] if options.has_key?(:status)
          novels.add(ncode.upcase,
                     :yomou_status => status,
                     :yomou_sync_interval => YOMOU_SYNC_INTERVAL,
                     :yomou_sync_schedule => Time.now + YOMOU_SYNC_INTERVAL)
        else
          print "skip #{ncode.upcase}"
        end
      end
    end

    def update_status(ncode, status)
      p "update #{ncode}"
      novels = Groonga["NarouNovels"]
      novels[ncode].yomou_status = status
      novels[ncode].yomou_sync_schedule = Time.now + YOMOU_SYNC_INTERVAL
    end

  end
end
