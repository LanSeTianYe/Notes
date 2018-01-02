时间：2017/12/16 10:19:01 

参考：  

1. 鸟哥的Linux私房菜：基础学习篇 第四版

## shell基础  
* 查看 系统支持的shell

		cat /etc/shells
* 查看用户对应的shell

		cat /etc/password
* 查看历史指令  

		cat ~/.bash_history
* 查看以及设置别名  

		# 查看
		alias
		# 设置
		alais lm='ls -al'
* 查看指令是否是内置 `type [-tpa] name`。
* 指令太长换行的时候可以用 `\`, `\` 之后的一个输入会被转至。
* 光标移动  
	* `ctrl + u` 删除光标前面的
	* `ctrl + k` 删除光标和光标后面的
	* `ctrl + a` 光标移动到最前
	* `ctrl + e` 光标移动到最后
### 基本语法
1. 定义以及输出变量
	 
		# 定义，
		name=123				//123
		name=${name}123			//123
		name="${name}'123'"		//123123'123'
3. 定义变量的类型 `declare`。  
	
	* -i 整形
	* -a 数组
	* -x 定义为环境变量
	* -r 将变量设置为只读类型

### 命令

#### 命令查找顺  

1. 当前目录
2. 别名
3. bash内置的指令
4. PATH指定的目录里面

查看命令的来源 `type -a mingling`
 
#### 常用命令
* uname：查看系统信息（内核版本、名字等）。
* locale：查看系统编码。
* 读取参数 `read [-pt]`，`-p` 指定提示信息，`-t` 指定等待时间。

		read -p "Plese Input you name" -t 30 name 
* 系统限制 `ulimit -a`
* 别名: `alais`
 
		# 指定别名可以在命令行使用或者在 ~/.bashrc 里面添加(需要执行刷新命令 `source ~/.bashrc`)  
		alias gohome='cd /home/xiaotian/workspace'
* `history` 查看输入的命令历史
	
		history 查看命令历史
		!number 指定历史记录的第n个指令
		!!执行上一个指令
		!al 执行最近执行的以 al 开头的指令
* `cut` 切割文件，使用指定的字符切割文件

		# 用 : 分割每一行数据，每一行分割后的第一部分
		cat test.txt | cut -d ':' -f 1 
* `grep` 找出匹配行
* `sort` 排序 
* `uniq` 去重
* `wc [-lwm]` 统计单词信息，lwm分别是行、单词个数和字符个数。
* `tee` 把标准输入写入输出（文件或标准输出） `ping www.baidu.com | tee -a ping.txt`
*  `tr` 删除或者转换字符，`cat test.txt | tr -s [a-z] [A-Z]` 小写转换为大写。
*  `join` 拼接数据 `join -t ":" -1 2 join1.txt join2.txt`
*  `paste` 直接两个文件的对应行拼接在一起。
*  `split` 分割文件
*  `xargs` 传递参数。

		# 把用户名传递给id指令
		cut -d ":" -f 1 /etc/passwd | head -n 10 | xargs -n 1 id
		# 把用户名传递给id指令,每次询问
		cut -d ":" -f 1 /etc/passwd | head -n 10 | xargs -n 1 id
		# 把用户名传递给id指令,遇到 `sync` 参数时停止
		cut -d ":" -f 1 /etc/passwd | head -n 3 | xargs -e'sync' -n 1 id
		# 输出查询到的文件
		find / -name "*nginx*" | xargs ls  -l
		# 输出查询到的文件
		ls -al $(find / -name *nginx*)
* `sed -n '5,10p' filename` 显示文件第[5,10)行。
* `cat filename| head -n 3000 | tail -n +1000` 显示文件1000到3000行 [1000,30000)
* `cat filename| tail -n +3000 | head -n 1000` 显示文件3000到4000行 [1000,4000]
* `tail filename -n 1000` 显示文件的后1000行 
	

	 
		
		
