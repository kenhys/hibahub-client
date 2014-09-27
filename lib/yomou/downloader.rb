module Yomou
  module Narou

    class Downloader

      def initialize
      end

      def glob_downloaded_ncodes
        @conf = Yomou::Config.new

        downloaded = []
        Dir.chdir(@conf.directory) do
          Dir.glob("#{@conf.narou_novel}/n*/") do |dir|
            ncode = Pathname.new(dir).basename.to_s.split(' ')[0]
            downloaded << ncode
          end
        end
        downloaded
      end

      def download(ncodes)
        succeeded = []
        failed = []
        Dir.chdir(@conf.directory) do
          ncodes.each do |ncode|
            if @downloaded.include?(ncode)
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

