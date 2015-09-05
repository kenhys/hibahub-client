require "open-uri"
require "nokogiri"

require "yomou/command/secondrank/daily"
require "yomou/command/secondrank/weekly"
require "yomou/command/secondrank/monthly"
require "yomou/command/secondrank/quarter"
require "yomou/command/secondrank/yearly"

module Yomou
  module Command

    class SecondRank < Thor
      namespace :secondrank

      desc "daily [OPTIONS]", ""
      subcommand "daily", SecondRankapi::Daily

      desc "weekly [OPTIONS]", ""
      subcommand "weekly", SecondRankapi::Weekly

      desc "monthly [OPTIONS]", ""
      subcommand "monthly", SecondRankapi::Monthly

      desc "quarter [OPTIONS]", ""
      subcommand "quarter", SecondRankapi::Quarter

      desc "yearly [OPTIONS]", ""
      subcommand "yearly", SecondRankapi::Yearly

    end
  end
end
