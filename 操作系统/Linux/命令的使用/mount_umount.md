##  
时间：2017/5/10 18:38:32 
参考：

1. [http://man.linuxde.net/mount](http://man.linuxde.net/mount)

## mount
### 说明
mount命令用于加载文件系统到指定的加载点。此命令的最常用于挂载cdrom，使我们可以访问cdrom中的数据，因为你将光盘插入cdrom中，Linux并不会自动挂载，必须使用Linux mount命令来手动完成挂载。
### 语法
mount (选项) (参数)

### 选项

 > -V：显示程序版本；  
 > -l：显示已加载的文件系统列表；  
 > -h：显示帮助信息并退出；  
 > -v：冗长模式，输出指令执行的详细信息；  
 > -n：加载没有写入文件“/etc/mtab”中的文件系统；  
 > -r：将文件系统加载为只读模式；  
 > -a：加载文件“/etc/fstab”中描述的所有文件系统。
### 参数

* 设备文件名：要加载的文件系统对应的设备名。
* 加载点：加载到哪个目录。
### 例子

* VMware下CentOS挂在Windows共享文件夹

	1. 安装 `nfs` 和 `cifs` 支持
	
			//查看是否已经安装
			rpm -qa | grep "rpcbind"
			rpm -qa | grep "nfs"
			rpm -qa | grep "cifs"
	
			//安装	
			yum -y install nfs-utils rpcbind
			yum -y install cifs*
	
	2. 共享
	
		在windows下创建 share 文件夹，右键属性，在里面选择共享，并设置共享的可访问用户。
	2. 挂载
	
		创建挂载目录
		
			mkdir /mnt/share
		挂载
	
			//如果没有用户名和密码（共享有GUEST权限），可以不要 -o 和后面的内容，直接回车即可	
			mount //192.168.1.68/share /mnt/share -o username=username,password=password 




## umount

### 说明
umount命令用于卸载已经加载的文件系统。利用设备名或挂载点都能umount文件系统，不过最好还是通过挂载点卸载，以免使用绑定挂载（一个设备，多个挂载点）时产生混乱。

### 语法

	umount (选项) (参数)

### 选项

 > -a：卸除/etc/mtab中记录的所有文件系统；  
 > -h：显示帮助；  
 > -n：卸除时不要将信息存入/etc/mtab文件中；  
 > -r：若无法成功卸除，则尝试以只读的方式重新挂入文件系统；  
 > -t<文件系统类型>：仅卸除选项中所指定的文件系统；  
 > -v：执行时显示详细的信息；  
 > -V：显示版本信息。
### 参数

文件系统：要卸载的文件系统（linux目录）或其对应的设备文件名。

### 例子

* 卸载Windows共享

		mount //192.168.1.68//share /mnt/share
		umount -v /mnt/share
* 通过设备名卸载

		umount -v /dev/sda1

