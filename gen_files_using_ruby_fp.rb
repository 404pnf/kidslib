## 目的
#
# 在当前目录生成内容随机的文件。文件大小从1G到5G不等。文件总大小同过命令行参数设定。

## 使用说明
#
#     ruby script.rb total_file_size
#
# 命令行跟总共要生成的文件大小。单位是GB。
#
# 举例：
#
# 不加任何参数执行脚本默认生成100GB文件
#
#     ruby script.rb
#
# 要生成总共500GB的文件
#
#     ruby script.rb 500
#
# 要生成总共1.5TB的文件
#
#     ruby script.rb 1500
#
# ----

require 'securerandom'

# 命名空间
module U
  extend self # 让所有定义的参数都是module_function

  def blockdata
    SecureRandom.random_bytes(1024 * 1193)  # 大小约1MB
  end

  def random_filename
    "ziyuan-jiami-#{SecureRandom.hex(4)}.data"
  end

  # 因为raondom出的数可能是0，所以需要加1
  def numbers(n)
    Enumerator.new do |y|
      loop { y << SecureRandom.random_number(n) + 1 }
    end
  end

  def filenames
    Enumerator.new do |y|
      loop { y << random_filename }
    end
  end

  # 1. numbers按需生成一系列数字，take_while根据判定收集这些数字一直到超过总共需要的大小为止
  # 1. 然后我们将这些数字和随即文件名zip起来
  # 1. 结果的例子： [[6655, "ziyuan-jiami-3dd9937c.data"], [2662, "ziyuan-jiami-82fff573.data"], ... ]
  def size_filename_pair(total_file_size, single_file_max_size)
    n = 0
    numbers(single_file_max_size).each
           .take_while { |e|  n += e; n < total_file_size }
           .zip(filenames)
           .map { |megabyte, filename| [megabyte * 1331, filename] }
  end
end

# 命名空间
module GenHugeFile
  # include U # 没有，只对 class instance 起作用 ； 即使写了，在self.method中仍需要写U
  def gen(total_file_size = 100, single_file_max_size = 5)
    U.size_filename_pair(total_file_size, single_file_max_size).each do |size_in_mb, filename|
      p "writing #{filename}, #{size_in_mb}MB"
      size_in_mb.times do
        File.open(filename, 'a') { |f| f.puts U.blockdata }
      end
    end
  end
  module_function :gen
end

# ----
# 干活
GenHugeFile.gen ARGV[0].to_i, ARGV[1].to_i

# ----
## 用bash的dd生成松散文件。
# 好处：速度非常非常快。松散文件内容都是0，用ls等工具查看，显示的大小很大。
# 其实它只是对操作系统声明自己要占那么多地方，而实际上根本没占什么地方
# 如果怕被发现生成的文件实际没有那么大。可以在生成后，用openssl加密一下文件。
# 加密后的文件占用的空间就是实际声明的大小了。内容也看不出来都是0.
# 命名空间
# module GenHugeFileBash
#   # include U # 没用，只对 class instance 起作用 ； 即使写了，在self.method中仍需要写U
#   def gen(total_file_size = 100)
#     U.size_filename_pair(total_file_size).each do |size_in_mb, filename|
#       p "writing #{filename}, #{size_in_mb}MB"
#       system("dd if=/dev/zero of=#{filename} bs=1 count=0 seek=#{size_in_mb}m")
#     end
#   end
#   module_function :gen
# end

# GenHugeFileBash.gen ARGV[0].to_i

# ----
## 加密松散文件
# 加密速度会很慢，1G一分钟。起个中断，输入加密命令然后走人即可。
# http://stackoverflow.com/questions/8641109/encrypt-a-file-using-bash-shell-script
# openssl des3 -salt -in /pritom/uaeyha_com.sql -out /pritom/a.ss -pass pass:pritom


# ----
## 命令式编程风格的代码
# module GenHugeFileImperative
#   def blockdata
#     SecureRandom.random_bytes(1024 * 1193)
#   end

#   def gen(total_file_size=100, single_file_max_size = 5)
#     n = 0
#     while n < total_file_size
#       filename =  "ziyuan-jiami-#{SecureRandom.hex(6)}.data"
#       size = (SecureRandom.random_number single_file_max_size) + 1 # 因为random出来的数字可能是1
#       (1013 * size).times do
#         File.open(filename, 'a') { |f| f.puts blockdata }
#       end
#       n += size
#     end
#   end
#   module_function :gen :blockdata
# end

# GenHugeFileImperative.gen ARGV[0].to_i