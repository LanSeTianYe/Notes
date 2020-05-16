时间：2018/7/1 11:43:11
 
参考：

1. [awk从放弃到入门](http://www.zsythink.net/archives/tag/awk/)

##  awk 命令简介

awk是行处理器，过滤并格式化输入输出。

## 语法：

	awk [options] 'pattern{action}' file

## 语法详解

* option：选项
	* -F 指定使用的分隔符，默认使用空格
	* -OFS 指定输出分隔符 
* pattern: 相当于条件，满足条件的行才会被处理。可以使用正则表达式和条件关系表达式。
	* BEGIN: 处理前执行的命令
	* END ：处理之后执行的命令
	
			df -h | awk 'BEGIN{print "start ..."}{print "SIZE:"$2}END{print "end ..."}'
	* 输出第五行：

			df -h |  awk 'NR==5{printf "%s\n", $0}'
			# 左对齐
			awk 'BEGIN{printf "%10-s, %10-s\n", "1","2"}
			# 右对齐
			awk 'BEGIN{printf "%10s, %10s\n", "1","2"}
	* 以 `tmp` 开头的行

		 	df -h |  awk '/^tmp/{printf "%s\n", $0}'
			awk -F: '/\/bin\/bash/{print $1,$2, $3}' /etc/passwd
			awk -F: '/ro{2,3}t/{print $0}' /etc/passwd
			# 范围，顶一个正则匹配到的第一个是开始行，第二个正则匹配的第一行是结束行
			# m开头到s开头之间的行
			cat /etc/passwd | sort -h | awk '/^m/, /^s/{print $0}'
	* rand():随机数
	* srand()：重置随机数
	* int():取整
	
			 awk 'BEGIN{srand(); for(i =0; i < 10; i ++){print int(rand() * 100) }}'
	* gsub("a","A",$1)：替换所有的a为A
	* sub("a","A",$1)：替换第一个a为A
	* length():
	* index($0,"a"): `a` 在 `$0` 的起始位置
	* split(nameStr,names,":"): 分割字符串
	* asort(arr):排序数组，排序后数组的索引会改变
	* asorti(旧数组，新数组):根据数组索引排序，排序后的索引被存放在新的数组中。（数组的索引可以是字符串或数字）
			
* action: 执行的动作。
	* print:换行
	* prntf：不换行

			# 换行输出
			df -h | awk '{printf "%s\n", $0}'
	* if：条件选择

			df -h | awk '{if (NR > 1) {print NR,$0}}'
	* for：
		
			awk 'BEGIN{for(i =0; i<10; i++){print i}}'
			awk 'BEGIN{names[1]="sun"; names[2]="fei"; for(id in names){print id, names[id]}}'
		
	注：支持break，continue语句

* 变量
	* 内部变量
		* 第几列: `$0 整行 $NF 最后一列 $(NF-1) 倒数第二列` 
		* F: 输入字段分割符，默认空白字符。
		* OFS：输出字段分割符，默认空白符。
		* RS： 输入记录分隔符（输入换行符）。
		* ORS：输出记录分隔符（输出换行符）。
		* NF：当前行字段个数，行被分割成了多少列。
		* NR：行号，当前处理的文本的行号。
		* FNR：各文件分别计数的行号。
		* FILENAME：当前文件名。
		* ARGC：命令行参数个数。
		* ARGV：数组，命令行指定的参数。

				 df -h | awk 'BEGIN{print "start ..."}{print NR,$1,$2}END{print "end ..."}'
	*  自定义变量：如果变量不是数字，则在执行数学运算时，变量的值会变成零
		* 使用自定以变量： `df -h | awk '{name="sun"; print name}'`
		* 引入sheel变量： `awk -v path=$PATH 'BEGIN{print path}'`
		* `df  | awk '{sum = sum + $2}; END{print sum}'`

## 使用示例

1. 输出第几列信息

		df -h | awk '{print $2}'
2. 拼接信息

		df -h | awk '{print "SIZE:"$2}'

1. 统计java dump文件线程状态。

		grep -i java.lang.Thread.State blogger.dump | awk '{print $2}' | sort | uniq -c
3. 输出奇偶行

		df -h | awk 'i=!i {print NR,$0}'
		df -h | awk '!(i=!i) {print NR,$0}'