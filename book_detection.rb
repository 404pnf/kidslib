# -*- coding: utf-8 -*-
require 'find'
require 'set'
require 'pp'
require 'csv'
require 'test/unit'

# usage: ruby #{$0} [目录名]
DEBUG = nil

input_folder = ARGV[0] || './books'

book_name = Set.new # 集合，所以会自动拒绝重复元素

Find.find(input_folder) do |file|
  next unless file =~ /\.png/
  m = file.match(/(.+[^\d])\d+\.png/)
  p m if DEBUG
  path_and_bookname = m[1]
  book_name << path_and_bookname
end

book_name.map! {|path| path.split('/')[2]}
p book_name.map {|path| path.split('/')[2]} if DEBUG

# enum holds filenames without path
enum = Find.find('./books').to_a.map! {|path| path.split('/')[2]}
p enum if DEBUG

rst = Hash.new { |h,k| h[k] = {} }

# rst is a hash, 
# {"第一本书"=>
#  {:png=>["第一本书01.png", "第一本书02.png", "第一本书03.png"],
#    :mp3=>["第一本书01.mp3", "第一本书02.mp3", "第一本书03.mp3"]}}
book_name.each do |bookname|
  png = enum.select {|i| i =~ /^#{bookname}.+\.png/}
  mp3 = enum.select {|i| i =~ /^#{bookname}.+\.mp3/}
  rst[bookname][:png] = png
  rst[bookname][:mp3] = mp3
  rst
end

pp rst if DEBUG

# 有些图书的图片和mp3不是一一对应的。
# 比如下例，图片3张，音频一个
#   "红楼梦"=>{:png=>["红楼梦1.png", "红楼梦2.png", "红楼梦3.png"], :mp3=>["红楼梦3.mp3"]},

# 在生成csv的时候
# 那些没有mp3的要标记为空白
# 因此我们必须先配对
booknames = rst.keys 

final_rst = []
booknames.each do |bookname|
  pngs = rst[bookname][:png]
  mp3s = rst[bookname][:mp3]
  # 因为1、图片永远多余音频，2、根据约定同一页的图片和音频除扩展名外文件名相同
  # 因此我们一个一个过图片，看看有没有对应的音频
  # 如果有就收集进来，如果没有，就在那个index插入空白
  pngs.each_with_index do |png, idx|
    csv = []
    mp3s.insert(idx, '') unless mp3s.include? (png.slice(0..-4) + 'mp3')
    csv << bookname << pngs[idx]<< mp3s[idx] 
    final_rst << csv
  end
end
#p final_rst.to_csv
CSV.open("import.csv", "w", :force_quotes => true) do |csv|
  final_rst.each {|line| csv << line}
end

outfile_with_path =  File.expand_path('import.csv')
puts "\n\n您要的文件生成好了，在#{outfile_with_path}。\n\n请查看。\n\n"

# 为了测试这个逻辑是否正确
def array_pair_insert_placeholder a1, a2
  a1.each_with_index do |n, idx|
    a2.insert(idx, '') unless a2.include? n
  end
  a2
end
# tests
class TestBookDetection < Test::Unit::TestCase
  def test_array_pair_insert_placeholder 
    a1 = [1,2,3]
    a2 = [1,3]
    expected = [1, "", 3]
    assert_equal expected, array_pair_insert_placeholder(a1, a2), '在缺少元素的数组中增加空白让两个数组元素能够一一对应'
  end
end
