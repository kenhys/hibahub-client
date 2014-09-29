require "yomou/userapi/bookmark"
require "yomou/userapi/novellist"

module Yomou
  module Userapi

    class Command < Thor

      desc "bookmark USER_ID", ""
      subcommand "bookmark", Yomou::Userapi::Bookmark

      desc "novellist [SUBCOMMAND]", ""
      subcommand "novellist", Yomou::Userapi::Novellist

    end

  end
end