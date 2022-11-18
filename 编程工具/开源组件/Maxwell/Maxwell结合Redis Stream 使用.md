时间：2020-08-31 10:35:35

参考：

1. [Maxwell 官网](http://maxwells-daemon.io/)

## Maxwell 结合 RedisStream 使用

Maxwell 读取Mysql的binlog监听数据库数据变更，然后把数据以JSON格式发送到 Redis Stream 做消息缓存，然后客户端从RedisStream中读取读取数据，解析数据并根据数据类型触发对应的业务。

### 配置信息

```shell
# 消息发送到哪里 stdout|file|kafka|kinesis|pubsub|sqs|rabbitmq|redis
producer=redis

# 日志级别 调试时可用 DEBUG，正常情况下使用INFO
log_level=INFO

#     *** mysql ***
# mysql 数据库地址
host=localhost

# mysql 数据库端口
port=3306

# mysql 用户
user=maxwell

# mysql 密码
password=maxwell

# 存储Maxwell信息的数据库名字
schema_database=maxwell

# Redis 地址
redis_host=localhost
# Redis 端口
redis_port=6379
# 数据库
redis_database=0

# Redis 流名字
redis_key=RISK_DATA_STREAM

# Redis添加数据命令
redis_type=xadd
```

### 注意事项

* JAVA 多线程注意异常处理。
* 从RedisStream中读取消息的时候，设置的阻塞时间要尽量的短一些，防止阻塞其它操作。


