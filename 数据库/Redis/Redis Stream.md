时间：2018/12/10 12:05:59   
参考：  

1. [Redis Stream 简介](https://yq.aliyun.com/articles/495531?spm=a2c4e.11153940.blogcont603193.10.43055c4b82T2CI)
2. [Redis Stream——作为消息队列的典型应用场景](https://yq.aliyun.com/articles/603193)
1. [Introduction to Redis Streams](https://redis.io/topics/streams-intro)

## Redis Stream  

### 简介

Streams是这样一种数据结构，可以往里面添加数据，可以根据范围查询里面的数据，每一条记录都对应一个Id，Redis自动生成的Id `毫秒-毫秒内自增序号`，也可以阻塞读取里面的数据，当没有数据的时候等待一段时间。提供消费者组概念，同一个 `Stream` 里面的数据只会被组里面的一个消费者消费一次，消费的消息被记录到 Pending Entrty List（PEL），当消费者发送 ACK 确认消费之后从 PEL 中删除。如果消费者没有来得及发送确认消息就挂掉，可以更改 Pending Entrty List 中被消费消息的所有者，指定到其他消费者再次消费。不保证数据只被消费一次，存在重复消费的问题。

### 命令  

* 添加消息： `XADD stream_name id filed1 value1 field2 value2 ...`
	* 返回值为添加的信息的ID。
	* id 可以指定为具体的值，也可以有系统自动生成，自动生成格式 `毫秒-递增数字`
* 删除消息：`XDEL stream_name 1538561700640-0`，底层标记删除，当节点的消息都被标记为删除的时候节点才会被真正删除。 
* 流长度： `XLEN stream_name`
* 读取消息：`XREAD COUNT 10 STREAMS mystream mystream 0-0 0-0`，从多个流中读取数据，每个流读取指定数量。
* 阻塞读取消息：`XREAD BLOCK 5000 COUNT 100 STREAMS mystream $`。
* 获取指定范围内的消息： `XRANGE stream_name start end COUNT messagecount`
	* start 可以为 `-` 表示最小的Id， end 可以为 `+` 表示最大的Id。
	* `COUNT` 限制返回数据的个数。   
* 获取指定范围内的消息（反向）：`XREVRANGE mystream end start count 2`。
* 获取流相关信息： `XINFO option key`
	* option 为 STREAM：返回流长度，第一个元素和最后一个元素等信息，消费者组个数，以及 `RADIX Tree` 相关信息。
	* option 为 GROUPS：返回流相关的消费者组。

			1) 1) "name"
			2) "mygroup"
			3) "consumers"
			4) (integer) 2
			5) "pending"
			6) (integer) 3
			7) "last-delivered-id"
			8) "1544410846131-0"
	* option 为 CONSUMERS：返回流相关的消费者组的消费者的信息。

			1) 1) "name"
			   2) "myconsumer1"
			   3) "pending"
			   4) (integer) 2
			   5) "idle"
			   6) (integer) 90186411
			2) 1) "name"
			   2) "myconsumer2"
			   3) "pending"
			   4) (integer) 1
			   5) "idle"
			   6) (integer) 91258073
* 消费者组：` XGROUP <subcommand> arg arg ... arg.`
	* 创建消费者组：`XGROUP CREATE stream_name group_name id`, id 表示最从那个消息开始读取（0第一个，$最新）。
	* 删除消费者组：`XGROUP DESTROY stream_name group_name`。
	* 删除消费者组中的消费者：`XGROUP DELCONSUMER stream_name group_name consumer_name`。
	* 设置消费者组消费消息的ID（用于重新消费消息）：`XGROUP SETID stream_name group_name 0`。
* 获取消费者组消费信息：`XPENDING stream_name group_name - + count`

		127.0.0.1:7006> XPENDING mystream mygroup - + 1000
		1) 1) "1544410840356-0"
		   2) "myconsumer1"
		   3) (integer) 95522233
		   4) (integer) 1
		2) 1) "1544410844331-0"
		   2) "myconsumer2"
		   3) (integer) 95518258
		   4) (integer) 1
		3) 1) "1544410846131-0"
		   2) "myconsumer1"
		   3) (integer) 94446596
		   4) (integer) 1
* 确认消息被消费：`XACK stream_name group_name ID [ID ...]`， 每次消费者消费成功之后调用，防止消息被消费多次。
* 修剪流的长度：`XTRIM mystream MAXLEN 1000` 和 `XTRIM mystream MAXLEN ~ 1000`。第一个精确删除，第二个非精确甚于数量可能大于等于 1000。
* 改变消息在分组中的归属者(重新消费消息消费者组列表的)：`XCLAIM stream_name group_name consumer_name 36000 1544410840356-0`, Pending Entity List 里面的Id为  `1544410840356-0` 的消息的所有者为 `consumer_name`。

