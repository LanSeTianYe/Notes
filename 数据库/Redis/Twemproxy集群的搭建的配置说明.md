## 存在的问题

1. 虽然可以动态移除节点，但该移除节点的数据就丢失了。
2. redis集群动态增加节点的时候,twemproxy不会对已有数据做重分布.maillist里面作者说这个需要自己写个脚本实现。
3. 性能上的损耗，最差情况下，性能损耗不会多于20%。
4. 当一台Redis服务器A停止之后，原来映射到A的key会被映射到另一个服务器B中，重启A之后，原来的key还是映射在服务器B上。

## 命令

	Help
	Usage: nutcracker [-?hVdDt] [-v verbosity level] [-o output file]
	                  [-c conf file] [-s stats port] [-a stats addr]
	                  [-i stats interval] [-p pid file] [-m mbuf size]
	Options:
	  -h, --help             : 显示帮助
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
	  -m, --mbuf-size=N      : set size of mbuf chunk in bytes (default: 16384 byte

## 配置

> **listen**: The listening address and port (name:port or ip:port) or an absolute path to sock file (e.g. /var/run/nutcracker.sock) for this server pool.

> **client_connections**: The maximum number of connections allowed from redis clients. Unlimited by default, though OS-imposed limitations will still apply.  
> 
> **hash**: The name of the hash function. Possible values are:
>
	one_at_a_time
	md5
	crc16
	crc32 (crc32 implementation compatible with libmemcached)
	crc32a (correct crc32 implementation as per the spec)
	fnv1_64
	fnv1a_64
	fnv1_32
	fnv1a_32
	hsieh
	murmur
	jenkins

> **hash_tag**: A two character string that specifies(指定) the part of the key used for hashing. Eg "{}" or "$$". Hash tag enable mapping different keys to the same server as long as the part of the key within the tag is the same.  
> 
> **distribution**: The key distribution(分配) mode. Possible values are:
> 
  * ketama
  * modula
  * random
  
> **timeout**: The timeout value in msec that we wait for to establish（创建） a connection to the server or receive a response from a server. By default, we wait indefinitely(无限制).  
> 
> **backlog**: The TCP backlog argument. Defaults to 512.（TCP缓存的的命令大小）  
> 
> **preconnect**: A boolean value that controls if twemproxy should preconnect to all the servers in this pool on process start. Defaults to false.  
> 
> **redis**: A boolean value that controls if a server pool speaks redis or memcached protocol. Defaults to false.（服务缓冲池支持redis协议或者是分布式协议，默认false）  
> 
> **redis_auth**: Authenticate to the Redis server on connect.  
> 
> **redis_db**: The DB number to use on the pool servers. Defaults to 0. Note: Twemproxy will always present itself to clients as DB 0.(默认使用的Redis的数据库，默认是0号数据库)  
> 
> **server_connections**: The maximum number of connections that can be opened to each server. By default, we open at most 1 server connection.（每个服务可接受的连接的个数，默认为1）  
> 
> **auto_eject_hosts**: A boolean value that controls if server should be ejected temporarily when it fails consecutively `server_failure_limit` times. See liveness recommendations for information. Defaults to false.  （当一个主机连接失败`server_failure_limit` 次之后，是否临时的把他踢出。默认是false）  
> 
> **server_retry_timeout**:  The timeout value in msec to wait for before retrying on a temporarily ejected server, when auto_eject_host is set to true. Defaults to 30000 msec.（多长时间之后，重新连接已经被踢出的服务器，默认30000s）  
> 
> **server_failure_limit**: The number of consecutive failures on a server that would lead to it being temporarily ejected when **auto_eject_host** is set to true. Defaults to 2.（临时踢出的服务器连续失败的次数，默认是2）  
> 
> **servers**: A list of server address, port and weight (name:port:weight or ip:port:weight) for this server pool.（服务器列表）

		For example, the configuration file in conf/nutcracker.yml, also shown below, configures 5 server pools with names - alpha, beta, gamma, delta and omega. Clients that intend to send requests to one of the 10 servers in pool delta connect to port 22124 on 127.0.0.1. Clients that intend to send request to one of 2 servers in pool omega connect to unix path /tmp/gamma. Requests sent to pool alpha and omega have no timeout and might require timeout functionality to be implemented on the client side. On the other hand, requests sent to pool beta, gamma and delta timeout after 400 msec, 400 msec and 100 msec respectively when no response is received from the server. Of the 5 server pools, only pools alpha, gamma and delta are configured to use server ejection and hence are resilient to server failures. All the 5 server pools use ketama consistent hashing for key distribution with the key hasher for pools alpha, beta, gamma and delta set to fnv1a_64 while that for pool omega set to hsieh. Also only pool beta uses nodes names for consistent hashing, while pool alpha, gamma, delta and omega use 'host:port:weight' for consistent hashing. Finally, only pool alpha and beta can speak the redis protocol, while pool gamma, delta and omega speak memcached protocol.

such as

	alpha:
	  listen: 127.0.0.1:22121
	  hash: fnv1a_64
	  distribution: ketama
	  auto_eject_hosts: true
	  redis: true
	  server_retry_timeout: 2000
	  server_failure_limit: 1
	  servers:
	   - 127.0.0.1:6379:1
	
	beta:
	  listen: 127.0.0.1:22122
	  hash: fnv1a_64
	  hash_tag: "{}"
	  distribution: ketama
	  auto_eject_hosts: false
	  timeout: 400
	  redis: true
	  servers:
	   - 127.0.0.1:6380:1 server1
	   - 127.0.0.1:6381:1 server2
	   - 127.0.0.1:6382:1 server3
	   - 127.0.0.1:6383:1 server4
	
	gamma:
	  listen: 127.0.0.1:22123
	  hash: fnv1a_64
	  distribution: ketama
	  timeout: 400
	  backlog: 1024
	  preconnect: true
	  auto_eject_hosts: true
	  server_retry_timeout: 2000
	  server_failure_limit: 3
	  servers:
	   - 127.0.0.1:11212:1
	   - 127.0.0.1:11213:1
	
	delta:
	  listen: 127.0.0.1:22124
	  hash: fnv1a_64
	  distribution: ketama
	  timeout: 100
	  auto_eject_hosts: true
	  server_retry_timeout: 2000
	  server_failure_limit: 1
	  servers:
	   - 127.0.0.1:11214:1
	   - 127.0.0.1:11215:1
	   - 127.0.0.1:11216:1
	   - 127.0.0.1:11217:1
	   - 127.0.0.1:11218:1
	   - 127.0.0.1:11219:1
	   - 127.0.0.1:11220:1
	   - 127.0.0.1:11221:1
	   - 127.0.0.1:11222:1
	   - 127.0.0.1:11223:1
	
	omega:
	  listen: /tmp/gamma
	  hash: hsieh
	  distribution: ketama
	  auto_eject_hosts: false
	  servers:
	   - 127.0.0.1:11214:100000
	   - 127.0.0.1:11215:1

> 说明：上面的配置文件配置了5个服务器池，alpha, beta, gamma, delta 和 omega。

## 可观察性

twemproxy 通过日志和记录请求的指令来体现可观察性

	//查看记录的信息
	$ nutcracker --describe-stats

	llx@ubuntu:~/software/twemproxy/conf$ nutcracker -D
	This is nutcracker-0.4.1
	
	pool stats:
	  client_eof          "# eof on client connections"
	  client_err          "# errors on client connections"
	  client_connections  "# active client connections"
	  server_ejects       "# times backend server was ejected"
	  forward_error       "# times we encountered a forwarding error"
	  fragments           "# fragments created from a multi-vector request"
	
	server stats:
	  server_eof          "# eof on server connections"
	  server_err          "# errors on server connections"
	  server_timedout     "# timeouts on server connections"
	  server_connections  "# active server connections"
	  server_ejected_at   "timestamp when server was ejected in usec since epoch"
	  requests            "# requests"
	  request_bytes       "total request bytes"
	  responses           "# responses"
	  response_bytes      "total response bytes"
	  in_queue            "# requests in incoming queue"
	  in_queue_bytes      "current request bytes in incoming queue"
	  out_queue           "# requests in outgoing queue"
	  out_queue_bytes     "current request bytes in outgoing queue"

查看运行状态：

	curl 127.0.0.1:22222 -o status.txt

结果：

	{
	    "service": "nutcracker",
	    "source": "ubuntu",
	    "version": "0.4.1",
	    "uptime": 2919,
	    "timestamp": 1494436791,
	    "total_connections": 1991,
	    "curr_connections": 3,
	    "lpha": {
	        "client_eof": 1950,
	        "client_err": 38,
	        "client_connections": 0,
	        "server_ejects": 0,
	        "forward_error": 0,
	        "fragments": 0,
	        "192.168.0.128:6379": {
	            "server_eof": 0,
	            "server_err": 0,
	            "server_timedout": 0,
	            "server_connections": 0,
	            "server_ejected_at": 0,
	            "requests": 0,
	            "request_bytes": 0,
	            "responses": 0,
	            "response_bytes": 0,
	            "in_queue": 0,
	            "in_queue_bytes": 0,
	            "out_queue": 0,
	            "out_queue_bytes": 0
	        },
	        "192.168.0.129:6379": {
	            "server_eof": 0,
	            "server_err": 0,
	            "server_timedout": 0,
	            "server_connections": 1,
	            "server_ejected_at": 0,
	            "requests": 100000,
	            "request_bytes": 3600000,
	            "responses": 100000,
	            "response_bytes": 788895,
	            "in_queue": 0,
	            "in_queue_bytes": 0,
	            "out_queue": 0,
	            "out_queue_bytes": 0
	        },
	        "192.168.0.130:6379": {
	            "server_eof": 0,
	            "server_err": 0,
	            "server_timedout": 0,
	            "server_connections": 1,
	            "server_ejected_at": 0,
	            "requests": 900988,
	            "request_bytes": 261711008,
	            "responses": 900988,
	            "response_bytes": 5304940,
	            "in_queue": 0,
	            "in_queue_bytes": 0,
	            "out_queue": 0,
	            "out_queue_bytes": 0
	        }
	    }
	}




