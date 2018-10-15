时间：2018/9/25 15:02:06

参考： 

1. [spring-cloud-gateway 官方文档](http://cloud.spring.io/spring-cloud-gateway/single/spring-cloud-gateway.html#_after_route_predicate_factory)  


## SpringCloud Gateway 简介    

### 说明

* 核心概念：
	* route: 路由，把请求转发到指定的Uri。
	* predicate: 匹配规则。
	* filter: 请求过滤器，对请求进行过滤处理。
     

SpringCloud Gateway 实现路由和过滤共功能，提供常用的路由和过滤模板，在项目配置文件中配置即可使用，也支持自定义路有个过滤模板实现自己的业务逻辑。

底层基于非阻塞IO模型实现。

> Spring Cloud Gateway requires the Netty runtime provided by Spring Boot and Spring Webflux. It does not work in a traditional Servlet Container or built as a WAR.

架构图： 

![](https://raw.githubusercontent.com/spring-cloud/spring-cloud-gateway/master/docs/src/main/asciidoc/images/spring_cloud_gateway_diagram.png)


#### 路由模块  

SpringCloud GateWay 把路由作为 `Spring WebFlux` 的 `HandlerMapping`。默认提供了常用的路由模板，匹配规则可以联合使用。

##### 内置路由模板    
 
* 时间路由
* Cookie 路由
* Header 路由 
* HOST 路由 
* Method 路由
* Path 路由  
* Query 字段路由  
* RemoteAddr 路由 

#### 过滤模块

路由模块包含一些 Filter，对匹配到的请求进行前置或后置处理，如限流、熔断等处理。  

##### 内置过滤模板

* 添加请求头。 
* 添加请求参数。  
* 添加响应Header。 
* Hystrix 支持，需要指定实现 `HystrixCommand` 接口的类。
* 前缀路径，给请求添加前缀路径。 `/hello` 会映射到 `/mypath/hello`。
* 请求频率限制。
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

##### 全局过滤 GlobalFilter 

作用于所有的路由。

* 全局路由有优先级，优先级高的先执行（数字越小优先级越高）。
* 重定向过滤器：使用 `Spring DispatcherHandler` 处理请求， `uri: forward:///common/error` 配置的请求将被路由到本地进行处理。
* 负载均衡过滤器：把请转发到 `host + path`
* WebSocket 路由过滤器。
* 网关测量过滤器。

