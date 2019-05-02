module Yomou

  YOMOU_DEFAULT_CONFIG = {
    "gzip" => 5,
    "out" => "yaml",
    "narou_novel" => "小説データ/小説家になろう",
    "database" => "~/.yomou/db/yomou.db"
  }

  YOMOU_SYNC_INTERVAL = 24 * 3

  YOMOU_SYNC_INTERVAL_WEEK = 24 * 60 * 60 * 7
  YOMOU_SYNC_INTERVAL_3DAYS = 24 * 60 * 60 * 3

  YOMOU_SYNC_NONE = -1

  YOMOU_REQUEST_INTERVAL_MSEC = 3

  YOMOU_NOVEL_DELETED = -1
  YOMOU_NOVEL_NONE = 0
  YOMOU_NOVEL_DOWNLOADED = 1

  YOMOU_GENRE_TABLE = {
    "文学" => 1,
    "恋愛" => 2,
    "歴史" => 3,
    "推理" => 4,
    "ファンタジー" => 5,
    "SF" => 6,
    "ホラー" => 7,
    "コメディー" => 8,
    "冒険" => 9,
    "学園" => 10,
    "戦記" => 11,
    "童話" => 12,
    "詩" => 13,
    "エッセイ" => 14,
    "リプレイ" => 16,
    "その他" => 15,
  }
end
