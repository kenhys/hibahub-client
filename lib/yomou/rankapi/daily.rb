require "open-uri"

module Yomou
  module Rankapi

    class Rank < Thor

      include Yomou::Helper

      private

      def daily
        date = Date.new(2013, 5, 7)
        while date < Date.today
          rtype = date.strftime("%Y%m%d-d")
          path = Pathname.new(File.join(@conf.directory, "rankapi",
                                        date.strftime("daily/%Y/%m"),
                                        "#{rtype}.yaml.gz"))
          url = [
            "#{BASE_URL}/?rtype=#{rtype}",
            "gzip=#{@conf.gzip}",
            "out=#{@conf.out}"
          ].join("&")
          if File.exists?(path.to_s)
            date = date.next_day
            next
          end

          p url
          p path
          save_as(url, path)
          date = date.next_day
        end
      end

    end
  end
end
