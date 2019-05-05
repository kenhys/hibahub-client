# frozen_string_literal: true

require 'thor'

module Yomou
  module Commands
    class Clean < Thor

      namespace :clean

      desc 'novel [TYPE]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def novel(type=nil)
        if options[:help]
          invoke :help, ['novel']
        else
          require_relative 'clean/novel'
          Yomou::Commands::Clean::Novel.new(type, options).execute
        end
      end
    end
  end
end
