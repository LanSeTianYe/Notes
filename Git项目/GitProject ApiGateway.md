时间：2018/9/20 9:51:33  

参考： 

1. [OpenResty](http://openresty.org/cn/) 基于 Nginx 与 Lua 的高性能 Web 平台。

## Api GeteWay       

API Gateway 作为应用接口的上一层，代理对业务接口的访问。在代理过程前后增加业务逻辑，实现一些常用功能，如负载均衡，缓存，频率限制、安全认证等。

在原有接口上面增加一层会增加请求的耗时，但是把一些公用的业务出去到代理层，可以减少接口层的业务逻辑。对于服务聚合网关，可以减少客户端请求服务器的次数，同时减少请求的耗时和客户端的业务复杂性。 

### [Kong](https://github.com/Kong/kong.git) 

#### 是什么 ？  

基于Nginx实现的 API Gateway，以插件的形式存在。使用PL/SQL或Cassandra做数据存储。提供 Admin-API 接口，通过接口可以管理路由、服务和插件等，实现实时变更。功能模块以插件的形式存在，提供常用功能，支持自定义插件。

提供企业版，功能较社区版更加完善。支持各种环境安装部署。

#### 可以做什么？

* 集群。
* 权限认证。
* 负载均衡。
* 频率限制。
* 熔断机制。
* 监控。
* 缓存。
* WebScoket支持。
* 安全：访问控制，黑白名单等。
* 日志。

### [Zuul](https://github.com/Netflix/zuul.git)

NetFlix 公司提供的Java语言的 ApiGateway 框架，基于过滤器模式实现，依赖Eurake等NetFlix公司框架。

位于API上层，代理HTTP请求，在HTTP请求发送到实际服务器之前进行业务处理。

### [spring-cloud-gateway](https://github.com/spring-cloud/spring-cloud-gateway)

[官方文档](https://cloud.spring.io/spring-cloud-gateway/)

#### 是什么 ？     

Spring-Cloud-Gateway 是Spring官方提供的 API-Gateway 实现。提供常用过滤器和路由模板插件，通过增加配置参数即可使用。提供扩展过滤器和路由器的构造类（对于Java开发者来说扩展比较方便)。

#### 默认提供的模板

##### 路由器
* 时间路由：之前、之后、之间。
* Cookie路由。
* Header路由。
* Host路由。
* Method路由。
* Path路由。
* 查询参数路由。
* ReomteAddress路由。

##### 过滤器
* 添加请求头。
* 添加请求参数。
* 添加响应头。
* Hystrix 熔断降级。
* 保留请求头过滤器(删除不允许发送到实体服务的请求头)。
* 频率限制。
* 重定向。
* 删除请求头。
* 删除响应头。
* 重写 path。
* 保存Session。
* 安全头。
* 设置Path。
* 设置响应头。
* 设置响应码。
* 跳过path，跳过path的前几级。
* 重试。
* 请求大小。
##### 全局过滤器  

全局过滤器可以指定执行的先后顺序。

* 请求转发。
* 负载均衡。
* 基于 Netty 响应信息写入。
* WebSocket。
* 网管数据统计。
* 把 Exchange 作为路由器，经 Exchange 的请求不会再次被路由。
		
		# takes a ServerWebExchange object and marks it as "routed"
		ServerWebExchangeUtils.setAlreadyRouted 

## 总结  

**Zuul：**

Zuul 依赖 Netflix 的一些组件，如 Eureka 等，依赖额外的技术栈较多，目前不考虑使用。

**Spring Cloud Gateway：**  

Spring Cloud Gateway 是 SpringCloud 系列的一个组件，配置和自定义功能组件比较方便（对于Java开发者）。  

API Gateway 项目可以单独使用，也可以结合Spring CLoud的其他模块，实现更丰富的功能。提供常用的模板，复杂的业务模板需要开发者自己实 现。

类似于大部分的Spring Cloud 项目，提供基础实现以及简单的扩展工具，开发者可以根据自己的需求实现自己的业务模块。

目前并没有被大量使用。

**kong：**  

kong 提供社区版和企业版，企业版包含一些高级功能。如管理界面，实时监控和分析、可扩展性等。社区版也可以满足大量需求。

项目目前仍比较活跃，使用者也较多，插件比较丰富，使用原生插件只需通过 admin-api 变更配置信息即可。如果只使用原生插件，只需要设置对应的配置信息即可。

数据持久化依赖 PL/SQL或Cassandra，数据库的高可用以及容灾也许要进行考虑。 

基于 Lua 脚本的插件，自定义插件的复杂度较高（自己试一下）。  

## 性能测试 

1. [性能测试项目，测试效果SpringCloud 性能较好](https://github.com/spencergibb/spring-cloud-gateway-bench)