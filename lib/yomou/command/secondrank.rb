require "open-uri"
require "nokogiri"

require "yomou/command/secondrank/daily"
require "yomou/command/secondrank/weekly"
require "yomou/command/secondrank/monthly"
require "yomou/command/secondrank/quarter"
require "yomou/command/secondrank/yearly"

module Yomou
  module SecondRankapi

    class SecondRank < Thor
      namespace :secondrank

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
