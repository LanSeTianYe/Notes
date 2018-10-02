时间：2018/9/20 9:51:33  

参考： 

1. [OpenResty](http://openresty.org/cn/) 基于 Nginx 与 Lua 的高性能 Web 平台。

## Api GeteWay    

### [Kong](https://github.com/Kong/kong.git) 

[OpenResty](http://openresty.org/cn/) 平台插件，基于 Nginx 和 Lua 脚本实现。在Nginx层实现业务逻辑。

### [Zuul](https://github.com/Netflix/zuul.git)

NetFlix 公司提供的Java语言的 ApiGateway 框架，基于过滤器模式实现，依赖Eurake等NetFlix公司框架，入门要求较高。

位于API上层，代理HTTP请求，在HTTP请求发送到实际服务器之前进行业务处理。

### [spring-cloud-gateway](https://github.com/spring-cloud/spring-cloud-gateway)

[官方文档](https://cloud.spring.io/spring-cloud-gateway/)

#### 简介    

基于 Spring5，Spring Boot2.0 的API Gateway实现。

依赖 Spring Boot 和 Spring WebFlux 提供的Netty运行时环境，不能在传统的Servlet容器或构建成War包的项目中使用。

客户端把请求发送到 API Gateway 项目，项目负责过滤和处理请求，然后把请求发送到真实服务器

#### 特性

* 支持 Hystrix
* 提供常用过滤器工厂类，通过配置文件即可启用。

## 性能测试 

1. [比较完整的测试（测试时SpringCloud Gateway还没有官方发布版本）](https://engineering.opsgenie.com/comparing-api-gateway-performances-nginx-vs-zuul-vs-spring-cloud-gateway-vs-linkerd-b2cc59c65369)
2. [性能测试项目，测试效果SpringCloud 性能较好](https://github.com/spencergibb/spring-cloud-gateway-bench)