# coding: utf-8
require 'fileutils'

module Yomou
  module Command
    class Bootstrap < Thor

      include Yomou::Helper

      desc "clean", ""
      option :prefix
      def clean
        @conf = Yomou::Config.new

        if options[:prefix]
          remove_redundant_files(options[:prefix])
        else
          99.times.each do |i|
            remove_redundant_files(sprintf("n%02d", i))
          end
        end
      end

      private

      def remove_redundant_files(target)
        category = target.delete('n')

        directory = @conf.narou_category_directory(category)
        if File.exists?("#{directory}/LOCK")
          p "do not clean #{directory}"
          return
        end

        directory = @conf.narou_novel_directory(category)
        Dir.glob("#{directory}/#{options[:prefix]}*") do |dir|
          Dir.chdir(dir) do
            %w(converter.rb  replace.txt   setting.ini).each do |file|
              if File.exists?(file)
                p "remove #{dir}/#{file}"
                File.delete(file)
              end
            end
            Dir.glob("*.txt") do |txt|
              next if txt == '見出しリスト.txt'
              p "remove #{dir}/#{txt}"
              File.delete(txt)
            end
            if Dir.exists?('raw')
              p "remove #{dir}/raw"
              FileUtils.rm_rf('raw')
            end
          end
        end
      end

    end
  end
end
