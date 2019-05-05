# frozen_string_literal: true

require 'thor'

module Yomou
  module Commands
    class Isekairank < Thor

      namespace :isekairank

      desc 'download PERIOD', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def download(period)
        if options[:help]
          invoke :help, ['download']
        else
          require_relative 'isekairank/download'
          Yomou::Commands::Isekairank::Download.new(period, options).execute
        end
      end
    end
  end
end
