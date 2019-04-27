# frozen_string_literal: true

require 'thor'

module Yomou
  module Commands
    class Import < Thor

      namespace :import

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
