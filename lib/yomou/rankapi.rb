require "zlib"
require "pathname"
require "pp"
require "yomou/rankapi/daily"
require "yomou/rankapi/weekly"
require "yomou/rankapi/monthly"
require "yomou/rankapi/quarter"

module Yomou
  module Rankapi

    BASE_URL = "http://api.syosetu.com/rank/rankget"

    class Rank < Thor

      desc "get", ""
      option :daily
      option :weekly
      option :monthly
      option :quarter
      option :all
      def get
        @conf = Yomou::Config.new
        p options
        quarter if quarter?
        monthly if monthly?
        weekly if weekly?
        daily if daily?
      end

      desc "download", ""
      option :daily
      option :weekly
      option :monthly
      option :quarter
      def download
        @conf = Yomou::Config.new
        path = Pathname.new(File.join(@conf.directory,
                                      "rankapi/quarter",
                                      "#{options['quarter']}-q.yaml.gz"))
        if path.exist?
          entries = []
          Zlib::GzipReader.open(path.to_s) do |gz|
            YAML.load(gz.read).each do |entry|
              entries << entry['ncode'].downcase
            end
          end
          Dir.chdir(@conf.directory) do
            entries.each do |ncode|
              id = `narou list -u -g #{ncode}`.chomp
              if id.empty?
                system("narou download --no-convert #{ncode}")
              else
                puts "Already downloaded #{ncode}"
              end
            end
          end
        end
      end

      private

      def daily?
        options.has_key?("daily")
      end

      def weekly?
        options.has_key?("weekly")
      end

      def monthly?
        options.has_key?("monthly")
      end

      def quarter?
        options.has_key?("quarter")
      end
    end

  end
end
