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

    def yaml_gz(path)
      entries = []
      Zlib::GzipReader.open(path) do |gz|
        entries = YAML.load(gz.read)
      end
      entries
    end

    def genre_codes
      (1..15).to_a
    end

    def save_as(url, path)
      FileUtils.mkdir_p(path.dirname)
      open(url) do |context|
        File.open(path.to_s, "w+") do |file|
          file.puts(context.read)
        end
      end
    end

  end
end
