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
          Dir.glob("#{@conf.narou_novel}/**/n*/") do |dir|
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
        ncode_group = ncode_groups(ncodes)
        100.times do |i|
          path = "#{@conf.directory}/narou/#{i}"
          group = nil
          if i < 10
            group = ncode_group["0#{i}"]
            path = "#{@conf.directory}/narou/0#{i}"
          else
            group = ncode_group["#{i}"]
          end
          target = group - downloaded
          novels = Groonga["NarouNovels"]
          Dir.chdir(path) do
            system("echo #{target.join(' ')} | xargs narou download --no-convert")
            code = $?
            if code == 0
              succeeded = target
            else
              count = 0
              target.each do |ncode|
                system("narou download --no-convert #{ncode}")
                if $? == 0
                  succeeded << ncode
                else
                  failed << ncode
                end
              end
            end
            if novels.has_key?(ncode)
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
        {
          :succeeded => succeeded,
          :failed => failed
        }
      end

      def ncode_groups(ncodes)
        ncodes.sort.each do |ncode|
          if ncode.downcase =~ /n(\d\d).+/
            sub_directory = $1
          end
          if ncode_group.has_key?(sub_directory)
            ncode_group[sub_directory] = ncode_group[sub_directory].push(ncode)
          else
            ncode_group[sub_directory] = [ncode]
          end
        end
      end
    end

  end
end

