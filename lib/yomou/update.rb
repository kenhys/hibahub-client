module Yomou

  class Update < Thor

    desc "blacklist", "Import missing ncode as blacklist"
    option :log
    option :quarter
    def blacklist
      @conf = Yomou::Config.new
      p options
      return unless File.exist?(options['log'])

      p "now"
      deleted = []
      open(options['log'], "r") do |file|
        file.read.each_line do |line|
          if line =~ /.+syosetu\.com\/(.+)\//
            deleted << $1
          end
        end
      end
      p deleted
      path = Pathname.new(File.join(@conf.directory,
                                    "blacklist.yaml"))
      entries = {}
      if path.exist?
        entries = YAML.load_file(path.to_s)
      end
      if entries.has_key?("ncodes")
        updates = deleted - entries["ncodes"]
        entries["ncodes"] = entries["ncodes"] + updates
      else
        updates = deleted
        entries["ncodes"] = updates
      end
      open(path.to_s, "w+") do |file|
        file.puts(YAML.dump({"ncodes" => entries["ncodes"]}))
      end
    end

    desc "downloaded", ""
    def downloaded
      @conf = Yomou::Config.new

      ncodes = []
      Dir.chdir(@conf.directory) do
        `find . -maxdepth 3 -name 'n[0-9]*'`.split.each do |entry|
          if entry =~ /\/(n.+)$/
            ncode = $1
            p ncode
            ncodes << ncode
          end
        end
      end

      return if ncodes.empty?

      Groonga::Context.default_options = {:encoding => :utf8}
      return unless File.exist?(@conf.database)
      Groonga::Database.open(@conf.database)

      novels = Groonga["NarouNovels"]
      p novels.size

      ncodes.each do |ncode|
        if novels.has_key?(ncode)
          p "update #{ncode}"
          novels[ncode].yomou_status = YOMOU_NOVEL_DOWNLOADED
          novels[ncode].yomou_sync_schedule = Time.now + YOMOU_SYNC_INTERVAL
        else
          novels.add(ncode.upcase,
                     :yomou_status => YOMOU_NOVEL_DOWNLOADED,
                     :yomou_sync_interval => YOMOU_SYNC_INTERVAL,
                     :yomou_sync_schedule => Time.now + YOMOU_SYNC_INTERVAL)
        end
      end
    end

  end
end
