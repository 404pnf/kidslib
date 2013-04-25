# -*- coding: utf-8 -*-
require 'securerandom'

p "脚本开始运行的时候回比较慢，因为是在内存中生成1GB的随机二进制数据。"
p "请耐心等待一下。"
GIGABYTE = SecureRandom.random_bytes(1024 * 1193) # 我开始的随机字符串小一点，后面写文件的时候多写1000多次，这样可能快一些。
#GIGABYTE = SecureRandom.random_bytes(1024 * 1017 * 1193) # 不用1024和1000省的一看就是生成的
#GIGABYTE = SecureRandom.random_bytes(1024) # 不用1024和1000省的一看就是生成的

# genarate arbitary size of files with random contents / 
#>> require 'prime'
#>> Prime.take(20)
#=> [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71]
#>> fib 1000
#=> [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597]

# 删除一些数字如果你觉得生成的总文件过大的话
prime = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71]
#fib = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597]
fib = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377]

total = (prime.zip fib).flatten.compact # 去掉nil
#total = [1,2]
p total
number_of_files = total.size
number_of_gb = total.reduce(:+)
p "\n\n ### 生成文件的信息 ### \n"
p "总共生成文件个数为#{number_of_files}。"
p "总共生成文件大小为#{number_of_gb}。如果硬盘空间不够，请赶紧退出程序。"
p "并编辑程序中prime和fib两个数组，删除掉一些数字后，再次运行脚本"


p "\n\n ### 正式开始写文件啦 ###"

# File.write方法有问题，因为用这个方法需要一次性地在内存中生成很多GB的字符串并写入文件
# 内存不够
#total.each_with_index { |times, idx| File.write("#{filename_prefix}#{SecureRandom.hex(3)}.sqlite", GIGABYTE * times); p "写好了第#{idx}文件。\n" }

total.each do |n| 
  filename = "ziyuan-jiami-#{SecureRandom.hex(3)}.sqlite"
  (1216 * n).times do #因为前面的GIGABYE实际上不是GB是MB因此这里乘以1000多变成GB
    # 注意函数后面的()与函数之间不能有空格
    # File.open ("test.sqlite", 'a') do |file| 这是错误的，有空格。浪费我10分钟！
    File.open(filename, 'a') do |file|
      file.puts GIGABYTE 
    end
  end
end
