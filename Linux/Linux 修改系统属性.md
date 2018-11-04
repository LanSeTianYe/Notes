## Linux 修改系统属性  

### 网络相关  
* 修改主机名： `vim /etc/hostname`
* 修改host : `vim /etc/hosts`  
* 配置静态IP地址（带*的是需要添加或编辑的），修改之后重启网络服务（`systemctrl restart network`）

		[root@localhost network-scripts]# cat /etc/sysconfig/network-scripts/ifcfg-ens33
		TYPE=Ethernet
		PROXY_METHOD=none
		BROWSER_ONLY=no
		* BOOTPROTO=static
		DEFROUTE=yes
		IPV4_FAILURE_FATAL=no
		* IPADDR=192.168.0.201
		* NETMASK=255.255.255.0
		* GATEWAY=192.168.0.2
		* DNS1=114.114.114.114
		IPV6INIT=yes
		IPV6_AUTOCONF=yes
		IPV6_DEFROUTE=yes
		IPV6_FAILURE_FATAL=no
		IPV6_ADDR_GEN_MODE=stable-privacy
		NAME=ens33
		UUID=2266e093-69a2-4554-a51f-43615bf711ae
		DEVICE=ens33
		* ONBOOT=true
		ZONE=
### 环境变量  

1. 打开配置文件 `vim /etc/profile`
	
2. 添加如下内容: 

		export JAVA_HOME="/usr/java/jdk1.8.0_77"`
		export CLASSPATH=".:$JAVA_HOME/lib:$JAVA_HOME/jre/lib"
		export PATH=":JAVA_HOME/bin:$PATH"

3. 刷新配置文件。
	
	 	source /etc/profile 



