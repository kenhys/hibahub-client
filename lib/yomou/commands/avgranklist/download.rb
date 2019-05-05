# frozen_string_literal: true

require_relative '../../command'
require_relative '../../crawler/avgranklist'

module Yomou
  module Commands
    class Avgranklist
      class Download < Yomou::Command
        def initialize(min, max, options)
          @min = min.to_i
          @max = min.to_i
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          crawler = AvgranklistCrawler.new
          crawler.download(min_page: @min, max_page: @max)
        end
      end
    end
  end
end
