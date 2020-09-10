时间: 2020-07-23 10:33:33

## Redis PubSub 介绍 

Redis Pub/Sub 是 Redis 实现的发布订阅模式，用于解耦生产者和消费者。生产者向管道发送消息，不用关心消费者具体是谁，消费者从管道读取消息，不用关心发送者是谁。生产者和消费者只需要知道 Redis  的存在即可。

Redis Pub/Sub 的底层是 `channel`，不属于任何一个数据库。消费者只能获取到订阅之后的消息，订阅之前的消息，如果生产者发送消息的时候，没用消费之订阅 `channel` 消息将被丢弃。

发送者可以有一到多个，消费者也可以有一到多个。消费者订阅之后可以收到所有发送到管道中的消息。

### 常用命令 

1. 订阅

    `PSUBSCRIBE` 订阅多个管道的时候，如果有多个规则匹配到消息的来源管道，消息会被接收多次。比如说：消费者订阅 `c* ch* ch1`，生产者向 `ch1` 发送一个消息，则消费者会收到三次消息，接收到消息唯一不同的地方是匹配的模式。`SUBSCRIBE` 则不会出现这种情况。

    ```shell
    # 订阅一个。ch1 是订阅的管道名称
    SUBSCRIBE ch1
    # 订阅一个。ch* 是订阅的管道名称, 接收发送到 ch* 的消息，*不是通配符。
    SUBSCRIBE ch*
    # 订阅多个。ch1 ch2 ch3 是订阅的管道名称
    SUBSCRIBE ch1 ch2 ch3
    # 订阅一个，通配符。ch* 是订阅的管道
    PSUBSCRIBE ch*
    # 订阅多个，通配符。ch* 和 pch* 是订阅的管道
    PSUBSCRIBE ch* pch*
    ```

2. 发送消息

    ```shell
    # 发送消息 ch1 管道名字 a 发送的内容
    PUBLISH ch1 a
    ```

3. 取消订阅

    ```shell
    # 取消订阅所有 
    UNSUBSCRIBE
    # 取消订阅指定渠道
    UNSUBSCRIBE ch1
    # 取消订阅，取消一个。通配符 ch.* 管道
    PUNSUBSCRIBE ch.*
    # 取消订阅，取消多个。通配符 ch.* psc* 管道
    PUNSUBSCRIBE ch.* psc*
    ```
4. 查看管道状态

    ```shell
    # 查看当前正在使用的管道（当前正在被订阅的管道）
    PUBSUB CHANNELS *
    # 查看管道订阅者的数量，值返回SUBSCRIBE
    PUBSUB NUMSUB ch1
    # 查看所有被订阅的模式的数量
    PUBSUB NUMPAT
    ```
