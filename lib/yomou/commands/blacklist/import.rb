# frozen_string_literal: true

require_relative '../../command'
require 'yomou/config'
require 'yomou/blacklist'

module Yomou
  module Commands
    class Blacklist
      class Import < Yomou::Command
        def initialize(options)
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          blacklist = Yomou::Blacklist.new
          blacklist.import
        end
      end
    end
  end
end
