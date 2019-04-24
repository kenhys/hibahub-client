# frozen_string_literal: true

require 'thor'

module Yomou
  module Commands
    class Init < Thor

      namespace :init

      desc 'database', 'Initialize database'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def database(*)
        if options[:help]
          invoke :help, ['database']
        else
          require_relative 'init/database'
          Yomou::Commands::Init::Database.new(options).execute
        end
      end

      desc 'config', 'Initialize configuration'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def config(*)
        if options[:help]
          invoke :help, ['config']
        else
          require_relative 'init/config'
          Yomou::Commands::Init::Config.new(options).execute
        end
      end
    end
  end
end
