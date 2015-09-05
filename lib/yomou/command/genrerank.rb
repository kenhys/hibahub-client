require "yomou/command/genrerank/common"
require "yomou/command/genrerank/daily"
require "yomou/command/genrerank/weekly"
require "yomou/command/genrerank/monthly"
require "yomou/command/genrerank/quarter"
require "yomou/command/genrerank/yearly"

module Yomou
  module Command

    class GenreRank < Thor
      namespace :genrerank

      desc "daily [OPTIONS]", ""
      subcommand "daily", Yomou::GenreRankapi::Daily

      desc "weekly [OPTIONS]", ""
      subcommand "weekly", Yomou::GenreRankapi::Weekly

      desc "monthly [OPTIONS]", ""
      subcommand "monthly", Yomou::GenreRankapi::Monthly

      desc "quarter [OPTIONS]", ""
      subcommand "quarter", Yomou::GenreRankapi::Quarter

      desc "yearly [OPTIONS]", ""
      subcommand "yearly", Yomou::GenreRankapi::Yearly

    end
  end
end
