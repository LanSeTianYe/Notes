时间：2020-09-02 18:04:04

参考：

1. [记一次RabbitMQ连接阻塞，全部队列不消费异常](https://www.wolzq.com/%E8%AE%B0%E4%B8%80%E6%AC%A1RabbitMQ%E8%BF%9E%E6%8E%A5%E9%98%BB%E5%A1%9E%EF%BC%8C%E5%85%A8%E9%83%A8%E9%98%9F%E5%88%97%E4%B8%8D%E6%B6%88%E8%B4%B9%E5%BC%82%E5%B8%B8/)

2. [Memory and Disk Alarms](https://www.rabbitmq.com/alarms.html)

## RabbitMQ 异常

### RabbitMQ  生产者阻塞

**问题原因：** 生产者不断的推消息，没有消费者消费消息，导致消息在队列中堆积，rabbit 服务占用内存大于最大的配置值，导致生产者阻塞。

**解决方案：** 合理规划生产者和消费者，避免消息在队列中堆积。

**临时解决方案：** 调整rabbit占用内存大小 `rabbitmqctl set_vm_memory_high_watermark 小数`

```shell
=INFO REPORT==== 2-Sep-2020::17:52:40 ===
vm_memory_high_watermark set. Memory used:7128316368 allowed:6640204185

=WARNING REPORT==== 2-Sep-2020::17:52:40 ===
memory resource limit alarm set on node rabbit@localhost.

**********************************************************
*** Publishers will be blocked until this alarm clears ***
**********************************************************
```

### RabbitMQ 消费者过多导致内存占用超过限制，RabbitMQ 进程阻塞

**问题原因：** 客户端消费消息的时候没有指定 `consumerTag` 导致每次消费的时候都自动创建一个新的消费者，消费者增多导致 RabbiMQ 占用内存超过最高限制，最终阻塞。

**解决方案：** 创建消费者的时候指定 `customerTag`。