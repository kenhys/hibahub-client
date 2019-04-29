# frozen_string_literal: true

require_relative '../../command'

module Yomou
  module Commands
    class Blacklist
      class Init < Yomou::Command
        def initialize(options)
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          blacklist = Yomou::Blacklist.new
          blacklist.init
        end
      end
    end
  end
end
