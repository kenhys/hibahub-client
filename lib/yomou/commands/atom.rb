# frozen_string_literal: true

require 'thor'

module Yomou
  module Commands
    class Atom < Thor

      namespace :atom

      desc 'download TYPE', 'Command description...'
      method_option :help, aliases: '-h', type: :string,
                           desc: 'Display usage information'
      def download(type=nil)
        if options[:help]
          invoke :help, ['download']
        else
          require_relative 'atom/download'
          Yomou::Commands::Atom::Download.new(type, options).execute
        end
      end
    end
  end
end
