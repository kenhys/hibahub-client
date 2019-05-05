# frozen_string_literal: true

require_relative '../../command'
require_relative '../../crawler/isekailist'

module Yomou
  module Commands
    class Isekairank
      class Download < Yomou::Command
        def initialize(period, options)
          @periods = [period]
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          crawler = Yomou::IsekailistCrawler.new
          crawler.download(periods: @periods)
        end
      end
    end
  end
end
