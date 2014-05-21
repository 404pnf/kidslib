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

## 用模块封装，就是一个命名空间
module GenHugeFile
  # ----
  # BLOCKDATA的大小是1MB

  # 我开始的随机字符串小一点，后面写文件的时候多写1000多次，这样可能快一些。

  # 不用1024和1000，省得一看就是生成的

  BLOCKDATA = -> { SecureRandom.random_bytes(1024 * 1193) }

  # ----
  # 主函数

  # integer -> side effect

  # 参数是文件总大小
  #
  # 不要用File.write，因为它需要一次性地在内存中生成很多GB的字符串并写入文件，会因为内存不够无法正确执行

  # File.open(filename, 'a') 避免了内存不足的问题。我们每次只写一小块，写n多次。

  # 1013 * size 是因为 BLOCKDATA 是 mb， 要写的文件是 gb

  # 写imperative风格的代码本想用while loop会很简洁，结果发现那些变量究竟是出现在while循环内还是外等问题
  # 花费的时间也不少。晕。
  def gen(total_file_size=100, single_file_max_size = 5)
    n = 0
    while n < total_file_size
      filename =  "ziyuan-jiami-#{SecureRandom.hex(6)}.data"
      size = SecureRandom.random_number single_file_max_size
      (1013 * size).times do
        File.open(filename, 'a') { |f| f.puts((GenHugeFile::BLOCKDATA).call) }
      end
      n += size
    end
  end

  module_function :gen
end

GenHugeFile.gen ARGV[0].to_i