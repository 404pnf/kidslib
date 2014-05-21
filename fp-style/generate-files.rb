# -*- coding: utf-8 -*-

require 'securerandom'

# USAGE:
#     ruby script.rb size_in_gigabyte
# This will generate huge files with random date at the current direcotry.

(p 'USAGE: ruby script.rb file-size-in-gigabyte' ; exit) if ARGV[0].nil?

MAX_SIZE = 12

# 命令行中输入的大小是TB，比如 1.5 就是 1.5TB 就是1500GB
REQUIRED_SIZE = ARGV[0].to_i + MAX_SIZE

def reduction(op, val, list)
  res = [val]
  list.each {|x| res << res.last.send(op, x) }
  res
end

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


# array的并集  [1,4] | [1,2,3]  是 [1, 4, 2, 3]
arr = ('a'..'z').to_a | (0..9).to_a
# 另外一种生成随机字符的方法
# SecureRandom.hex(6)
# 也可以用sample方法
# a = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
# a.sample         #=> 7
# a.sample(4)      #=> [6, 4, 2, 5]

# 用dd生成松散文件 sparse file
# http://en.wikipedia.org/wiki/Sparse_file
# 因为mac osx系统的dd不支持G这个参数，所以我们只能用 m。
# seek=#{gigabyte}G
# seek=#{mega}m
numbers.each { |size|
  mega = size * 1027 # 为了不让所有文件都正好是多少多少GB一看就知道机器生成
  filename = 'ziyuan-jiami-' + arr.shuffle.take(6).join + '.crypt'
  system( "dd if=/dev/zero of=#{filename} bs=1 count=0 seek=#{mega}m" )
}

