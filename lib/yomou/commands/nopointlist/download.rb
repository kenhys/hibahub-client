# frozen_string_literal: true

require_relative '../../command'

module Yomou
  module Commands
    class Nopointlist
      class Download < Yomou::Command
        def initialize(min, options)
          @min = min
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
