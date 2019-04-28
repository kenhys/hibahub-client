# frozen_string_literal: true

require_relative '../../command'
require_relative '../../atom'

module Yomou
  module Commands
    class Atom
      class Download < Yomou::Command
        def initialize(type, options)
          @type = type
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          # Command logic goes here ...
          downloader = Yomou::Atom::Downloader.new
          downloader.download
        end
      end
    end
  end
end
