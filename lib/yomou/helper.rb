# coding: utf-8
require 'open-uri'
require 'zlib'
require 'xz'
require 'tempfile'

module Yomou
  module Helper

    YOMOU_GENRE_TABLE = {
      "文学" => 1,
      "恋愛" => 2,
      "歴史" => 3,
      "推理" => 4,
      "ファンタジー" => 5,
      "SF" => 6,
      "ホラー" => 7,
      "コメディー" => 8,
      "冒険" => 9,
      "学園" => 10,
      "戦記" => 11,
      "童話" => 12,
      "詩" => 13,
      "エッセイ" => 14,
      "リプレイ" => 16,
      "その他" => 15,
    }

    def quarter_periods
      d = Date.new(2013, 5, 1)
      periods = []
      while d < Date.today
        periods << d
        d = d.next_month
      end
      periods
    end

    def monthly_periods
      quarter_periods
    end

    def weekly_periods
      d = Date.new(2013, 5, 7)
      periods = []
      while d < Date.today
        periods << d
        d = d.next_day(7)
      end
      periods
    end

    def daily_periods
      d = Date.new(2013, 5, 7)
      periods = []
      while d < Date.today
        periods << d
        d = d.next_day
      end
      periods
    end

    def extract_ncode_from_url(url)
      url =~ /.+\/(n.+)\//
      $1
    end

    def pathname_expanded(paths)
      path = Pathname.new(File.expand_path(File.join(paths)))
      FileUtils.mkdir_p(path.dirname)
      path
    end

    def html(url)
      open(url) do |context|
        yield(Nokogiri::HTML.parse(context.read))
      end
    end

    def html_gz(path_or_url)
      if File.exists?(path_or_url)
        if path_or_url.end_with?(".gz")
          Zlib::GzipReader.open(path_or_url) do |gz|
            yield(Nokogiri::HTML.parse(gz.read))
          end
        else
          open(path_or_url) do |context|
            yield(Nokogiri::HTML.parse(context.read))
          end
        end
      end
    end

    def html_xz(path_or_url)
      if File.exists?(path_or_url)
        open(path_or_url) do |context|
          data = XZ.decompress(context.read)
          yield(Nokogiri::HTML.parse(data))
        end
      end
    end

    def yaml_gz(path_or_url)
      entries = []
      begin
        if File.exists?(path_or_url)
          Zlib::GzipReader.open(path_or_url) do |gz|
            entries = YAML.load(gz.read)
          end
        else
          open(path_or_url) do |context|
            io = StringIO.new(context.read)
            Zlib::GzipReader.wrap(io) do |gz|
              entries = YAML.load(gz.read)
            end
          end
        end
      rescue Zlib::GzipFile::Error
      end
      entries
    end

    def yaml_xz(path_or_url)
      entries = []
      begin
        if File.exists?(path_or_url)
          open(path_or_url) do |context|
            data = XZ.decompress(context.read)
            entries = YAML.load(data)
          end
        end
      end
      entries
    end

    def genre_codes
      (1..15).to_a
    end

    def extract_codes_from_argument(arg)
      codes = arg || genre_codes
      if codes.is_a?(String)
        if codes =~ /(\d+)\.\.(\d+)/
          codes = eval("#{$1}.upto(#{$2})").each.collect do |i|
            i
          end
        else
          codes = arg.split(",").collect do |code|
            code.to_i
          end
        end
      end
      codes
    end

    def save_as(url, path,
                options = {:within_seconds => YOMOU_SYNC_INTERVAL_WEEK})
      within_seconds = YOMOU_SYNC_INTERVAL_WEEK
      within_seconds = options[:within_seconds] if options[:within_seconds]
      if path.exist?
        if path.mtime > Time.now - within_seconds
          return
        end
      end
      FileUtils.mkdir_p(path.dirname)
      succeed = false
      until succeed
        begin
          open(url) do |context|
            File.open(path.to_s, "w+") do |file|
              if options[:compress]
                if path.to_s.end_with?(".gz")
                  gz = Zlib::GzipWriter.new(file, Zlib::BEST_COMPRESSION)
                  gz.puts(context.read)
                  gz.close
                elsif path.to_s.end_with?(".xz")
                  file.puts(XZ.compress(context.read))
                end
              else
                file.puts(context.read)
              end
            end
          end
          succeed = true
        rescue OpenURI::HTTPError
          p "wait to retry"
        rescue Errno::ETIMEDOUT
          p "wait to retry"
        ensure
          sleep YOMOU_REQUEST_INTERVAL_MSEC
        end
      end
    end

    def open_database(path)
      Groonga::Context.default_options = {:encoding => :utf8}
      Groonga::Database.open(path)
    end

    def archive(data, path)
      FileUtils.mkdir_p(path.dirname)
      if path.to_s.end_with?(".gz")
        archive_gzip(data, path.to_s)
      elsif path.to_s.end_with?(".xz")
        archive_xz(data, path.to_s)
      else
        File.open(path.to_s, "w+") do |file|
          file.puts(YAML.dump(data))
        end
      end
    end

    def archive_gzip(data, path)
      Zlib::GzipWriter.open(path) do |gzip|
        gzip.write(YAML.dump(data))
      end
    end

    def archive_xz(data, path)
      ::Tempfile.create("raw") do |f|
        f.write(YAML.dump(data))
        XZ.compress_file(f.path, path)
      end
    end

    def yyyymmdd
      Date.today.strftime("%Y%m%d")
    end

    def guard(&block)
      open('LOCK', 'w') do |file|
        begin
          locked = false
          while not locked
            print "w"
            locked = file.flock(File::LOCK_EX | File::LOCK_NB)
            sleep 1
          end
          p "lock"
          block.call
        ensure
          p "unlock"
          file.flock(File::LOCK_UN)
        end
      end
      if File.exist?('LOCK')
        File.delete('LOCK')
      end
    end
  end
end
