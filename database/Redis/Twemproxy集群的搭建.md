## 说明

 * 环境介绍：
   * Ubuntu虚拟机1个- 安装Twemproxy和Redis
   * CentOS虚拟机3个- 安装Redis
 * 参考：  
	 * [基于Twemproxy的Redis集群方案](http://www.cnblogs.com/haoxinyue/p/redis.html)  
	 * [Redis集群搭建最佳实践](http://www.tuicool.com/articles/iquMRn)  
	 * [twemproxy介绍与安装配置](http://mdba.cn/?p=157)
## 安装
1. 下载  

		git clone https://github.com/twitter/twemproxy.git
2. 依赖包的安装

		sudo apt-get install automake
		sudo apt-get install libtool
2. 安装，进入目录
		
		root@ubuntu:/home/llx/software# cd twemproxy/
		root@ubuntu:/home/llx/software# autoreconf -fvi
		root@ubuntu:/home/llx/software# ./configure --enable-debug=full
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
4. 进行简单的配置。在 `twemproxy` 的 `conf`目录下面创建测试的配置文件`testconf.yml` ,在文件中添加如下内容：

		lpha:
		  listen: 127.0.0.1:55555		//对外暴露的端口
		  hash: fnv1a_64				//使用的hash算法
		  distribution: ketama			//三种 ketama， modula，random
		  auto_eject_hosts: true		//是否自动一处失败节点
		  redis: true					//使用的是redis集群
		  server_retry_timeout: 30000	//服务响应的超时时间
		  server_failure_limit: 1		//
		  servers:						//配置管理的服务器
		    - 192.168.0.128:6379:1		//iP地址：端口：比重
		    - 192.168.0.129:6379:1	    //iP地址：端口：比重
		    - 192.168.0.130:6379:1	    //iP地址：端口：比重
5. 启动集群

		root@ubuntu:/home/llx/software/twemproxy# ./src/nutcracker -c ./conf/testconf.yml 

		[2015-11-16 23:04:11.242] nc.c:187 nutcracker-0.4.1 built for Linux 3.13.0-67-generic x86_64 started on pid 20589

		[2015-11-16 23:04:11.242] nc.c:192 run, rabbit run / dig that hole, forget the sun / and when at last the work is done / don't sit down / it's time to dig another one

6. 启动redis服务

7. 连接集群

		redis-cli -p 55555

## 性能测试
在Ubuntu上，用192.168.0.128上的Redis进行测试和 `twemproxy` 集群进行测试。

**测试前提** ： 

twemproxy配置文件如下：

	lpha:
	  listen: 127.0.0.1:55555
	  hash: fnv1a_64
	  distribution: ketama
	  auto_eject_hosts: true
	  redis: true
	  server_retry_timeout: 30000
	  server_failure_limit: 1
	  servers:
	    - 192.168.0.128:6379:1
	    - 192.168.0.129:6379:1
	    - 192.168.0.130:6379:1

**测试条件：** 10000条记录100的并发量。

 	redis-benchmark -h 192.168.0.131 -p 55555 -t get -n 100000 -c 100 -q
 	redis-benchmark -h 192.168.0.128 -p 6379 -t get -c 100 -n 100000 -q

**测试结果** 

|类型|twemproxy(s)|Redis(s)|
|::|::|::|
|get|38138|16949|
|set|34662|18214|
|mset|21753|16152|
|lpush|34305|15671|




