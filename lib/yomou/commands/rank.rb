# frozen_string_literal: true

require 'thor'

module Yomou
  module Commands
    class Rank < Thor

      namespace :rank

      desc 'download [PERIOD][SINCE]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def download(period=nil,since=nil)
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
