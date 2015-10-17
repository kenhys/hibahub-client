# coding: utf-8
module Yomou
  module Command
    class Impression < Thor
      namespace :impression

      include Yomou::Helper
      include Yomou::Impression

      BASE_URL = 'http://novelcom.syosetu.com/impression/list/ncode/'

      desc "download", ""
      def download(*ncodes)
        @conf = Yomou::Config.new

        if ncodes.empty?
          @downloader = Yomou::Narou::Downloader.new
          ncodes = @downloader.downloaded_ncodes
        end

        ncodes.each do |ncode|

          @impression = PageParser.new(ncode)

          next if @impression.cached?

          entries = @impression.cache

          @info = NovelInfo::PageParser.new(ncode)
          info = @info.fetch_info
          p info
          next if info.empty?
          next if info[:impression_count] == 0
          n_pages = info[:impression_count] / 10 + 1
          n_pages.times do |index|
            next if @impression.skipped?
            sleep YOMOU_REQUEST_INTERVAL_MSEC
            @impression.fetch(info[:impression_id])
          end
          entries = @impression.append(entries)
          archive(entries, path)
        end
      end

      private

   end

  end
end
