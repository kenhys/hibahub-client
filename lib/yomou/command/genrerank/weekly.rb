module Yomou
  module GenreRankapi

    class Weekly < Thor
      namespace "genrerank weekly"

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
        entries = extract_rank_h(weekly_url(genre))
        p weekly_path(genre)
        archive(entries, weekly_path(genre))
      end

      private

      def weekly_url(genre)
        "#{BASE_URL}/weekly_#{genre}"
      end

      def weekly_path(genre)
        pathname_expanded([@conf.directory,
                           "genrelist/#{genre}/weekly/#{yyyymmdd}.yaml.xz"])
      end
    end
  end
end
