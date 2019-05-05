# frozen_string_literal: true

require 'thor'

module Yomou
  module Commands
    class Rank < Thor

      namespace :rank

      desc 'list [PERIOD]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def list(period=nil)
        if options[:help]
          invoke :help, ['list']
        else
          require_relative 'rank/list'
          Yomou::Commands::Rank::List.new(period, options).execute
        end
      end

      desc 'download [PERIOD]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def download(period=nil)
        if options[:help]
          invoke :help, ['download']
        else
          require_relative 'rank/download'
          Yomou::Commands::Rank::Download.new(daily, options).execute
        end
      end
    end
  end
end
