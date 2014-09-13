require "thor"
require "open3"
require "yomou/novelapi/ncode"

module Yomou
  module Novelapi

    class Novel < Thor

      desc "novel [SUBCOMMAND]", "Get novel data"
      option :ncode
      def get
        p options
        @conf = Yomou::Config.new
        p @conf.directory
        Dir.chdir(@conf.directory) do
          p options["ncode"]
          IO.popen(["narou", "download", options["ncode"]], "r+") do |io|
            io.puts
            io.close_write
            puts io.read
          end
        end
      end
    end

  end
end
