时间： 2018/9/26 18:16:48   

## SpringCloud Eureka 简介

### 概念

#### 服务提供者  

* 注册服务：把服务注册到注册中心。

		eureka.cli ent.register-with-eureka=true
* 服务同步：不同注册中心会同步已经注册的服务，因此可以从任意一个注册中心获取到已经注册的服务。
* 服务续约：服务提供者会定期发送续约信息给注册中心，告诉注册中心我还活着。
	* eureka.instance.lease-renewal-interval-in-seconds：发送续约信息的间隔，默认30秒。
	* eureka.ins七ance.lease-expiration-duration-in-seconds：服务失效的时间，默认90秒。

#### 服务消费者  

* 获取服务：调用接口获取服务列表（注册中心会维护一个只读的服务提供者列表，每30秒刷新一次）。

		eureka.client.fetch-registry=true
		eureka.client.registry-fetch-interval-seconds=30
* 服务调用：获取服务清单后，根据清单现戏确定调用哪一个接口。
* 服务下线：服务提供者正常关闭时，会发送下线消息给注册中心，注册中西会把服务的状态标记为 `Down` 。

#### 服务注册中心  

* 失效剔除：剔除非正常下线的服务。
* 自我保护：15分钟内心跳信息失败的比例低于85%，会将当前注册的信息保护起来。

		eureka.server.enableself-preservation=false

#### 服务注册类配置信息  

以 `eureka.client` 开头。  

* 服务中心地址：
	* 默认地址：`eureka.client.serviceUrl.defaultZone=http://localhost:llll/eureka/`
	* 高可用地址： `eureka.client.serviceUrl.defaultZone=http://peerl:1111/eureka/, http://peer2:111
2/eureka/`
	* 安全校验：`http://<username>:<password>@localhost:1111/eureka`

**其它配置:** 

* enabled：启用Eureka客户端，默认值 true。
* registryFetchIntervalSeconds：更新实例信息到Eureka服务端的时间间隔，默认值 30。
* instancelnfoReplicationlntervalSeconds：初始化实例信息的变化到Eureka服务端的间隔，默认值30。
* inItiallnstancelnfoRepIicationintervalSeconds:初始化实例信息到 Eureka 服务端的间隔时间，默认值40。
* eurekaServiceUrlPolllntervalSeconds：轮询Eureka服务端地址更改的间隔时间，默认值 300。（ 当与Spring Cloud Config 配合，动态刷新Eureka的serv1ceURL地址时需要关注该参数）
* eurekaServerReadTimeoutSeconds：读取Eureka Se1-ver信息的超时时间， 默认值 8。
* eurekaServerConnectTimeoutSeconds：连接 Eureka Server的超时时间，默认值 5。
* eurekaServerTotalConnections：从Eureka客户端到所有Eureka服务端的连接总数，默认值200。
* eurekaServerTotalConnectionsPerHost：从Eureka客户端到每个Eureka服务端主机的连接数，默认值50。
* eurekaConnectionldleTimeoutSeconds：Eureka服务端连接的空闲关闭时间，默认 30。
* heartbeatExecutorThreadPoolSize：心跳连接池的初始化线程数，默认值2。
* heartbeatExecutorExponentialBackOffBound：心跳超时重试延迟时间的最大乘数值，默认值 10。
* cacheRefreshExecutorThreadPoolSize：缓存刷新线程池的初始化线程数，默认值2。
* cacheRefreshExecutorExponentialBackOfound：缓存刷新重试延迟时间的最大乘数值，默认值10。
* useDnsForFetchmgServiceUrls：使用DNS获取Eureka服务端的ServiceUrl，默认值fale。
* registerWithEureka：是否将自身注册到服务中心，默认值 true。
* preferSameZoneEureka：是否偏好使用处于相同Zone的Eureka服务端。默认值 true。
* flterOnlyUplnstances：获取实例时是否过滤，仅保留UP状态实例，默认true。
* ftchRegistry：是否从Eureka获取服务端注册信息，默认值 true。

#### 服务实例信息配置  

	instance:
	    # 主机名，不配置时根据操作系统主机名获取
	    hostname: localhost
	    # 节点多长时间没有心跳，从注册列表删除
	    lease-expiration-duration-in-seconds: 30
	    # 心跳间隔
	    lease-renewal-interval-in-seconds: 10
	    # 元数据map
	    metadata-map:
	      # 区域
	      zone: shanghai
	    # 实例Id，默认值 ${spring.cloud.client.hostname}:${spring.application.name}:${spring.application.instance_id}:${server.port}}
	    instance-id: ${spring.application.name}:${random.int}}
	    # path 相对路径可以更改，但需要但需要保证 path 可用
	    # health-check-url-path: /info
	    # status-page-url-path: /health
	    # url 绝对路径
	    # health-check-url:
	    # status-page-url:
	    # 是否优先使用IP地址作为主机标识
	    prefer-ip-address: false
	    # 非安全通信端口号
	    non-secure-port: 80
	    # 安全通信端口号
	    secure-port: 443
	    # 是否启用非安全的通信端口号
	    non-secure-port-enabled: true
	    # 是否启用安全通信端口号
	    secure-port-enabled: false
	    # 服务名，默认取值 spring.application.name
	    # appname:

