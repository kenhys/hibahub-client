require "thor"
require "yomou/version"
require "yomou/init"
require "yomou/import"
require "yomou/command/list"
require "yomou/downloader"
require "yomou/novelapi"
require "yomou/command/rankapi"
require "yomou/command/rankingapi"
require "yomou/update"
require "yomou/userapi"
require "yomou/command/secondrank"
require "yomou/atomapi"

module Yomou
  class Command < Thor

    desc "init [SUBCOMMAND]", "Initialize cofiguration"
    subcommand "init", Yomou::Init

    desc "rank [SUBCOMMAND]", "Get rank data"
    subcommand "rank", Rankapi::Rank

    desc "secondrank [SUBCOMMAND]", ""
    subcommand "secondrank", SecondRankapi::SecondRank

    desc "novel [SUBCOMMAND]", "Get novel data"
    subcommand "novel", Novelapi::Novel

    desc "import [SUBCOMMAND]", "Import external data"
    subcommand "import", Yomou::Import

    desc "update [SUBCOMMAND]", "Update external data"
    subcommand "update", Yomou::Update

    desc "user [SUBCOMMAND]", ""
    subcommand "user", Userapi::User

    desc "atom [OPTIONS]", ""
    subcommand "atom", Yomou::Atomapi::Atom

  end
end
