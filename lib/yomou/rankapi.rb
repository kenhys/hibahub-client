require "zlib"
require "pathname"
require "pp"
require "yomou/rankapi/daily"
require "yomou/rankapi/weekly"
require "yomou/rankapi/monthly"
require "yomou/rankapi/quarter"

module Yomou
  module Rankapi

    BASE_URL = "http://api.syosetu.com/rank/rankget"

    class Rank < Thor
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
