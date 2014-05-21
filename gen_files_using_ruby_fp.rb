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

# 命名空间
module U
  extend self # 让所有定义的参数都是module_function

  def blockdata
    -> { SecureRandom.random_bytes(1024 * 1193) }   # 大小约1MB
  end

  def random_filename
    -> { "ziyuan-jiami-#{SecureRandom.hex(4)}.data" }
  end

  def single_file_max_size
    5
  end

  # 因为raondom出的数可能是0，所以需要加1
  def numbers
    Enumerator.new do |y|
      loop { y << SecureRandom.random_number(single_file_max_size) + 1 }
    end
  end

  def filenames
    Enumerator.new do |y|
      loop { y << random_filename.call }
    end
  end

  @n = 0

  # [[6655, "ziyuan-jiami-3dd9937c.data"], [2662, "ziyuan-jiami-82fff573.data"], [3993, "ziyuan-jiami-033706fd.data"], [1331, "ziyuan-jiami-18f2d5ad.data"], [5324, "ziyuan-jiami-9c69a104.data"] ... ]
  def size_filename_pair(total_file_size)
    numbers.each
           .take_while { |e|  @n += e; @n < total_file_size }
           .zip(filenames)
           .map { |gb, filename| [gb * 1331, filename] }
  end
  # module_function :final_pair
end

# p U.numbers.take 10
# p U.size_filename_pair 60

# 命名空间
module GenHugeFile
  # include U # 没有，只对 class instance 起作用 ； 即使写了，在self.method中仍需要写U
  def gen(total_file_size)
    U.size_filename_pair(total_file_size).each do |size_in_mb, filename|
      p "writing #{filename}, #{size_in_mb}MB"
      size_in_mb.times do
        File.open(filename, 'a') { |f| f.puts U.blockdata.call }
      end
    end
  end
  module_function :gen
end

GenHugeFile.gen ARGV[0].to_i
