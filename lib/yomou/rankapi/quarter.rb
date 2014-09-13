require "open-uri"

module Yomou
  module Rankapi

    class Rank < Thor

      private

      def quarter
        date = Date.new(2013, 5, 1)
        while date < Date.today
          path = Pathname.new(File.join(@conf.directory, "rankapi",
                                        date.strftime("quarter/%Y%m%d-q.yaml.gz")))
          rtype = date.strftime("%Y%m%d-q")
          url = [
            "#{BASE_URL}/?rtype=#{rtype}",
            "gzip=#{@conf.gzip}",
            "out=#{@conf.out}"
          ].join("&")
          FileUtils.mkdir_p(path.dirname)
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
