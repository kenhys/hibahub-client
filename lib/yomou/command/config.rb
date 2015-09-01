module Yomou

  class Config < Thor

    include Yomou::Helper

    desc "show", ""
    def show
      @conf = Yomou::Config.new
    end

  end
end
