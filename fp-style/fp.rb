## 目的

# 在当前目录生成内容随机的文件。文件大小从1G到5G不等。文件总大小同过命令行参数设定。

## 使用说明

#     ruby script.rb total_file_size

# 命令行跟总共要生成的文件大小。单位是GB。

# 举例：

# 不加任何参数执行脚本默认生成100GB文件

#     ruby script.rb

# 要生成总共500GB的文件

#     ruby script.rb 500

# 要生成总共1.5TB的文件

#     ruby script.rb 1500

# ----

require 'securerandom'

module GenHugeFile

  def reduction(op, val, list)
    res = [val]
    list.each {|x| res << res.last.send(op, x) }
    res
  end

# 现在的BLOCKDATA大小是1MB
BLOCKDATA = -> { SecureRandom.random_bytes(1024 * 1193 ) }

numbers = Enumerator.new do |y|
  yield(SecureRandom.random_number MAX)

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