require "feedjira"

module Yomou
  module Command

    class Atom < Thor

      include Yomou::Helper

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

      desc "download", ""
      def download(type = "allnovel")
        kinds = ["allnovel", "noc_allnovel", "mnlt_allnovel"]
        @conf = Yomou::Config.new
        return unless kinds.include?(type)

        url = "http://api.syosetu.com/#{type}.Atom"
        feed = Feedjira::Feed.fetch_and_parse(url)
        sub_directory = Time.now.strftime("atomapi/%Y/%m/%d/#{type}-%H%M.Atom.yaml.xz")
        path = pathname_expanded([@conf.directory,
                                  sub_directory])
        p path.to_s
        archive(feed.psych_to_yaml, path)
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
