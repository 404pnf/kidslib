#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'pp'
require 'csv'

# usage: ruby #{$0} [目录名]

# 输入为包含图书文件夹的目录
# 脚本会发现该目录中的所有图书目录并生成这些目录包含图片文件(jpg/jpeg/png)文件的csv列表
# 列表也会存在输入目录中
# 输出文件名称为 import.csv


(puts "\n usage: ruby #{$0} [目录名] \n "; exit;) unless ARGV.size == 1

DEBUG = nil

# 首先清除上次遗留的删除，因为这回用的是追加 append
File.delete('import.csv') if File.exist?('import.csv')

input_folder = File.expand_path ARGV[0] 

SUFFIX = /\.(jpg|jpeg|png)/i

Dir.chdir input_folder

book_dirs = Dir.glob("*").select { |file| File.directory? file}

book_dirs.each do |dir|
  book_contents = Dir.entries(dir).select { |f| f =~ SUFFIX}
  book_name = dir
  csv_array = book_contents.map { |img| [book_name, img] }
  CSV.open("import.csv", "a", :force_quotes => true) do |csv|
    csv_array.each {|line| csv << line}
  end
end
  
outfile_with_path =  File.expand_path('import.csv')
puts "\n\n您要的文件生成好了，在#{outfile_with_path}。\n\n请查看。\n\n"


