# frozen_string_literal: true

require_relative '../../command'

module Yomou
  module Commands
    class Init
      class Config < Yomou::Command
        def initialize(options)
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          Yomou::Config.new
        end
      end
    end
  end
end
