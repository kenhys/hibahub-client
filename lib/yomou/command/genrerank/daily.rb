
module Yomou
  module GenreRankapi

    class Daily < Thor
      namespace "genrerank daily"

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
        url = daily_url(genre)
        entries = extract_rank_h(url)
        p daily_path(genre)
        archive(entries, daily_path(genre))
      end

      private

      def daily_url(genre)
        "#{BASE_URL}/daily_#{genre}"
      end

      def daily_path(genre)
        pathname_expanded([@conf.directory,
                           "genrelist/#{genre}/daily/#{yyyymmdd}.yaml.gz"])
      end
    end
  end
end
