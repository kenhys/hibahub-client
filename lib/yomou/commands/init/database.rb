# frozen_string_literal: true

require_relative '../../command'

module Yomou
  module Commands
    class Init
      class Database < Yomou::Command
        def initialize(options)
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          @database = Yomou::Database.new
          @database.init(@options)
        end
      end
    end
  end
end
