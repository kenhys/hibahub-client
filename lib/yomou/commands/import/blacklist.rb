# frozen_string_literal: true

require_relative '../../command'

module Yomou
  module Commands
    class Import
      class Blacklist < Yomou::Command
        def initialize(path, options)
          @path = path
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
