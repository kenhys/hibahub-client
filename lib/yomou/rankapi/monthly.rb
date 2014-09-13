require "open-uri"

module Yomou
  module Rankapi

    class Rank < Thor

      private

      def monthly
        date = Date.new(2013, 5, 1)
        while date < Date.today
          path = Pathname.new(File.join(@conf.directory, "rankapi",
                                        date.strftime("monthly/%Y%m%d-m.yaml.gz")))
          rtype = date.strftime("%Y%m%d-m")
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
          date = date.next_month
        end
      end

    end
  end
end
