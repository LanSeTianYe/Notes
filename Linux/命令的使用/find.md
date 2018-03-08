##   
时间： 2017/8/14 17:56:28   

参考：  
  
* [http://man.linuxde.net/find](http://man.linuxde.net/find)

## find命令使用  

用来在指定文件夹下查找文件，任何位于参数之前的字符串都将被视为欲查找的目录名。如果使用该命令时，不设置任何参数，则 `find` 将在当前目录下查找子目录与问价。并且将查找的子目录和文件全部显示。

### 语法

	find [-H] [-L] [-P] [-D debugopts] [-Olevel] [path...] [expression]

### 例子  

### 基本例子  
1. 查找指定目录下所有文件列表。   

		find /home/llx/Desktop/
2. 根据规则（正则表达式）过滤文件名。  

		find /home/llx/Desktop/ -name "*te*" 
3. 根据规则（正则表达式）过滤文件名,忽略大小写。  

		find /home/llx/Desktop/ -iname "*te*"
4. 查询以 `.txt` 和 `.war` 结尾的文件。  

 		find -name "*.txt" -o -name "*.war"
5. 查找包含 `abc` 的路径和文件。  

		find /home/llx/Desktop/ -path "*abc*"
6. 查找以 `abc` 结尾的路径和文件。  

		find /home/llx/Desktop/ -path "*abc"
7. 正则表表达式查询。  

		find /home/llx/Desktop/ -regex ".*\(\.txt\|\.war\)$"
8. 否定参数,查找不是以 `.txt` 或 `.war` 结尾的文件。 

		find /home/llx/Desktop/ ! -regex ".*\(\.txt\|\.war\)$"
9. 根据类型查找， 支持  `b 块设备`,  `c 字符设备`,  `d 目录 `, `l 符号连接`, `p Fifo`, `f 普通文件`  and `s 套接字`。  

		find -type d
10. 深度限制， 深度为1的时候只会查询指定目录下的内容。  

		find /home/llx/Desktop/ -maxdepth 1

11. 时间戳查询。  

 * 访问时间（-atime/天，-amin/分钟）：用户最近一次访问时间。
 * 修改时间（-mtime/天，-mmin/分钟）：文件最后一次修改时间。 
 * 变化时间（-ctime/天，-cmin/分钟）：文件数据元（例如权限等）最后一次修改时间。

			//查找刚好在七天前被修改的文件
			find . -mtime 7
			//查找最近七天被修改的文件
			find . -mtime -7
			//查找七天之前修改的文件
			find . -mtime +7
12. 删除匹配文件。  

		find -type d -delete

13. 根据文件权限查找。  

		find . -perm 766
14. 根据用户查找。  

		find . -perm 766 -user llx
### 扩展例子   

结合 `-exec` 使用


	1. 把匹配的文件内容直接复制到 all.txt
	find /home/llx/Desktop/ -name "*.txt" -exec cat {} \;> all.txt
	2. 把匹配的文件内容复制到 all.txt ，复制过程会询问是否要复制指定的文件
	find /home/llx/Desktop/ -name "*.txt" -ok cat {} \;> all.txt
	3. 查看大于指定大小的文件，并显示大小信息
	find / -type f -size +100M -exec ls -lh {} \;
