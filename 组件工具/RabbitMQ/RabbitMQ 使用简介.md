时间：2018/7/10 17:45:19  

参考： 

1. [.NET 使用 RabbitMQ 图文简介](https://www.cnblogs.com/julyluo/p/6262553.html)
2. [RabbitMQ Exchange类型详解](http://www.cnblogs.com/julyluo/p/6265775.html)
3. [RabbitMQ Tutorials](https://www.rabbitmq.com/getstarted.html)

### 简介

#### 核心概念

* 生产者（Producer）：往队列里面发送数据。

* 消费者（Consumer）：消费队列里面的数据。

* 转换器 （Exchange）：

	生产者发送数据到exchange，exchange再根据规则把数据发送到队列。

	exchange的分类：

	* direct: 根据路由Key直接发送到对应的绑定的队列上。（路由可以相等）

		代码如下：

			@Autowired
		    public SendMessage(AmqpAdmin amqpAdmin, AmqpTemplate amqpTemplate) {
		        this.amqpAdmin = amqpAdmin;
		        this.amqpTemplate = amqpTemplate;
		        //初始化 exchange
		        Exchange numberEx = ExchangeBuilder.directExchange("number_ex").build();
		        amqpAdmin.declareExchange(numberEx);
				//初始化 queue
		        Queue oddQueue = QueueBuilder.durable("odd_queue").build();
		        Queue evenQueue = QueueBuilder.durable("even_queue").build();
		        amqpAdmin.declareQueue(oddQueue);
		        amqpAdmin.declareQueue(evenQueue);
				//初始化绑定关系
		        Binding odd = BindingBuilder.bind(oddQueue).to(numberEx).with("odd").noargs();
		        Binding even = BindingBuilder.bind(evenQueue).to(numberEx).with("even").noargs();
		        amqpAdmin.declareBinding(odd);
		        amqpAdmin.declareBinding(even);
		    }
		
		    @Override
		    public void run(String... args) throws Exception {
		        while (true) {
		            try {
		                if (index % 2 == 0) {
		                    amqpTemplate.convertAndSend("number_ex", "even", index);
		                } else {
		                    amqpTemplate.convertAndSend("number_ex", "odd", index);
		                }
		                TimeUnit.SECONDS.sleep(1L);
		            } catch (Exception e) {
		                logger.error("send", e);
		            }
		        }
		    }
	* topic: 类似于direct,路由key由一个或多个单词组成（用 `.` 分割），可以指定通配符，最多255个子节。`*` 匹配一个单词， `#` 没有或多个单词。
	* fanout: 将消息路由到所有绑定的队列中。
	* header: 匹配Header里面的信息，`x-match` 为 all 匹配所有，`x-match` 为any 匹配任意一个就会发送到绑定的队列。 

			//exchange
			Exchange numberEx = ExchangeBuilder.headersExchange("number_ex")
                .withArgument("format", "pdf")
                .withArgument("type", "report")
                .withArgument("x-match", "all")
                .build();

			//message
    		MessageProperties messageProperties = new MessageProperties();
            messageProperties.setContentType(MessageProperties.CONTENT_TYPE_JSON);
            Message message = MessageBuilder.withBody("".getBytes()).andProperties(messageProperties).build();
            amqpTemplate.send(message);

* binding:定义 `exchange` 和队列之间的关系。

* 队列（queue）：缓存一类消息

#### 参数设置

* no_ack：消费者端参数，是否关闭手动发送ack消息。
	* true是，消费者接收成功即被认为消费成功。
	* false 否。
* exclusive： 连接关闭之后，删除队列。

* 数据持久化：数据发送到服务器到服务器持久化数据到磁盘中会有一定的间隔，在消息写入磁盘之前服务器宕机，没有缓存的消息会丢失。
	* durable：队列持久化，创建队列的时候指定。
	
			channel.queue_declare(queue='hello', durable=True)
	* delivery_mode:生产者生产数据持久化。

			channel.basic_publish(exchange='',
	                      routing_key="task_queue",
	                      body=message,
	                      properties=pika.BasicProperties(
	                         delivery_mode = 2, # make message persistent
	                      ))
* 消费者调度策略：
	* 轮询：默认策略，每个消费者收到的消息数量相同 
	* basic.qos：prefetch_count=1 消费者每次接收一条消息，处理之后再接收另外一条消息，这样处理速度快的消费者会收到更多的消息。 
		
			channel.basic_qos(prefetch_count=1)

#### 知识点：

* 可以多次创建同一个队列，如果已经存在，不会对原队列产生任何影响。
* 创建队列之后，队列的属性不能被修改，如果要修改属性，只能创建一个新的队列代替。
* ack 机制：
	* 消费者消费成功之后发送确认信息，此时队列才会认为数据被消费成功，消息发送给消费者之后和消费者发送ack消息之间的时间可以无限长。
	* 如果消费者在发送ack之前挂掉（channel关闭、连接关闭、TCP 连接丢失），则对应的消息会被重新发送给其它消费者。
* topic 类型的 `exchange` ：消息通过绑定从 `exchange` 转发到一个队列称为一个映射关系，如果一个队列和一个exchange存在多个映射关系，同一个消息也只会发送到一个队列一次。
#### 消费模式

* 一个生产者一个消费者：一个生产者发送数据到队列，一个消费者消费队列的数据。
* 一个生产者多个消费者：一个生产者发送数据到队列，多个消费者消费同一个队列，服务器会根据调度策略发送数据给不同的消费者。
* 发布/订阅：定义 `fanout` 类型的 `exchange`，生产者发送数据到 `exchange`, 消费者端定义和 `exchange` 绑定的队列，这样每个消费者定义的队列就都可以收到对应 `exchange` 的消息。

		channel.exchange_declare(exchange='logs',exchange_type='fanout')
		# 连接关闭之后删除队列
		result = channel.queue_declare(exclusive=True)
		queue_name = result.method.queue
		channel.queue_bind(exchange='logs',queue=queue_name)
		
		# 回调
		channel.basic_consume(callback,queue=queue_name,no_ack=True)
* RPC 模式： 
	* 客户端：客户端发送请求，把参数写入请求队列，并把请求的ID，响应存放的队列设置到属性里面。客户端监听响应存放队列，拿到对应Id的数据。
	* 服务端：从请求队列取数据，处理请求，并把结果和请求ID等放入响应队列。
 