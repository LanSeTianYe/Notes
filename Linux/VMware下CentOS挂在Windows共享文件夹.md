## 
时间：2017/5/10 18:21:31   
环境：

 1. CentOS7
 2. Win8 64位

## 准备
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
		mount //192.168.1.68//share /mnt/share -o username=username,password=password 


	