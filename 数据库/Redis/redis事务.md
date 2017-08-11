## multi 事务  
代码1：

	redis 127.0.0.1:6379> multi
	OK
	redis 127.0.0.1:6379> sadd user:1 a
	QUEUED
	redis 127.0.0.1:6379> sadd user:1 b
	QUEUED
	redis 127.0.0.1:6379> exec    （1）
	1) (integer) 1
	2) (integer) 1
	redis 127.0.0.1:6379>
代码2：

	redis 127.0.0.1:6379> smembers user:1
	(empty list or set)
	redis 127.0.0.1:6379> smembers user:1
	1) "a"
	2) "b"
	redis 127.0.0.1:6379>  


说明：multi表明后面的命令将属于一个事务，exec当前事务结束。   
在代码执行到（1）之前，在另外一个客户端访问user:1 会提示(empty list or set)。步骤（1）执行完之后，再次访问能访问到，这说明事务起作用了。

* 事务中的错误处理   
1、语法错误：如果同一个事务中有命令的语法，则该事务中的所有指令都不会执行。  
2、运行错误：命令执行的时候出现错误，则错误的会被跳过，正确的都会执行。

## `watch` 的使用：

 * 监控一个或多个键，`watch` 之后一旦其中有一个键被修改或删除，在 `unwatch`之前，下一个事务的内容不会执行。  
 * 执行一次事务之后，watch的内容会自动被清空。  
 * 如果在事务中不执行任何操作，可以通过unwatch来取消关注，防止对下一次事务造成影响。  
 * watch和事务结合使用，可以防止事务执行之前事务中修改的内容被外部程序修改。  

		redis 127.0.0.1:6379> set key 1
		OK
		redis 127.0.0.1:6379> watch key
		OK
		redis 127.0.0.1:6379> set key 2
		OK
		redis 127.0.0.1:6379> multi
		OK
		redis 127.0.0.1:6379> set key 3
		QUEUED
		redis 127.0.0.1:6379> exec
		(nil)
		redis 127.0.0.1:6379> get key
		"2"
		redis 127.0.0.1:6379>

## expire 生存时间 
* `expire key time(s)` 设置key的生存时间，
*  `ttl key`  查看key的剩余生存时间，-不设置生存时间默认为-1

		redis 127.0.0.1:6379> set key 6
		OK
		redis 127.0.0.1:6379> expire key 20
		(integer) 1
		redis 127.0.0.1:6379> ttl key
		(integer) 7
		redis 127.0.0.1:6379> ttl key
		(integer) 5
		redis 127.0.0.1:6379> ttl key
		(integer) 4
		redis 127.0.0.1:6379> ttl key
		(integer) -1
		redis 127.0.0.1:6379> ttl key
		(integer) -1
		redis 127.0.0.1:6379> get key
		(nil)
		redis 127.0.0.1:6379>
* `persist key` 取消生存时间的设定，恢复为默认即没有生存时间，永久存在，使用set或者getset为键赋值会取消生存时间，expire重置键的生存时间，incr、lpush、hset、zrem等不会影响键的生存时间。

		redis 127.0.0.1:6379> set key 5
		OK
		redis 127.0.0.1:6379> expire key 20
		(integer) 1
		redis 127.0.0.1:6379> ttl key
		(integer) 17
		redis 127.0.0.1:6379> persist key
		(integer) 1
		redis 127.0.0.1:6379> ttl key
		(integer) -1
		redis 127.0.0.1:6379> get key
		"5"
		redis 127.0.0.1:6379>

* `pexpire pttl`等以毫秒为单位操作生存时间

* 访问控制（每分钟访问10次）：
* 1 、rate：limiting：$ip:每次对应的ip访问就把该键的值增1，如果是第一次则需要设置该键的生存时间为一分钟，同时整个程序要加入事务控制。
* 2 、把用户的访问时间放入列表中，如果列表的数量大于十，则判断最早的访问时间距现在的时间差是否小于1，如果是则访问次数超过限制，否则从列表中删除第一个，并把当前时间放入到列表中。

## 实现缓存

* 通过修改redis最大内存的配置，并配置内存超出时的策略
* 内存超出的策略：

	1、`volatile-lru`:使用LRU（最近最少使用）删除一个（设置了生存时间的）  
	2、`allkeys-lru`：使用LRU删除一个（所有）  
	3、`volatile-random`：随机删除一个（设置生存时间的）  
	4、`allkeys-random`：随机删除一个（所有）  
	5、`volatile-ttl`：删除生存时间最近的  
	6、`noeviction`：不删除键，只返回错误  

