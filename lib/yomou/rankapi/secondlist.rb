require "open-uri"

module Yomou
  module Rankapi

    class SecondList < Thor

      BASE_URL = "http://yomou.syosetu.com/rank/secondlist/type"

      desc "get", ""
      option :type
      def get
        @conf = Yomou::Config.new
        return unless options['type']

        types = ["daily", "weekly", "monthly", "quarter", "yearly"]
        return unless types.include?(options['type'])

        __send__("#{options['type']}_total")
        p options
      end

      private

      def method_missing(method, *args)
        url = "#{BASE_URL}/#{method}/"
        p url
        path = Pathname.new(File.join(@conf.directory,
                                      "rankapi",
                                      "secondlist/#{method}.html"))
        download_html(url, path)
      end

      def download_html(url, path)
        p url
        FileUtils.mkdir_p(path.dirname)
        open(url) do |context|
          p path
          File.open(path.to_s, "w+") do |file|
            file.puts(context.read)
          end
        end
      end
    end
  end
end
