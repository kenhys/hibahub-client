# frozen_string_literal: true

require 'thor'

module Yomou
  module Commands
    class Noimpressionlist < Thor

      namespace :noimpressionlist

      desc 'download [MIN]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def download(min=nil,max=nil)
        if options[:help]
          invoke :help, ['download']
        else
          require_relative 'noimpressionlist/download'
          Yomou::Commands::Noimpressionlist::Download.new(min, options).execute
        end
      end
    end
  end
end
