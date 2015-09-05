require "open-uri"

module Yomou
  module Rankapi

    class Quarter < Thor
      namespace "rank quarter"

      include Yomou::Helper

      desc "list", ""
      def list
        @conf = Yomou::Config.new
        date = Date.today
        date = Date.new(date.year, date.month, 1)
        url = quarter_url(date)
        yaml_gz(url).each do |entry|
          printf("%3d: %3dpt %s\n",
                 entry["rank"], entry["pt"], entry["ncode"])
        end
      end

      desc "download [--since YYYYMMDD|all]", ""
      option :since
      def download
        @conf = Yomou::Config.new
        date = nil
        if options.has_key?("since")
          if options["since"] == "all"
            date = Date.new(2013, 5, 1)
          else
            date = Date.parse(options["since"])
            if date.day != 1
              date = date.next_month
              date = Date.new(date.year, date.month, 1)
            end
          end
        else
          date = Date.today
          date = Date.new(date.year, date.month, 1)
        end
        while date < Date.today
          url = quarter_url(date)
          path = quarter_path(date)
          unless path.exist?
            if date >= Date.new(2013, 5, 1)
              p url
              p path.to_s
              save_as(url, path)
            end
          end
          date = date.next_month
        end
      end

      private

      def quarter_url(date)
        rtype = date.strftime("%Y%m%d-q")
        [
          "#{BASE_URL}/?rtype=#{rtype}",
          "gzip=#{@conf.gzip}",
          "out=#{@conf.out}"
        ].join("&")
      end

      def quarter_path(date)
        rtype = date.strftime("%Y%m%d-q")
        path = Pathname.new(File.join(@conf.directory, "rankapi",
                                      date.strftime("quarter/%Y%m%d-q.yaml.gz")))
        FileUtils.mkdir_p(path.dirname)
        path
      end

    end
  end
end
