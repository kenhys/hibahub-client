module Yomou
  module Narou

    class Downloader

      def initialize
        @conf = Yomou::Config.new

        Groonga::Context.default_options = {:encoding => :utf8}
        if File.exist?(@conf.database)
          Groonga::Database.open(@conf.database)
        end
      end

      def glob_downloaded_ncodes
        downloaded = []
        Dir.chdir(@conf.directory) do
          Dir.glob("#{@conf.narou_novel}/n*/") do |dir|
            ncode = Pathname.new(dir).basename.to_s.split(' ')[0]
            downloaded << ncode
          end
        end
        downloaded
      end

      def downloaded_ncodes
        return [] unless File.exist?(@conf.database)

        novels = Groonga["NarouNovels"]
        p novels.size
        ncodes = []
        records = novels.select do |record|
          record.yomou_status == YOMOU_NOVEL_DOWNLOADED
        end
        records.each do |record|
          ncodes << record._key
        end
        ncodes
      end

      def download(ncodes)
        succeeded = []
        failed = []
        downloaded = downloaded_ncodes
        Dir.chdir(@conf.directory) do
          ncodes.each do |ncode|
            if downloaded.include?(ncode)
              puts "Already downloaded #{ncode}"
            else
              system("narou download --no-convert #{ncode}")
            end
          end
        end
        {
          :succeeded => succeeded,
          :failed => failed
        }
      end
    end

  end
end

