时间：2019/1/26 11:39:32   

参考： 

## 用户和文件系统  

Linux 分为两种用户超级管理员（root）和普通用户，超级管理员拥有系统的一切权限，其它用户则拥有分配的权限。  
文件或目录会有所属者和所属分组这两个属性，在Linux中文件系统的权限分为三维度， 拥有着、所属组和其它用户，每个维度细分为 读写执行（421），拥有相应权限才能执行对应的操作。

单一文件或目录的最大容许文件名为 255Bytes，以一个 ASCII 英文占用一个 Bytes 来说，则大约可达 255 个字符长度。若是以每个中文字占用 2Bytes 来说， 最大文件名就是大约在 128 个中文字之谱！

### 用户  

每个用户可以属于多个群组，创建用户时如果不指定所属组，则会默认创意一个和用户名相同的用户组。当用户属于多个组时，只有有效组的权限才会起作用。



#### 相关命令  

* `useradd` ：添加用户，不指定用户组则默认创意一个和用户名字相同的群组。

	 	useradd -g group_name user_name      # 指定用户分组
 		useradd -u number(>1000) user_name   # 指定用户Id（UID）
		useradd -r user_name                 # 创建系统用户
		useradd -D                           # 查看命令默认值

* `usermod`：修改用户信息

		usermod -c "账号说明" user_name
		usermod -l new_name old_name
* `userdel`：删除用户。

		userdel -r user_name 同时删除用户主目录
* `password`： 修改或设置用户密码

		passwd xiaotian
* `id`：查看用户ID和用户的组ID信息
		
		id user_name
* `groups`: 查看用户所属分组，第一个是有效组
* ` groupadd`：添加分组

		groupadd group_name
		groupadd -g gid group_name
* `groupmod`：变更分组信息

		groupmod [-g gid] [-n group_name] 群组名
* `groupdel`：删除分组

		groupdel group_name
* `newgrp`: 变更用户的有组,操作完成之后 exit 切换回原来有效组。

		newgrp group_name	
* 普通用户密码切换到root用户	

		# 替换文件内容
		root$ visudo
		User_Alias  ADMINS = xiaotian, xiaotian2
		ADMINS ALL=（root）  /bin/su -
        xiaotian$ sudo su -
### 文件系统 

文件的三个时间：

 * 访问时间：读取文件内容会更新该时间。
 * 状态时间：文件的状态变更之后会更新该时间。
 * 变更时间：文章内容变更会更新该时间。 

文件的所属者的权限：  

* 拥有者：创建文件的人的权限。
* 组：属于组里面的人的权限。
* 其它：非组里面人的权限
文件属性：

* `d` 目录  
* `-` 正规文件
* `l` 链接文件
* `b` 设备文件里面的可供储存的周边设备（可随机存取设备）。
* `c` 设备文件里面的序列埠设备，例如键盘、鼠标（一次性读取设备）。
* `s` socket 文件，用于网络数据通信。
* `p` 数据输送文件（FIFO, pipe），FIFO也是一种特殊的文件类型，他主要的目的在解决多个程序同时存取一个文件所造成的错误问题。

权限属性： 

* 文件： 
	
	* 读：读取文件内容
	* 写：写数据到文件
	* 执行：执行文件

* 目录： 

	* 读：可以读取目录下文件的列表等
	* 写：
		* 再该目录下创建新文件和目录
		* 删除该目录下已经存在的文件和目录，和对文件拥有的权限没有关系。
		* 重命名该目录下的文件和目录
		* 移动该目录下的文件和目录
	* 执行：
	
		* 能否进入该文件。

#### 常用命令：

* ls (list directory contents)：列出目录里的内容。

		ls -a 显示所有文件包含颖仓文件
		ls -A 显示所有文件包含颖仓文件，不显示 . 和 ..
		ls -l 文件详细属性
		ls -h 易读方式 
		ls -d 当前目录的属性
		ls -S 文件大小排序
		ls -t 时间排序
		ls --full-time 显示完整时间

* cd (change directory): 切换目录。 

		cd .
		cd ..
		# 切换到上一个工作目录
		cd -
		cd ~
		cd ~ user_name

* `pwd` (print workign directory)：显示当前目录。 
   
		pwd
		# 显示链接的目录
		pwd -P
* `mkdir`（make directory）：创建目录。

		mkdir /home/test/sun/
		# 父目录不存在自动创建父目录，存在的话也不报错
		mkdir -p /home/test/sun/
		# 指定目录权限
		mkdir -m 711 /home/test/sun/
* `rmdir` (remove directory) 删除空目录。

 		rmdir /home/test/sun/
		# 删除上级空目录
	 	rmdir -p  /home/test/sun/
* `rm` (rmove) 删除文件或文件夹

		rm file_name
		rm -r directory
		rm -f file_name
* `cp`（copy）:复制文件。

		cp -r directory
		cp file directory/
		cp -a file direcctory  # 同时复制文件创建时间等
		cp -l file directory   # 文件复制
		cp -s file directory   # 链接复制
		cp -u                  # 当文件比目标文件新时才复制

* `mv` (movie)：移动文件。

		mv -f    # 强制覆盖不询问
		mv -u    # 比较时间，当目标价文件比较旧时才复制
		mv bashrc1 bashrc2 mvtest2

* `basename`: 获取文件名。
* `dirname` ：获取路径名。
* `cat`：（Concatenate）正序输出文件内容
	
		cat -n  # 显示行号
		cat -nb # 空白行不计算行数
		cat -A  # 显示特殊字符
* `tac`: 倒着输出文件内容。
* `less`：一页一页显示文件内容，前后翻页
* `more`: 一页一页显示文件内容，向后翻页。
* `tail`: 前几行。

		tail -n number   # 显示后number行
		tail -n +number   # 显示第number行之后的行
* `head`：后几行。
		head -n numer   # 显示前number行
		head -n -number # 显示倒数第numbe行前面的内容
* `od`: 以二进制方式浏览文件内容。
* `nl`：添加行号打印。

		-b  ：指定行号指定的方式，主要有两种：
		      -b a ：表示不论是否为空行，也同样列出行号（类似 cat -n）；
		      -b t ：如果有空行，空的那一行不要列出行号（默认值）；
		-n  ：列出行号表示的方法，主要有三种：
		      -n ln ：行号在屏幕的最左方显示；
		      -n rn ：行号在自己字段的最右方显示，且不加 0 ；
		      -n rz ：行号在自己字段的最右方显示，且加 0 ；(005)
		-w  ：行号字段的占用的字符数。
* `touch`： 修改文件更新时间或创建文件

		touch -a  # 修改访问时间
		touch -m  # 修改变更时间
* `chgrp`：(change group) 改变文件分组

		chgrp xiaotian 123.txt   # 改变所属分组为 xiaotian
		chgrp -R directory       # 递归操作，改变文件加下所有文件的所属分组
* `chown`：(change owner) 改变文件拥有者

		chown xiaotian 123.txt    #改变文件拥有着
		chown xiaotain:xiaotian   #改变文件所属组和拥有者
* `chmod`：改变文件权限，(rwx 421)。

		chmod -R directory
		chmod [ugo][+-=][rwx]
		chmod u=rwx,go=r xiaotian.txt