require "grn_mini"
require "yomou/config"
require "yomou/helper"
require "groonga"

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

      path = Pathname.new(@conf.database)
      FileUtils.mkdir_p(path.dirname)
      p @conf.database

      Groonga::Context.default_options = {:encoding => :utf8}
      return unless File.exist?(@conf.database)
      Groonga::Database.open(@conf.database)

      table = Groonga["Narou#{term.capitalize}Ranking"]

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
        next unless path.exist?
        entries = yaml_gz(path.to_s)
        next if entries.empty?

        records = table.select do |record|
          record.date == Time.parse(ymd)
        end
        p records.size
        p ymd
        next if records.size > 0

        entries.each do |entry|
          pp entry
          table.add(:ncode => entry["ncode"],
                    :pt => entry["pt"],
                    :rank => entry["rank"],
                    :date => Time.parse(ymd))
        end
      end
    end
  end
end
