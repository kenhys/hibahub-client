require "yomou/command/isolated"
require "yomou/command/secondrank"
require "yomou/command/genrerank"
require "yomou/command/atomapi"
require "yomou/command/rankapi"

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
      subcommand "novel", Novelapi::Novel

      desc "import [SUBCOMMAND]", "Import external data"
      subcommand "import", Yomou::Import

      desc "update [SUBCOMMAND]", "Update external data"
      subcommand "update", Yomou::Update

      desc "user [SUBCOMMAND]", ""
      subcommand "user", Userapi::User

      desc "atom [OPTIONS]", ""
      subcommand "atom", Atom

      desc "nopoint [OPTIONS]", ""
      subcommand "nopoint", Isolated::NoPoint

      desc "noimpression [OPTIONS]", ""
      subcommand "noimpression", Isolated::NoImpression
    end
  end
end
