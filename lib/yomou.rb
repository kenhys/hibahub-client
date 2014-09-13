require "thor"
require "yomou/version"
require "yomou/init"
require "yomou/novelapi"
require "yomou/rankapi"
require "yomou/rankinapi"

module Yomou
  class Command < Thor

    desc "init [SUBCOMMAND]", "Initialize cofiguration"
    subcommand "init", Yomou::Init

    desc "rank [SUBCOMMAND]", "Get rank data"
    subcommand "rank", Rankapi::Rank

  end
end
