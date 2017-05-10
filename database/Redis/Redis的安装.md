## Redis的安装

1. 下载安装

		$ wget http://download.redis.io/releases/redis-3.2.8.tar.gz
		$ tar xzf redis-3.2.8.tar.gz
		$ cd redis-3.2.8
		$ make
2. 启动服务

		//默认启动
		$ src/redis-server
		//指定配置文件
		$ src/redis-server ./redis.conf

3. 启动命令行

		//连接本机服务
		$ src/redis-cli
		//连接指定Redis服务(指定ip和端口)
		$ src/redis-cli -h 192.168.0.1 -p 6379 
		
## 遇到的问题

**问题**：访问其他机器上的Redis服务时，会出现如下问题。

	DENIED Redis is running in protected mode because protected mode is enabled, no bind address was specified, no authentication password is requested to clients.In this mode connections are only accepted from the loopback interface. If you want to connect from external computers to Redis you may adopt one of the following solutions:
 
	1) Just disable protected mode sending the command 'CONFIG SET protected-mode no' from the loopback interface by connecting to Redis from the same host the server is running, however make sure Redis is not publicly accessible from internet if you do so. Use CONFIG REWRITE to make this change permanent.
   
	2) Alternatively you can just disable the protected mode by editing the Redis configuration file, and setting the protected mode option to 'no', and then restarting the server.
   
	3) If you started the server manually just for testing, restart it withthe '--protected-mode no' option.
   
	4) Setup a bind address or an authentication password.

	NOTE: You only need to do one of the above things in order for the server to start accepting connections from the outside.
**解决方法**
	
  方案一： 服务器Redis绑定IP地址。  
  方案二： 注释 bind配置，设置 `protected model` 为 `no`。   
