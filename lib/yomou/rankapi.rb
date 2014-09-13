require "pathname"
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
