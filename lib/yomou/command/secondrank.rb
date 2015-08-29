require "open-uri"
require "nokogiri"

require "yomou/secondrank/daily"
require "yomou/secondrank/weekly"
require "yomou/secondrank/monthly"
require "yomou/secondrank/quarter"
require "yomou/secondrank/yearly"

module Yomou
  module SecondRankapi

    class SecondRank < Thor

      desc "daily [OPTIONS]", ""
      subcommand "daily", Yomou::SecondRankapi::Daily

      desc "weekly [OPTIONS]", ""
      subcommand "weekly", Yomou::SecondRankapi::Weekly

      desc "monthly [OPTIONS]", ""
      subcommand "monthly", Yomou::SecondRankapi::Monthly

      desc "quarter [OPTIONS]", ""
      subcommand "quarter", Yomou::SecondRankapi::Quarter

      desc "yearly [OPTIONS]", ""
      subcommand "yearly", Yomou::SecondRankapi::Yearly

    end
  end
end
