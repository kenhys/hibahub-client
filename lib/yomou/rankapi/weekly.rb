require "open-uri"

module Yomou
  module Rankapi

    class Rank < Thor

      private

      def weekly
        date = Date.new(2013, 5, 7)
        while date < Date.today
          rtype = date.strftime("%Y%m%d-w")
          path = Pathname.new(File.join(@conf.directory, "rankapi",
                                        date.strftime("weekly/%Y/#{rtype}.yaml.gz")))
          url = [
            "#{BASE_URL}/?rtype=#{rtype}",
            "gzip=#{@conf.gzip}",
            "out=#{@conf.out}"
          ].join("&")
          FileUtils.mkdir_p(path.dirname)
          if date.tuesday?
            p url
            p path.to_s
            open(url) do |context|
              File.open(path.to_s, "w+") do |file|
                file.puts(context.read)
              end
            end
          end
          date = date.next_day(7)
        end
      end

    end
  end
end
