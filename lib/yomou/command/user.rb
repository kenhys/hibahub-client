require "open-uri"
require "yomou/command/user/bookmark"
require "yomou/command/user/novellist"

module Yomou
  module Command

    # This is unofficial dummy api

    class User < Thor

      include Yomou::Helper

      desc "bookmark USER_ID", ""
      subcommand "bookmark", Yomou::Userapi::Bookmark

      desc "novellist [SUBCOMMAND]", ""
      subcommand "novellist", Yomou::Userapi::Novellist

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
