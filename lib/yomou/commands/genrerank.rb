# frozen_string_literal: true

require 'thor'

module Yomou
  module Commands
    class Genrerank < Thor

      namespace :genrerank

      desc 'download [PERIOD]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def download(period=nil, genre=nil)
        if options[:help]
          invoke :help, ['download']
        else
          require_relative 'genrerank/download'
          Yomou::Commands::Genrerank::Download.new(period, genre, options).execute
        end
      end

      desc 'list [PERIOD]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def list(period=nil)
        if options[:help]
          invoke :help, ['list']
        else
          require_relative 'genrerank/list'
          Yomou::Commands::Genrerank::List.new(period, options).execute
        end
      end
    end
  end
end
