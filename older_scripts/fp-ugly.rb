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
class GenHugeFile

  @single_file_max_size= 5
  @blockdata = -> { SecureRandom.random_bytes(1024 * 1193 ) }   # 现在的BLOCKDATA大小是1MB
  @random_filename = -> { "ziyuan-jiami-#{SecureRandom.hex(4)}.data" }

  # 因为raondom出的数可能是0，所以需要加1
  @numbers = Enumerator.new do |y|
    loop { y << SecureRandom.random_number(@single_file_max_size) + 1 }
  end

  @filenames = Enumerator.new do |y|
    loop { y << @random_filename.call }
  end

  # final_pair 结构是
  # [[6655, "ziyuan-jiami-3dd9937c.data"], [2662, "ziyuan-jiami-82fff573.data"], [3993, "ziyuan-jiami-033706fd.data"], [1331, "ziyuan-jiami-18f2d5ad.data"], [5324, "ziyuan-jiami-9c69a104.data"] ... ]
  def self.gen(total_file_size)
    n = 0

    final_pair = @numbers.each
                        .take_while { |e| n += e; n < total_file_size.to_i }
                        .zip(@filenames)
                        .map { |gb, filename| [gb * 1331, filename] }

    final_pair.each do |size_in_mb, filename|
      size_in_mb.times do
        File.open(filename, 'a') do |file|
          file.puts @blockdata.call
        end
      end
    end
  end

end

GenHugeFile.gen ARGV[0]
