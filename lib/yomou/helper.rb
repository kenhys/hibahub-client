require "open-uri"
require "zlib"

module Yomou
  module Helper

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
      open(url) do |context|
        File.open(path.to_s, "w+") do |file|
          if options[:gzip]
            gz = Zlib.GzipWriter.new(file)
            gz.puts(context.read)
          else
            file.puts(context.read)
          end
        end
      end
      sleep YOMOU_REQUEST_INTERVAL_MSEC
    end

    def open_database(path)
      Groonga::Context.default_options = {:encoding => :utf8}
      Groonga::Database.open(path)
    end

  end
end
