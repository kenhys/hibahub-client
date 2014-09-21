module Yomou
  module Narou

    class Downloader

      def initialize
        @conf = Yomou::Config.new

        Dir.chdir(@conf.directory) do
          @downloaded = []
          Dir.glob("#{@conf.narou_novel}/n*/") do |dir|
            ncode = Pathname.new(dir).basename.to_s.split(' ')[0]
            @downloaded << ncode
          end
        end
      end

      def download(ncodes)
        Dir.chdir(@conf.directory) do
          ncodes.each do |ncode|
            if @downloaded.include?(ncode)
              puts "Already downloaded #{ncode}"
            else
              system("narou download --no-convert #{ncode}")
            end
          end
        end
      end
    end

  end
end

