require "yomou/config"

module Yomou

  class Init < Thor

    desc "config", "Initialize configuration"
    def config
      Yomou::Config.new
    end

  end
end
