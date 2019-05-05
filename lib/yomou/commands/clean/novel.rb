# frozen_string_literal: true

require_relative '../../command'

module Yomou
  module Commands
    class Clean
      class Novel < Yomou::Command
        def initialize(type, options)
          @type = type
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          # Command logic goes here ...
          output.puts "OK"
        end
      end
    end
  end
end
