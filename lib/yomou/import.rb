require "grn_mini"
require "yomou/config"
require "yomou/helper"

module Yomou

  class Import < Thor

    include Yomou::Helper

    desc "blacklist", "Import missing ncode as blacklist"
    option :log
    option :quarter
    def blacklist
      @conf = Yomou::Config.new
      p options
      return unless File.exist?(options['log'])

      p "now"
      deleted = []
      open(options['log'], "r") do |file|
        file.read.each_line do |line|
          if line =~ /.+syosetu\.com\/(.+)\//
            deleted << $1
          end
        end
      end
      p deleted
      path = Pathname.new(File.join(@conf.directory,
                                    "rankapi/quarter",
                                    "#{options['quarter']}-q.yaml.gz"))
      p path
      entries = yaml_gz(path.to_s)
    end

    desc "rank", "Import ranking data"
    option :log
    option :term
    def rank
      @conf = Yomou::Config.new

      term = options["term"]
      periods = []
      case term
      when "quarter"
        periods = quarter_periods
      when "monthly"
        periods = monthly_periods
      when "weekly"
        periods = weekly_periods
      when "daily"
        periods = daily_periods
      end

      periods.each do |period|
        relative_path = ""
        ymd = period.strftime("%Y%m%d")
        case term
        when "quarter"
          relative_path = "rankapi/#{term}/" + period.strftime("#{ymd}-q.yaml.gz")
        when "monthly"
          relative_path = "rankapi/#{term}/" + period.strftime("#{ymd}-m.yaml.gz")
        when "weekly"
          relative_path = "rankapi/#{term}/" + period.strftime("%Y/#{ymd}-w.yaml.gz")
        when "daily"
          relative_path = "rankapi/#{term}/" + period.strftime("%Y/%m/#{ymd}-d.yaml.gz")
        end
        path = Pathname.new(File.join(@conf.directory,
                                      relative_path))
        p path
        entries = yaml_gz(path.to_s)
        next if entries.empty?

        path = Pathname.new(@conf.database)
        FileUtils.mkdir_p(path.dirname)
        GrnMini::create_or_open(@conf.database)
        table = "#{term.capitalize}Ranking"
        p table
        array = GrnMini::Array.new(table)
        p array.size

        next if array.size > 0 and array.select("date:#{ymd}").size > 0

        p period
        entries.each do |entry|
          array << {
            date: ymd,
            ncode: entry["ncode"],
            pt: entry["pt"],
            rank: entry["rank"],
            delete: false
          }
        end
        p array.size
      end
    end
  end
end
