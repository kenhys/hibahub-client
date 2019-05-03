# frozen_string_literal: true

require_relative '../../command'
require 'yomou/config'
require 'yomou/blacklist'

module Yomou
  module Commands
    class Blacklist
      class Import < Yomou::Command
        def initialize(min, max, options)
          @options = options
          @min = min.to_i
          @max = max.to_i
        end

        def execute(input: $stdin, output: $stdout)
          blacklist = Yomou::Blacklist.new(@options)
          blacklist.import(min: @min, max: @max)
        end
      end
    end
  end
end
