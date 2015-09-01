require "zlib"
require "pathname"
require "pp"
require "yomou/command/rankapi/daily"
require "yomou/command/rankapi/weekly"
require "yomou/command/rankapi/monthly"
require "yomou/command/rankapi/quarter"

module Yomou
  module Rankapi

    BASE_URL = "http://api.syosetu.com/rank/rankget"

    class Rank < Thor
      namespace :rank

      desc "daily [OPTIONS]", ""
      subcommand "daily", Yomou::Rankapi::Daily

      desc "weekly [OPTIONS]", ""
      subcommand "weekly", Yomou::Rankapi::Weekly

      desc "monthly [OPTIONS]", ""
      subcommand "monthly", Yomou::Rankapi::Monthly

      desc "quarter [OPTIONS]", ""
      subcommand "quarter", Yomou::Rankapi::Quarter
    end

  end
end
