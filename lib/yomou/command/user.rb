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
      option :download
      def novellist(id, arg = nil)
        if options["download"]
          Novellist.download(id)
        else
          Novellist.show(id)
        end
      end

      desc "bookmark USER_ID", ""
      option :download
      def bookmark(id, arg = nil)
        Bookmark.show(id)
      end

    end
  end
end
