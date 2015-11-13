# coding: utf-8
require "yomou/config"

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
      path = ""
      if options.has_key?("force")
        p @conf.database
        p File.expand_path(@conf.database)
        path = Pathname.new(File.expand_path(@conf.database))
        FileUtils.rm_rf(path.dirname)
        FileUtils.mkdir_p(path.dirname)
      end

      if path.exist?
        Groonga::Database.open(path.to_s)
      else
        Groonga::Database.create(:path => path.to_s)
        Groonga::Schema.define do |schema|
          schema.create_table("NarouMaster") do |table|
            table.int32("uid")
          end

          schema.create_table("NarouNovelKeywords") do |table|
            table.time("date")
          end

          # See http://dev.syosetu.com/man/api/
          # _key:ncode(downcase)
          schema.create_table("NarouNovels", :type => :hash) do |table|
            table.text("title")
            table.int32("userid")
            table.text("writer")
            table.text("story")
            table.int32("genre")
            table.text("gensaku")
            table.reference("keyword", "NarouNovelKeywords")
            table.time("general_firstup")
            table.time("general_lastup")
            table.int32("novel_type")
            table.int32("end")
            table.int32("general_all_no")
            table.int32("length")
            table.time("time")
            table.int8("isstop")
            table.int8("pc_or_k")
            table.int32("global_point")
            table.int32("fav_novel_cnt")
            table.int32("review_cnt")
            table.int32("all_point")
            table.int32("all_hyoka_cnt")
            table.int32("sasie_cnt")
            table.int32("kaiwaritu")
            table.time("novelupdated_at")
            table.time("updated_at")
            table.text("toc_url")
            table.int8("yomou_status")
            table.int8("yomou_sync_interval")
            table.time("yomou_sync_schedule")
          end

          # See narou toc.yaml
          # _key:ncode(downcase)/index
          schema.create_table("NarouNovelEpisodes",
                              :type => :patricia_trie) do |table|
            table.int32("index")
            table.text("href")
            table.text("chapter")
            table.text("subtitle")
            table.text("file_subtitle")
            table.time("subdate")
            table.time("subupdate")
            table.time("download_time")
            # See narou element in 本文/*.yaml
            table.text("introduction")
            table.text("body")
            table.text("postscript")
            table.text("data_type")
          end

          ["Quarter", "Monthly", "Weekly", "Daily"].each do |type|
            schema.create_table("Narou#{type}Ranks", :type => :array) do |table|
              table.reference("ncode", "NarouNovels")
              table.time("date")
              table.int32("pt")
              table.int32("rank")
            end
          end

          schema.create_table("NarouNovelUpdateEvents", :type => :array) do |table|
            table.reference("ncode", "NarouNovels")
            table.time("date")
            table.int32("global_point")
            table.int32("fav_novel_cnt")
            table.int32("review_cnt")
            table.int32("all_point")
            table.int32("all_hyoka_cnt")
            table.time("novelupdated_at")
          end

          schema.create_table("YomouUsers", :type => :hash) do |table|
            table.text("name")
            table.text("mail")
            table.text("password")
            table.boolean("admin")
            table.time("update_time")
            table.time("login_time")
            table.text("login_from")
          end

          schema.create_table("NarouUsers", :type => :hash) do |table|
            table.text("name")
            table.reference("novel", "NarouNovels", :type => :vector)
            table.reference("bookmark", "NarouNovels", :type => :vector)
            table.reference("favuser", "NarouUsers", :type => :vector)
            table.reference("novelassess", "NarouNovels", :type => :vector)
            table.reference("reviewlist", "NarouNovels", :type => :vector)
          end

          schema.create_table("NarouUserLogs", :type => :hash) do |table|
            table.reference("user", "NarouUsers")
            table.int32("action")
            table.int32("status")
            table.text("message")
            table.time("update_time")
          end

          schema.create_table("NarouNovelReviews", :type => :hash) do |table|
            table.reference("user", "NarouUsers")
            table.int32("point")
            table.reference("favorite_keywords", "NarouNovelKeywords", :type => :vector)
            table.text("memo")
            table.time("update_time")
          end
        end
      end
    end
  end
end
