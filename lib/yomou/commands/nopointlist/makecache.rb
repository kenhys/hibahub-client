# frozen_string_literal: true

require_relative '../../command'
require_relative '../../crawler/nopoint'

module Yomou
  module Commands
    class Nopointlist
      class Makecache < Yomou::Command
        def initialize(options)
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          crawler = Yomou::NopointCrawler.new
          crawler.makecache
        end
      end
    end
  end
end
