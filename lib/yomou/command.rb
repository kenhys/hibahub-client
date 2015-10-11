require "yomou/command/isolated"
require "yomou/command/secondrank"
require "yomou/command/genrerank"
require "yomou/command/atomapi"
require "yomou/command/rankapi"
require "yomou/command/rankin"
require "yomou/command/list"
require "yomou/command/clean"
require "yomou/command/impression"
require "yomou/command/bookmark"
require "yomou/command/import"
require "yomou/command/user"
require "yomou/command/novel"

module Yomou
  module Command
    class Bootstrap < Thor

      desc "init [SUBCOMMAND]", "Initialize cofiguration"
      subcommand "init", Yomou::Init

      desc "rank [SUBCOMMAND]", "Get rank data"
      subcommand "rank", Rankapi::Rank

      desc "secondrank [SUBCOMMAND]", ""
      subcommand "secondrank", SecondRank

      desc "genrerank [SUBCOMMAND]", ""
      subcommand "genrerank", GenreRank

      desc "novel [SUBCOMMAND]", "Get novel data"
      subcommand "novel", Novel

      desc "import [SUBCOMMAND]", "Import external data"
      subcommand "import", Import

      desc "update [SUBCOMMAND]", "Update external data"
      subcommand "update", Yomou::Update

      desc "user [SUBCOMMAND]", ""
      subcommand "user", User

      desc "atom [OPTIONS]", ""
      subcommand "atom", Atom

      desc "nopoint [OPTIONS]", ""
      subcommand "nopoint", Isolated::NoPoint

      desc "noimpression [OPTIONS]", ""
      subcommand "noimpression", Isolated::NoImpression

      desc "impression [OPTIONS]", ""
      subcommand "impression", Impression

      desc "bookmark [OPTIONS]", ""
      subcommand "bookmark", Bookmark

      desc "rankin [SUBCOMMAND]", ""
      subcommand "rankin", RankIn
    end
  end
end
