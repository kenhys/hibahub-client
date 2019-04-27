# frozen_string_literal: true

require_relative '../../command'

module Yomou
  module Commands
    class Import
      class Novel < Yomou::Command
        def initialize(ncode, options)
          @ncode = ncode
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
