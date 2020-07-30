时间：2018/12/10 12:05:59 

参考： 

1. [Redis Stream 简介](https://yq.aliyun.com/articles/495531?spm=a2c4e.11153940.blogcont603193.10.43055c4b82T2CI)
2. [Redis Stream——作为消息队列的典型应用场景](https://yq.aliyun.com/articles/603193)
1. [Introduction to Redis Streams](https://redis.io/topics/streams-intro)

## Redis Stream 

### 简介

Redis Stream 是Redis实现的一种流式存储结构。特性如下：

1. 使用消费者组的控制消息的发送。一条消息只会发送给消费者组中的一个消费者。
2. 消息确认机制，每个消费者维护一个自己消费消息的列表 （Pending List），消费者发送确认之后，才会从列表中删除。
3. 消费者停止服务之后，可以把消费者未确认的消息分配给其他消费者。
4. 每条消息有一个id，可以自己指定也可以系统生成，后面一条消息的id必须大于前面一条消息的Id。因此可以高效的根据ID范围进行查询。

在 Redis Stream 命令中，存在如下几个特殊id:

* `-` 最小id `0-1`。
* `+` 最大id `18446744073709551615-18446744073709551615`。
* `$` 当前 Stream 中最大的id。
* `>` 消费者组最后发布消息的id。
* `*` XADD 时使用，表示需要服务器初始化id。

### Redis Stream 操作命令

1. 添加消息: `XADD stream_name id filed1 value1 field2 value2`。

    示例：`XADD stream_name * name zhangsan age 24`

    添加成功之后返回消息的id，id传 `*` 表示自动生成id，生成id的格式 `时间戳(毫秒)-自增序列号（64位）`。如果服务器时间发生回退，自动生成的id的序列号会在之前最大的序列号的基础上开始增加。手动指定的id必须大于流中最大的id。

2. 查看流长度: `XLEN stream_name`。

3. 范围查找：`XRANGE stream_name start end [COUNT count]`

    ```shell
    # 查询所有
    XRANGE maxwell_stream - +
    # 查询指定时间戳范围内的数据 [1595557210652,1595557210652]
    XRANGE maxwell_stream 1595557210652 1595557210653
    XRANGE maxwell_stream 1595557210652-0 1595557210653-1
    # 限制返回数据的数量
    XRANGE maxwell_stream 1595557210652-0 1595557330653-0 COUNT 1
    ```
    
4. 倒序查询：`XREVRANGE stream_name end start [COUNT count]`

5. 读取流里面的数据：`XREAD [COUNT count] [BLOCK milliseconds] STREAMS stream_name id`。

    返回ID大于指定ID的数据，可以指定返回数据的数量，以及阻塞的时间。阻塞指的是没有数据的时候阻塞，有数据的时候即使数据的数量小于COUNT指定的个数也立即返回。

    ```shell    
    # 返回id大于 1595563390562-0 的所有元素
    XREAD STREAMS maxwell_stream 1595563390562-0
    # 返回id大于 0-0 的1条数据
    XREAD COUNT 1 STREAMS maxwell_stream 0-0
    # 阻塞获取直到有元素 0 表示阻塞知道有数据 $ 表示请求时流中最大的id
    XREAD BLOCK 0 STREAMS mystream $
    # 返回id大于 1595562850569-0 的20条数据，阻塞20秒
    XREAD COUNT 20 BLOCK 20000 STREAMS maxwell_stream 1595562850569-0
    ```

### 消费者组 

1. 每一条消息只会发送给消费者组中的一个消费者。
2. 通过消费者的名字区分消费者。
3. 消费者组存储下一个没有消费的Id，因此可以快速的发送消息给消费者。
4. 消费者需要处理完成之后需要返回确认信息确认消息已被消费。
5. 消费者组记录每个消费者等待处理的消息。

消费者组的数据结构如下:

```shell
+----------------------------------------+
| consumer_group_name: mygroup           |
| consumer_group_stream: somekey         |
| last_delivered_id: 1292309234234-92    |
|                                        |
| consumers:                             |
|    "consumer-1" with pending messages  |
|       1292309234234-4                  |
|       1292309234232-8                  |
|    "consumer-42" with pending messages |
|       ... (and so forth)               |
+----------------------------------------+
```

#### 消费者组相关命令

1. 管理消费者组。

    ```shell
    # 创建一个 mystream 的 消费者组，从大于0的id开始消费
    XGROUP CREATE mystream group_name 0
    # 创建一个 mystream 的 消费者组，如果流不存在则创建
    XGROUP CREATE mystream group_name 0 MKSTREAM
    # 消费一条未消费的消息 > 表示从未消费的消息中获取
    XREADGROUP GROUP group_name consumer_name COUNT 1 STREAMS stream_name >
    # 重新消费一条消费者已消费但未确认的消息 0-0 表示从已消费待处理列表中读取
    XREADGROUP GROUP maxwell_group c1 COUNT 1 STREAMS maxwell_stream 0-0
    # 确认消费消息,确认之后消息将从消费者等待处理的消息列表中删除，但是不会从流中删除
    XACK stream_name group_name 0-0
    # 查看待确认的消息
    XPENDING mystream group_name
    # 查看消费者待确认的消息
    XPENDING maxwell_stream group_name - + 10 consumer_name
    # 改变待处理消息的拥有者
    XCLAIM stream_name group_name consumer_name min-idle-time id
    # 查看流信息（长度、分组、第一个元素、最后一个元素，最后初始化id）
    XINFO STREAM stream_name
    # 查看流分组信息（消费者个数、最后一个消费消息的Id、等待处理的消息的个数）
    XINFO GROUPS stream_name
    # 查看流的分组的消费者信息
    XINFO CONSUMERS stream_name group_name
    # 设置流长度 只保存1000个元素
    XTRIM stream_name MAXLEN 1000
    # 设置流长度 至少保存1000个元素，比精确长度效率更高
    XTRIM stream_name MAXLEN ~ 1000
    # 删除元素
    XDEL stream_name 1526654999635-0
    ```