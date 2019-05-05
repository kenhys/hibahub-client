# frozen_string_literal: true

require_relative '../../command'
require_relative '../../crawler/isekailist'

module Yomou
  module Commands
    class Isekairank
      class Download < Yomou::Command
        def initialize(period, options)
          @period = period
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          crawler = Yomou::IsekailistCrawler.new
          crawler.download(period: @period)
        end
      end
    end
  end
end
