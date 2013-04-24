# -*- coding: utf-8 -*-

# genarate arbitary size of files with random contents / 
#>> require 'prime'
#>> Prime.take(20)
#=> [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71]
#>> fib 1000
#=> [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597]

prime = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71]
fib = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597]

# call bash command
# system( touch 'touch.txt' )

# mac osx 不认 G 这个，但可以人m，因此我们把size乘以1024
# dd 不加任何 of 的话默认输出是当前目录
arr = ('a'..'z').to_a | (0..9).to_a
(prime + fib).each { |size|
  mega = size * 1024
  filename = 'ziyuan-jiami-' + arr.shuffle.take(6).join + '.crypt'
  system( "dd if=/dev/zero of=#{filename} bs=1 count=0 seek=#{mega}m" )
}
