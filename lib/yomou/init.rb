require "yomou/config"
require "grn_mini"

module Yomou

  class Init < Thor

    desc "config", "Initialize configuration"
    def config
      Yomou::Config.new
    end

    desc "database", "Initialize database"
    option :force
    def database
      @conf = Yomou::Config.new
      if options.has_key?("force")
        p @conf.database
        p File.expand_path(@conf.database)
        path = Pathname.new(File.expand_path(@conf.database))
        FileUtils.rm_rf(path.dirname)
        FileUtils.mkdir_p(path.dirname)
      end

      GrnMini::create_or_open(path.to_s)

      master = GrnMini::Hash.new("NarouMaster")
      master.setup_columns(uid: -1)

      keywords = GrnMini::Hash.new("NarouNovelKeywords")
      keywords.setup_columns(date: Time.new(0))

      novels = GrnMini::Hash.new("NarouNovels")
      novels.setup_columns(title: "",
                           userid: -1,
                           writer: "",
                           story: "",
                           genre: -1,
                           gensaku: "",
                           keyword: [keywords],
                           general_firstup: Time.new(0),
                           general_lastup: Time.new(0),
                           novel_type: -1,
                           end: -1,
                           general_all_no: -1,
                           length: -1,
                           time: -1,
                           isstop: -1,
                           pc_or_k: -1,
                           global_point: -1,
                           fav_novel_cnt: -1,
                           review_cnt: -1,
                           all_point: -1,
                           all_hyoka_cnt: -1,
                           sasie_cnt: -1,
                           kaiwaritu: -1,
                           novelupdated_at: Time.new(0),
                           updated_at: Time.new(0),
                           toc_url: "",
                           yomou_status: -1,
                           yomou_sync_interval: -1,
                           yomou_sync_schedule: Time.new(0))

      novel = GrnMini::Hash.new("NarouNovel")
      novel.setup_columns(index: -1,
                          href: "",
                          chapter: "",
                          subtitle: "",
                          file_subtitle: "",
                          subdate: Time.new(0),
                          subupdate: Time.new(0),
                          download_time: Time.new(0),
                          introduction: "",
                          body: "",
                          postscript: "",
                          data_type: "")

      ["Quarter", "Monthly", "Weekly", "Daily"].each do |type|
        table = GrnMini::Array.new("Narou#{type}Ranking")
        table.setup_columns(ncode: novels,
                            date: Time.new(0),
                            pt: 0,
                            rank: 0)
      end

      table = GrnMini::Array.new("NarouNovelUpdateEvents")
      table.setup_columns(ncode: novels,
                          date: Time.new(0),
                          global_point: -1,
                          fav_novel_cnt: -1,
                          review_cnt: -1,
                          all_point: -1,
                          all_hyoka_cnt: -1,
                          novelupdated_at: Time.new(0))

      accounts = GrnMini::Hash.new("YomouUsers")
      accounts.setup_columns(name: "",
                             mail: "",
                             password: "",
                             admin: false,
                             update_time: Time.new(0),
                             login_time: Time.new(0),
                             login_from: "")

      users = GrnMini::Hash.new("NarouUsers")
      users.setup_columns(name: "",
                          novel: [novels],
                          bookmark: [novels],
                          favuser: [users],
                          novelassess: [novels],
                          reviewlist: [novels])

      logs = GrnMini::Array.new("NarouUserLogs")
      logs.setup_columns(user: users,
                         action: -1,
                         status: -1,
                         message: "",
                         update_time: Time.new(0))

      reviews = GrnMini::Array.new("NarouNovelReviews")
      reviews.setup_columns(user: users,
                            point: -1,
                            favorite_keywords: [keywords],
                            memo: "",
                            update_time: Time.new(0))
    end
  end
end
