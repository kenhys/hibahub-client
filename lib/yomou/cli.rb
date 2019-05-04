# frozen_string_literal: true

require 'thor'

module Yomou
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'yomou version'
    def version
      require_relative 'version'
      puts "v#{Yomou::VERSION}"
    end
    map %w(--version -v) => :version

    require_relative 'commands/isekairank'
    register Yomou::Commands::Isekairank, 'isekairank', 'isekairank [SUBCOMMAND]', 'Command description...'

    require_relative 'commands/blacklist'
    register Yomou::Commands::Blacklist, 'blacklist', 'blacklist [SUBCOMMAND]', 'Command description...'

    require_relative 'commands/avgranklist'
    register Yomou::Commands::Avgranklist, 'avgranklist', 'avgranklist [SUBCOMMAND]', 'Command description...'

    require_relative 'commands/noimpressionlist'
    register Yomou::Commands::Noimpressionlist, 'noimpressionlist', 'noimpressionlist [SUBCOMMAND]', 'Command description...'

    require_relative 'commands/nopointlist'
    register Yomou::Commands::Nopointlist, 'nopointlist', 'nopointlist [SUBCOMMAND]', 'Command description...'

    require_relative 'commands/atom'
    register Yomou::Commands::Atom, 'atom', 'atom [SUBCOMMAND]', 'Command description...'

    require_relative 'commands/import'
    register Yomou::Commands::Import, 'import', 'import [SUBCOMMAND]', 'Command description...'

    require_relative 'commands/genrerank'
    register Yomou::Commands::Genrerank, 'genrerank', 'genrerank [SUBCOMMAND]', 'Command description...'

    require_relative 'commands/secondrank'
    register Yomou::Commands::Secondrank, 'secondrank', 'secondrank [SUBCOMMAND]', 'Command description...'

    require_relative 'commands/rank'
    register Yomou::Commands::Rank, 'rank', 'rank [SUBCOMMAND]', 'List daily ranking'

    require_relative 'commands/init'
    register Yomou::Commands::Init, 'init', 'init [SUBCOMMAND]', 'Initialize configuration'
  end
end