## 排序（很有用，只可以对列表，集合和有序集合进行排序）
`sort key`可以对列表，集合有序集合进行排序，在对有序集合进行排序的时候，排序的依据是元素自身而不是对应的分数。  

		redis 127.0.0.1:6379> exists user:2
		(integer) 0
		redis 127.0.0.1:6379> exists user:1
		(integer) 1
		redis 127.0.0.1:6379> sadd user:2 1
		(integer) 1
		redis 127.0.0.1:6379> sadd user:2 2
		(integer) 1
		redis 127.0.0.1:6379> sadd user:2 3
		(integer) 1
		redis 127.0.0.1:6379> sadd user:2 4
		(integer) 1
		redis 127.0.0.1:6379> sadd user:2 5
		(integer) 1
		redis 127.0.0.1:6379> sort user:2
		1) "1"
		2) "2"
		3) "3"
		4) "4"
		5) "5"
		redis 127.0.0.1:6379> sadd user:2 1.1
		(integer) 1
		redis 127.0.0.1:6379> sort user:2
		1) "1"
		2) "1.1"
		3) "2"
		4) "3"
		5) "4"
		6) "5"
		redis 127.0.0.1:6379>

* `sort key alpha`参照字典排序（默认情况排序的时候有字母会报错，指定 alpha 之后可以对包含字母的列表进行排序）

		redis 127.0.0.1:6379> sadd user:2 a
		(integer) 1
		redis 127.0.0.1:6379> sort user:2
		(error) ERR One or more scores can't be converted into double
		redis 127.0.0.1:6379> sort user:2 alpha
		1) "1"
		2) "1.1"
		3) "2"
		4) "3"
		5) "4"
		6) "5"
		7) "a"
		redis 127.0.0.1:6379>

* `sort key alpha desc` 倒序排序 
		
		redis 127.0.0.1:6379> sort user:2 alpha desc
		1) "a"
		2) "5"
		3) "4"
		4) "3"
		5) "2"
		6) "1.1"
		7) "1"
		redis 127.0.0.1:6379>

* `sort key alpha desc limit 1 2` 获取指定的元素

		# 跳过前一个元素依次取两个元素
		redis 127.0.0.1:6379> sort user:2 alpha desc limit 1 2
		1) "5"
		2) "4"
* `by` 根据别的元素进行排序，\*将映射成ids中的对应id，然后把id依据对应的computers\*中的num进行排序。看代码：

		redis 127.0.0.1:6379> lpush ids 1
		(integer) 1
		redis 127.0.0.1:6379> lpush ids 2
		(integer) 2
		redis 127.0.0.1:6379> lpush ids 3
		(integer) 3
		redis 127.0.0.1:6379> lpush ids 4
		(integer) 4
		redis 127.0.0.1:6379> hmset computers1 name c1 num 4
		OK
		redis 127.0.0.1:6379> hmset computers2 name c1 num 3
		OK
		redis 127.0.0.1:6379> hmset computers3 name c1 num 2
		OK
		redis 127.0.0.1:6379> hmset computers4 name c1 num 1
		OK
		redis 127.0.0.1:6379> sort ids by computers*->num
		1) "4"
		2) "3"
		3) "2"
		4) "1"
		redis 127.0.0.1:6379> sort ids by computers*->num desc
		1) "1"
		2) "2"
		3) "3"
		4) "4"
		redis 127.0.0.1:6379>
 依据字符串排序：

		redis 127.0.0.1:6379> set num:1 4
		OK
		redis 127.0.0.1:6379> set num:2 3
		OK
		redis 127.0.0.1:6379> set num:3 2
		OK
		redis 127.0.0.1:6379> set num:4 1
		OK
		redis 127.0.0.1:6379> sort ids by num:*
		1) "4"
		2) "3"
		3) "2"
		4) "1"
		redis 127.0.0.1:6379> sort ids by num:* desc
		1) "1"
		2) "2"
		3) "3"
		4) "4"
		redis 127.0.0.1:6379>

#### get 很强大的参数 可以从排序依据的数据中获取需要的信息
* `get members` 参数：可以使用其它的对应的值作为排序的结果。实现set排序

		redis 127.0.0.1:6379> sort ids by computers*->num desc get computers*->name
		1) "c1"
		2) "c1"
		3) "c1"
		4) "c1"
		redis 127.0.0.1:6379>
* `get #` 返回元素本身，即返回ids里面的内容

		redis 127.0.0.1:6379> sort ids by computers*->num desc get computers*->name  get #
		1) "c1"
		2) "1"
		3) "c1"
		4) "2"
		5) "c1"
		6) "3"
		7) "c1"
		8) "4"
		redis 127.0.0.1:6379>

