# frozen_string_literal: true

require_relative '../../command'
require_relative '../../cleaner'

module Yomou
  module Commands
    class Clean
      class Novel < Yomou::Command
        def initialize(type_or_path, options)
          @type = type_or_path
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          cleaner = Yomou::NovelCleaner.new
          cleaner.clean(@type)
        end
      end
    end
  end
end
