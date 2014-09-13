require "open-uri"

module Yomou
  module Rankapi

    class Rank < Thor

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
          FileUtils.mkdir_p(path.dirname)
          p url
          p path.to_s
          open(url) do |context|
            File.open(path.to_s, "w+") do |file|
              file.puts(context.read)
            end
          end
          date = date.next_day
        end
      end

    end
  end
end
