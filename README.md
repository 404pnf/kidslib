# 如何使用

usage: ruby #{$0} [目录名]

输入为包含图书文件夹的目录
脚本会发现该目录中的所有图书目录并生成这些目录包含图片文件(jpg/jpeg/png)文件的csv列表
列表也会存在输入目录中
输出文件名称为 import_{date}.csv


# 把本脚本作为ruby脚本使用

usage: ruby #{$0} [目录名]

目录名为要处理的文件夹名称。里面应该含有很多书的目录。

也可以使用  script . 来处理当前目录。

脚本会将目录中的所有文件按照文件名规则整理为一本本书并生成import.csv文件。

该输出文件文件符合导入的格式要求，每行内容是：

    书名，图片文件名

# 让本脚本成为gnu/linux命令

    mkdir ~/bin

    vim ~/bash_profile  加入下面内容

    PATH=$PATH:/home/tian/bin
    export PATH

    source ~/bash_profile 

    mv filelist2csv.rb ~/bin/filelist2csv

之后就可以在任何目录直接调用 filelist2csv了。

# 生成任意大小的文件


1. use dd to generate huge sparse files that don't occupy real disk space

2. mv generated files to usb disk

3. use openssl to encrypt those files.  The encrypted files takes real disk space!!

4. also, one can use gpc -c inputfile to encrypt the files

# TODO

只用用ruby的标准库来加密文件吧。

	> '000000000'.crypt('adfsdfasfsaf')
	=> "adpNaFzzBd/3w
