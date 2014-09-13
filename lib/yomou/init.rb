require "yomou/config"

module Yomou
  module Novelapi

    class Init < Thor

      desc "config", "Initialize configuration"
      def config
        Yomou::Config.new
      end

    end
  end
end
