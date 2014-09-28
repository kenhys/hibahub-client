require "open-uri"
require "yomou/userapi/command"
require "yomou/userapi/novellist"

module Yomou
  module Userapi

    # This is unofficial dummy api

    class User < Thor

      include Yomou::Helper

      desc "get [SUBCOMMAND]", "Initialize cofiguration"
      subcommand "get", Yomou::Userapi::Command

      desc "novellist USER_ID", ""
      def novellist(id, arg = nil)
        Yomou::Userapi::Novellist.show(id)
      end

      desc "bookmark USER_ID", ""
      def bookmark(id, arg = nil)
        Yomou::Userapi::Bookmark.show(id)
      end

    end
  end
end
