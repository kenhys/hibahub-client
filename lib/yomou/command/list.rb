module Yomou

  class Command < Thor

    include Yomou::Helper

    desc "list", ""
    def list
      @conf = Yomou::Config.new

      Groonga::Context.default_options = {:encoding => :utf8}
      return unless File.exist?(@conf.database)
      Groonga::Database.open(@conf.database)

      novels = Groonga["NarouNovels"]
      records = novels.select do |record|
        record.yomou_status != YOMOU_NOVEL_DELETED
      end

      records.each do |record|
        printf("%7d %s:%s\n", record._id, record._key, record.title)
      end
    end

  end
end
