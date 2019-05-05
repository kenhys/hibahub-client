# frozen_string_literal: true

require_relative '../../command'

module Yomou
  module Commands
    class Avgranklist
      class Download < Yomou::Command
        def initialize(min, max, options)
          @min = min
          @max = min
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          crawler = AvgranklistCrawler.new
          crawler.download
        end
      end
    end
  end
end
