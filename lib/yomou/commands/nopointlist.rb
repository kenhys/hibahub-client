# frozen_string_literal: true

require 'thor'

module Yomou
  module Commands
    class Nopointlist < Thor

      namespace :nopointlist

      desc 'download [MIN]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def download(min=1, max=9999)
        if options[:help]
          invoke :help, ['download']
        else
          require_relative 'nopointlist/download'
          Yomou::Commands::Nopointlist::Download.new(min, max, options).execute
        end
      end
    end
  end
end
