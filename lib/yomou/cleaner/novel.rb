require "find"

require "yomou/config"

module Yomou
  class NovelCleaner < BaseCleaner
    def initialize(options={})
      @options = options
      @output = options[:output] || $stdout
      @conf = Yomou::Config.new
    end

    def clean(type_or_base_path)
      if ["raw", "blacklist"].include?(type_or_base_path)
        case type_or_base_path
        when "raw"
        when "blacklist"
          clean_blacklist
        end
      else
        clean_raw(type_or_base_path)
      end
    end

    private

    def clean_raw(base_path)
      Find.find(base_path) do |fpath|
        if fpath.end_with?("raw")
          @output.puts("remove #{fpath}")
          FileUtils.remove_entry_secure(fpath)
        end
      end
    end

    def clean_blacklist
      yaml = YAML.load_file(blacklist_path)
      yaml[:ncodes].each do |ncode|
        if ncode =~ /\An(\d\d).+/
          seq = $1
          dir = format("%<base>s/narou/%<seq>s", base: @conf.directory, seq: seq)
          Dir.chdir(dir) do
            pattern = "#{@conf.narou_novel}/#{ncode}*"
            Dir.glob(pattern) do |directory|
              @output.puts("remove #{ncode}")
              `narou remove #{ncode} --with-file`
            end
          end
        end
      end
    end

    def blacklist_path
      File.join(@conf.directory, "blacklist.yaml")
    end
  end
end
