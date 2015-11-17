## 安装

 > 环境介绍：Win8和Win8下面的Ubuntu虚拟机。  
 > [基于Twemproxy的Redis集群方案](http://www.cnblogs.com/haoxinyue/p/redis.html)  
 > [Redis集群搭建最佳实践](http://www.tuicool.com/articles/iquMRn)  
 > [twemproxy介绍与安装配置](http://mdba.cn/?p=157)

1. 下载  

		git clone https://github.com/twitter/twemproxy.git

2. 安装，进入目录
		
		root@ubuntu:/home/llx/software# cd twemproxy/
		root@ubuntu:/home/llx/software# ./configure 
		root@ubuntu:/home/llx/software/twemproxy# make && make install

3. 查看是否安装成功

		root@ubuntu:/home/llx/software/twemproxy# src/nutcracker -h
		This is nutcracker-0.4.1
		
		Usage: nutcracker [-?hVdDt] [-v verbosity level] [-o output file]
		                  [-c conf file] [-s stats port] [-a stats addr]
		                  [-i stats interval] [-p pid file] [-m mbuf size]
		
		Options:
		  -h, --help             : this help
		  -V, --version          : show version and exit
		  -t, --test-conf        : test configuration for syntax errors and exit
		  -d, --daemonize        : run as a daemon
		  -D, --describe-stats   : print stats description and exit
		  -v, --verbose=N        : set logging level (default: 5, min: 0, max: 11)
		  -o, --output=S         : set logging file (default: stderr)
		  -c, --conf-file=S      : set configuration file (default: conf/nutcracker.yml)
		  -s, --stats-port=N     : set stats monitoring port (default: 22222)
		  -a, --stats-addr=S     : set stats monitoring ip (default: 0.0.0.0)
		  -i, --stats-interval=N : set stats aggregation interval in msec (default: 30000 msec)
		  -p, --pid-file=S       : set pid file (default: off)
		  -m, --mbuf-size=N      : set size of mbuf chunk in bytes (default: 16384 bytes)
4. 进行简单的配置，软件目录下面的conf目录下面创建一个测试的配置文件（./conf/testconf.yml）,在文件中添加如下内容：

		lpha:
		  listen: 127.0.0.1:55555
		  hash: fnv1a_64
		  distribution: ketama
		  auto_eject_hosts: true
		  redis: true
		  server_retry_timeout: 30000
		  server_failure_limit: 1
		  servers:
		    - 192.168.23.1:6379:1
		    - 127.0.0.1:6379:1

 * 配置详解

			lpha:
			  listen: 127.0.0.1:55555		//对外暴露的端口
			  hash: fnv1a_64				//使用的hash算法
			  distribution: ketama			//三种 ketama， modula，random
			  auto_eject_hosts: true		//是否自动一处失败节点
			  redis: true					//使用的是redis集群
			  server_retry_timeout: 30000	//服务响应的超时时间
			  server_failure_limit: 1		//
			  servers:						//配置管理的服务器
			    - 192.168.23.1:6379:1		//redis服务器的地址和端口（windows）
			    - 127.0.0.1:6380:1			//redsi服务器的地址和端口(虚拟机)
5. 启动集群

		root@ubuntu:/home/llx/software/twemproxy# ./src/nutcracker -c ./conf/testconf.yml 
		[2015-11-16 23:04:11.242] nc.c:187 nutcracker-0.4.1 built for Linux 3.13.0-67-generic x86_64 started on pid 20589
		[2015-11-16 23:04:11.242] nc.c:192 run, rabbit run / dig that hole, forget the sun / and when at last the work is done / don't sit down / it's time to dig another one

6. 启动redis服务（使用单机测试）

		windows：直接运行redis-server.exe即可
		ubuntu :执行下面的命令
		redis-server -p 6379
7. 连接集群

		redis-cli -p 55555

