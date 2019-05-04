# frozen_string_literal: true

require_relative '../../command'
require_relative '../../crawler/genrelist'

module Yomou
  module Commands
    class Genrerank
      class Download < Yomou::Command
        def initialize(period, genre, options)
          @period = period
          @genre = genre
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          crawler = GenrelistCrawler.new
          options = {}
          options[:genres] = [@genre] if @genre
          options[:periods] = [@period] if @period
          crawler.download(options)
        end
      end
    end
  end
end
