
* 环境

* CentOS 7 虚拟机

## 配置静态IP
	
1. 修改配置文件（带*的是需要添加或编辑的）

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

2. 重启网络服务

		systemctl restart network

## ssh 免密码登陆

1. 生成SSH密钥信息。

		ssh-keygen # 一直按回车

2. 发送密钥到其它主机。 

		ssh-copy-id -i /root/.ssh/id_rsa.pub root@192.168.0.201 
3. sshd 登陆

		ssh root@192.168.0.201