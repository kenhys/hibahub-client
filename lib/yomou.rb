require "thor"
require "yomou/version"
require "yomou/init"
require "yomou/import"
require "yomou/downloader"
require "yomou/novelapi"
require "yomou/rankapi"
require "yomou/rankinapi"

module Yomou
  class Command < Thor

    desc "init [SUBCOMMAND]", "Initialize cofiguration"
    subcommand "init", Yomou::Init

    desc "rank [SUBCOMMAND]", "Get rank data"
    subcommand "rank", Rankapi::Rank

    desc "novel [SUBCOMMAND]", "Get novel data"
    subcommand "novel", Novelapi::Novel

    desc "import [SUBCOMMAND]", "Import external data"
    subcommand "import", Yomou::Import

  end
end
