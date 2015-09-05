module Yomou
  module GenreRankapi

    class Quarter < Thor
      namespace "genrerank quarter"

      include Yomou::Helper
      include Yomou::SecondRankapi::Common
      include Yomou::GenreRankapi::Common

      desc "list", ""
      def list
        @conf = Yomou::Config.new
      end

      desc "download [OPTIONS]", ""
      def download(genre)
        @conf = Yomou::Config.new
        entries = extract_rank_h(quarter_url(genre))
        p quarter_path(genre)
        archive(entries, quarter_path(genre))
      end

      private

      def quarter_url(genre)
        "#{BASE_URL}/quarter_#{genre}"
      end

      def quarter_path(genre)
        pathname_expanded([@conf.directory,
                           "genrelist/#{genre}/quarter/#{yyyymmdd}.yaml.gz"])
      end

    end
  end
end