* `store key` 保存排序后的结果,保存到列表中。

		redis 127.0.0.1:6379> sort ids by computers*->num desc get computers*->name  get # store sun
		(integer) 8
		redis 127.0.0.1:6379> lrange sun 0 -1
		1) "c1"
		2) "1"
		3) "c1"
		4) "2"
		5) "c1"
		6) "3"
		7) "c1"
		8) "4"
		redis 127.0.0.1:6379>

* 关于sort的性能优化，时间复杂度O(n+mlogm),n表示要排序的列表中的元素个数，m表示要返回的元素的个数,Redis在排序前会建立一个长度为n的容器来存储元素
  1. n尽量小，尽量减少待排序键中元素的个数。
  2. m尽量小，使用limit限制返回的元素的个数。
  3. 如果要排序的数据量很大，尽可能使用store参数缓存结果。

## 任务队列

`brpop queue times` 从队列中取元素，如果没有则等待一定的时间（s），当时间为零表示一直等待

		//打开两个客户端A和B
		在A中输入如下则会一直等待
		redis 127.0.0.1:6379> brpop queue 0
		//在B中执行
		redis 127.0.0.1:6379> lpush queue 10
		(integer) 1
		//则A中会出现如下响应
		redis 127.0.0.1:6379> brpop queue 0
		1) "queue"
		2) "10"
		(18.15s)
* 优先级队列(在前面的队列优先)，由于 `brpop` 当brpop后面的列表数量为多个的时候，如果所有的队列都堵塞，如果其中一个队列添加元素则从该队列取出元素，如果所有的都有元素，则按顺序，先从前面的队列取元素直至该队列阻塞，然后才从后面的队列中取元素。


		redis 127.0.0.1:6379> lpush queue1 11 12
		(integer) 2
		redis 127.0.0.1:6379> lpush queue2 21 22
		(integer) 2
		redis 127.0.0.1:6379> brpop queue1 queue2 0
		1) "queue1"
		2) "11"
		redis 127.0.0.1:6379> brpop queue1 queue2 0
		1) "queue1"
		2) "12"
		redis 127.0.0.1:6379> brpop queue1 queue2 0
		1) "queue2"
		2) "21"
		redis 127.0.0.1:6379> brpop queue1 queue2 0
		1) "queue2"
		2) "22"
		redis 127.0.0.1:6379> brpop queue1 queue2 0


## 发布/订阅 模式
发布订阅和使用的哪一个数据库没有关系。  
* `subscribe` 订阅

		redis 127.0.0.1:6379> subscribe cannel1
		Reading messages... (press Ctrl-C to quit)
		1) "subscribe"
		2) "cannel1"
		3) (integer) 1
		1) "message"
		2) "cannel1"
		3) "Hello World!"
		1) "message"
		2) "cannel1"
		3) "Hello World!"
		1) "message"
		2) "cannel1"
		3) "Hello World!"
		1) "message"
		2) "cannel1"
		3) "Hello World!"
		1) "message"
		2) "cannel1"
		3) "Hello World!"
* `publish`   发布 返回接收到消息的订阅者的个数

		redis 127.0.0.1:6379> publish cannel1 "Hello World!"
		(integer) 1

* `psubscribe` 根据规则订阅（订阅的频道名可以包含glob风格的通配符）

		//订阅客户端
		redis 127.0.0.1:6379> psubscribe cannel*
		Reading messages... (press Ctrl-C to quit)
		1) "psubscribe"
		2) "cannel*"
		3) (integer) 1
		1) "pmessage"
		2) "cannel*"
		3) "cannel1"
		4) "Hello World!"
		1) "pmessage"
		2) "cannel*"
		3) "cannel2"
		4) "Hello World!"

		//发布消息客户端
		redis 127.0.0.1:6379> publish cannel1 "Hello World!"
		(integer) 1
		redis 127.0.0.1:6379> publish cannel2 "Hello World!"
		(integer) 1

## 管道
同时执行多条命令，多条命令的结果不需要相互依赖。通过管道多条命令可以被一条请求完成，从而减少交互所需要的时间，达到节省时间的目的。

![管道详解图](http://7xle4i.com1.z0.glb.clouddn.com/mackdown管道.jpg)

## 如何节省空间
由于Redis是使用内存存储数据的，内存的容量有限，开发过程中我们需要节省内存从而节省空间。

1. 精简键名和键值来节省空间。
2. 内部编码优化。