require "thor"
require "yomou/version"
require "yomou/novelapi"
require "yomou/rankapi"
require "yomou/rankinapi"

module Yomou
  module Novelapi
    class Command < Thor

      desc "init [SUBCOMMAND]", "Initialize cofiguration"
      subcommand "init", Init

    end
  end
end
