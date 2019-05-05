require "find"

require "yomou/config"

module Yomou
  class NovelCleaner < BaseCleaner
    def initialize(options={})
      @options = options
      @output = options[:output] || $stdout
      @conf = Yomou::Config.new
    end

    def clean(base_path)
      clean_raw(base_path)
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
  end
end
