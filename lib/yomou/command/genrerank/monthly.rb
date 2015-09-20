module Yomou
  module GenreRankapi

    class Monthly < Thor
      namespace "genrerank monthly"

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
        entries = extract_rank_h(monthly_url(genre))
        p monthly_path(genre)
        archive(entries, monthly_path(genre))
      end

      private

      def monthly_url(genre)
        "#{BASE_URL}/monthly_#{genre}"
      end

      def monthly_path(genre)
        pathname_expanded([@conf.directory,
                           "genrelist/#{genre}/monthly/#{yyyymmdd}.yaml.xz"])
      end
    end
  end
end
