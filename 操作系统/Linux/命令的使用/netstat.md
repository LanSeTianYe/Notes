时间：2017-06-03 22:45:19   

参考：

1. [http://man.linuxde.net/netstat](http://man.linuxde.net/netstat)

##  Netstat

1. 简介

    打印网络连接信息。输出的信息类型根据第一个参数的不同而不同包含：

	* network connections
	* routing tables
	* interface statistics 
	* masquerade connections
	* multicast memberships

2. 语法
	
		netstat [options ...]
3. 第一个选项
   
	* (none) 默认情况， 显示被打开的socket列表
	* --route, -r 显示路由表
	* --groups, -g 显示组播信息
	* --interfaces, -i 显示所有的网络接口表，网卡
	* --masquerade, -M 
	* --statistics, -s

5. 其他选项

	* --all, -a 显示所有端口
	* --verbos, -V 显示指令执行过程
	* --tcp, -t 显示tcp连接状况
	* --udp, -u 显示udp连接状况
	* --numeric, -n 显示数字IP地址，而不是域名
 	* --extend, -e 显示附加信息
  	* --listening, -l 只显示监听的Socket,默认参数
	* --program, -p 显示scoket所属的应用程序的Pid和名字

4. 实例

  1. 显示所有端口
  
			netstat -a
  2. 显示所有tcp连接
  			
			netstat -at

  3. 过滤包含88的端口
  
			netstat -an | grep 88 
