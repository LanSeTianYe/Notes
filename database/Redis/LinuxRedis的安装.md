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
		