# -*- coding: utf-8 -*-
require 'securerandom'

# 修改TOTOAL_SIZE，写上你想要要的总共生成文件大小
# 单位是GB 要生成500GB的文件就写500
# 1.3T 就写 1300
TOTAL_SIZE = 320 # 修改这里
# 如果不写，默认是5000
# 如果命令行给出相应参数
# 命令行参数优先
TOTAL_SIZE = ARGV[0].to_i unless ARGV[0].to_i

# USAGE:
#     ruby script.rb size_in_gigabyte
# This will generate huge files with random date at the current direcotry.

# 大部分使用本脚本的人是不会去使用命令行的。因此也就不提示了。
# (p 'USAGE: ruby script.rb file-size-in-gigabyte' ; exit) if ARGV[0].nil?

def reduction(op, val, list)
  res = [val]
  list.each {|x| res << res.last.send(op, x) }
  res
end

MAX_SIZE = 12

# 命令行中输入的大小是GB，

REQUIRED_SIZE = TOTAL_SIZE + MAX_SIZE

# 我开始的随机字符串小一点，后面写文件的时候多写1000多次，这样可能快一些。
# 不用1024和1000省的一看就是生成的
# 现在的BLOCKDATA大小是1MB
BLOCKDATA = SecureRandom.random_bytes(1024 * 1193 )

numbers = []
2000.times { numbers << rand(MAX_SIZE)}

filesize_sum_tuple = numbers.zip(reduction(:+, 0, numbers))

final_arr = filesize_sum_tuple.take_while {|t| t[1] < REQUIRED_SIZE} .collect {|t| t[0]}

final_arr.delete(0) # random出来的数字是有0的，不要生成大小为0的文件了

p final_arr

number_of_files = final_arr.size
number_of_gb = final_arr.reduce(:+)

p "\n\n ### generating files ### \n"
p "number of files:  #{number_of_files}。"
p "size in gigabyte: #{number_of_gb}。"

final_arr.each_with_index do |n, idx|
  puts "\n\n Generatinng file number #{idx+1}. \n\n"
  filename = "ziyuan-jiami-#{SecureRandom.hex(3)}.sqlite"
  #(1 * n).times do # for use in testing the script
  (1216 * n).times do
    # 因为前面的BLOCKDATA实际上不是GB是1个MB因此这里乘以1千多变成GB
    # 注意函数后面的()与函数之间不能有空格
    # File.open ("test.sqlite", 'a') do |file| 这是错误的，有空格。浪费我10分钟！
    File.open(filename, 'a') do |file|
      file.puts BLOCKDATA 
    end
  end
end


# File.write方法有问题，因为用这个方法需要一次性地在内存中生成很多GB的字符串并写入文件
# 下面的方法会因为内存不够无法正确执行
#total.each_with_index { |times, idx| File.write("#{filename_prefix}#{SecureRandom.hex(3)}.sqlite", BLOCKDATA * times); p "写好了第#{idx}文件。\n" }

# 这种方法避免了内存不足的问题。
# 我们每次只写一小块，写n多次。