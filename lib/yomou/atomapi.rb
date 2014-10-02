require "feedjira"

module Yomou
  module Atomapi

    class Atom < Thor

      desc "allnovel", ""
      def allnovel
        url = "http://api.syosetu.com/allnovel.Atom"
        feed = Feedjira::Feed.fetch_and_parse(url)
        feed.entries.each_with_index do |entry, index|
          ncode = extract_ncode(entry.entry_id)
          printf("%4d %s: %s\n", index+1, ncode, entry.title)
        end
      end

      desc "user USER_ID", ""
      def user(user_id)
        url = "http://api.syosetu.com/writernovel/#{user_id}.Atom"
          feed = Feedjira::Feed.fetch_and_parse(url)
        feed.entries.each_with_index do |entry, index|
          ncode = extract_ncode(entry.links[0])
          printf("%4d %s: %s\n", index+1, ncode, entry.title)
        end
      end

      private

      def extract_ncode(item)
        if item =~ /.+\/(n\w+)\/\d+\//
          ncode = $1.upcase
        elsif item =~ /.+\/(n\w+)\//
          ncode = $1.upcase
        end
        ncode
      end

    end
  end
end
