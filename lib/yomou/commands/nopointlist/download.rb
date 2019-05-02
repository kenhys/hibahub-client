# frozen_string_literal: true

require_relative '../../command'
require_relative '../../nopoint'

module Yomou
  module Commands
    class Nopointlist
      class Download < Yomou::Command
        def initialize(min, max, options)
          @min = min.to_i
          @max = max.to_i
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          crawler = Yomou::NopointCrawler.new
          crawler.download(min_page: @min, max_page: @max)
        end
      end
    end
  end
end
