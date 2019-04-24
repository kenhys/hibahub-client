# frozen_string_literal: true

require 'thor'

module Yomou
  module Commands
    class Secondrank < Thor

      namespace :secondrank

      desc 'download [PERIOD]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def download(period=nil,since=nil)
        if options[:help]
          invoke :help, ['download']
        else
          require_relative 'secondrank/download'
          Yomou::Commands::Secondrank::Download.new(period, options).execute
        end
      end
    end
  end
end
