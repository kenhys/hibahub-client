
module Yomou
  module GenreRankapi

    class Yearly < Thor
      namespace "genrerank yearly"

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
        entries = extract_rank_h(yearly_url(genre))
        p yearly_path(genre)
        archive(entries, yearly_path(genre))
      end

      private

      def yearly_url(genre)
        "#{BASE_URL}/yearly_#{genre}"
      end

      def yearly_path(genre)
        pathname_expanded([@conf.directory,
                           "genrelist/#{genre}/yearly/#{yyyymmdd}.yaml.xz"])
      end

    end
  end
end
