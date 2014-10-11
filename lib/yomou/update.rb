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

    desc "novel [status]", ""
    def novel(arg = nil)
      @conf = Yomou::Config.new

      bookshelf = Yomou::Bookshelf.new

      case arg
      when "status"
        ncodes = bookshelf.ncodes_from_realpath
        return if ncodes.empty?

        ncodes.each do |ncode|
          if bookshelf.ncode_exist?(ncode)
            bookshelf.update_status(ncode, YOMOU_NOVEL_DOWNLOADED)
          else
            bookshelf.register_ncode(ncode, {:status => YOMOU_NOVEL_DOWNLOADED})
          end
        end
      end
    end

  end
end
