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
