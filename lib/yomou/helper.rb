require "open-uri"

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

    def save_as(url, path)
      if pathd.exist?
        if path.mtime > Time.now - 60 * 60 * 24
          return
        end
      end
      FileUtils.mkdir_p(path.dirname)
      open(url) do |context|
        File.open(path.to_s, "w+") do |file|
          file.puts(context.read)
        end
      end
    end

    def open_database(path)
      Groonga::Context.default_options = {:encoding => :utf8}
      Groonga::Database.open(path)
    end

  end
end
