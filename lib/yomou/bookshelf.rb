module Yomou

  class BookShelf

    def initialize
      @conf = Yomou::Config.new

      Groonga::Context.default_options = {:encoding => :utf8}
      Groonga::Database.open(@conf.database)
    end

    def ncode_exist?(ncode)
      novels = Groonga["NarouNovels"]
      novels.has_key?(ncode.upcase)
    end

  end
end
