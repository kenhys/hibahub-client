# frozen_string_literal: true

require 'thor'

module Yomou
  module Commands
    class Import < Thor

      namespace :import

      desc 'novel [NCODE]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def novel(ncode=nil)
        if options[:help]
          invoke :help, ['novel']
        else
          require_relative 'import/novel'
          Yomou::Commands::Import::Novel.new(ncode, options).execute
        end
      end

      desc 'rank [PERIOD]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def rank(period=nil)
        if options[:help]
          invoke :help, ['rank']
        else
          require_relative 'import/rank'
          Yomou::Commands::Import::Rank.new(period, options).execute
        end
      end

      desc 'blacklist [PATH]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def blacklist(path=nil)
        if options[:help]
          invoke :help, ['blacklist']
        else
          require_relative 'import/blacklist'
          Yomou::Commands::Import::Blacklist.new(path, options).execute
        end
      end
    end
  end
end
