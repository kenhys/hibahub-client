module Yomou

  YOMOU_DEFAULT_CONFIG = {
    "gzip" => 5,
    "out" => "yaml",
    "narou_novel" => "小説データ/小説家になろう",
    "database" => "~/.yomou/db/yomou.db"
  }

  YOMOU_SYNC_NONE = -1

  YOMOU_NOVEL_DELETED = -1
  YOMOU_NOVEL_NONE = 0
  YOMOU_NOVEL_DOWNLOADED = 1

end
