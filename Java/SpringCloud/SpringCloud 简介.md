时间：2018/9/21 10:32:11   

参考：

## Spring Cloud  简介  

Spring Cloud 是在 Spring Boot 基础上构建的，提供了Spring Cloud Context 和 Spring Cloud Commons  两个核心的类库，以及其它开发中共用的组件。 

### Spring Cloud Context   

#### Bootstrap 应用程序上下文
  
Spring Cloud 应用程序默认会创建一个 `Bootstrap 应用程序上下文`，作为主应用程序的父上下文，负责从外部加载配置信息。这两个应用程序上下文会共享同一个环境变量，默认情况下 `bootstrap` 启动阶段加载的配置文件（并不是从 `bootstrap.properties` 加载的配置信息），会有较高的优先级。可以使用 `bootstrap.yml` 来存放外部配置，从而和主应用上下文配置分离。

禁用 `bootstrap` 启动过程：`spring.cloud.bootstrap.enabled=false`

#### 配置信息覆盖  

* `spring.cloud.config.allowOverride=true`: 允许本地配置覆盖远程配置。
* `spring.cloud.config.overrideNone=true`: 不覆盖任何本地配置。
* `spring.cloud.config.overrideSystemProperties=false`: 系统属性、命令行参数和环境变量应该覆盖远程配置。

### 自定义属性源加载

参考 `spring-config-client`

	org.springframework.cloud.bootstrap.BootstrapConfiguration=\
	org.springframework.cloud.config.client.ConfigServiceBootstrapConfiguration,\
	org.springframework.cloud.config.client.DiscoveryClientConfigServiceBootstrapConfiguration

#### 环境变更  

应用程序会监听 `EnvironmentChangeEvent` 事件，当接收到 `EnvironmentChangeEvent` 事件时，应用程序可以从事件程序去除变更的属性列表，从而执行如下操作：

* 重新绑定任何带有 `@ConfigurationProperties` 注解的Bean。
* 设置 `logging.level.*` 的日志级别。

默认通过轮询检测环境变更（不推荐使用，推荐使用 `Spring Cloud Bus`）。  

可以通过访问 `/configprops`，验证变更事件。

#### RefreshScope

Refresh作用域的Bean，有一个 `refreshALl()` 方法，作用是清除缓存内容，刷新所有 `Refresh` 作用域的Bean。也可以调用 ` refresh(String)` 刷新指定名字的Bean。

通过访问 `/refresh` 可以触发刷新操作。调用接口时有 `RefreshScope` 注解的Bean一定会被刷新，其它的应用 `RefreshScope`注解的Bean可能不会被刷新，因此，需要刷新的Bean都加上 `RefreshScope` 注解即可。

暴露 `/refresh`： 

	management:
	  endpoints:
	    web:
	      exposure:
	        include: refresh 

#### 管理接口

* `/actuator/env`: to update the Environment and rebind @ConfigurationProperties and log levels.
* `/actuator/refresh`: to re-load the boot strap context and refresh the @RefreshScope beans.
* `/actuator/restart`: to close the ApplicationContext and restart it (disabled by default).
* `/actuator/pause` and `/actuator/resume`: for calling the Lifecycle methods (stop() and start() on the ApplicationContext).

### Spring Cloud Commons  

服务发现、负载均衡和熔断等的通用抽象层，客户端依赖抽象层，不依赖具体的实现。

#### @EnableDiscoveryClient  

把注册应用程序注册到注册中心    

#### 服务注册

支持的注册实现： ZookeeperRegistration、EurekaRegistration 和 ConsulRegistration。

默认开启自动注册，关闭自动注册  
 
* 注解方法 ：`@EnableDiscoveryClient(autoRegister=false)`。
* 配置文件方法： `spring.cloud.service-registry.auto-registration.enabled=false`。 

#### 配置服务注册  
通过访问 `/service-registry` 可以查看和变更注册中心的状态。` Eureka` 注册中心的状态为 `UP` `DOWN` `OUT_OF_SERVICE` 和 `UNKNOWN`

#### 负载均衡客户端 

##### RestTemplate 作为负载均衡客户端：

简单实现： 

	@Configuration
	public class MyConfiguration {
	
	    @LoadBalanced
	    @Bean
	    RestTemplate restTemplate() {
	        return new RestTemplate();
	    }
	}
	
	public class MyClass {
	    @Autowired
	    private RestTemplate restTemplate;
	
	    public String doOtherStuff() {
	        String results = restTemplate.getForObject("http://stores/stores", String.class);
	        return results;
	    }
	}
##### WebClient 作为负载均衡客户端：

* 简单实现： 

		@Configuration
		public class MyConfiguration {
		
			@Bean
			@LoadBalanced
			public WebClient.Builder loadBalancedWebClientBuilder() {
				return WebClient.builder();
			}
		}
		
		public class MyClass {
		    @Autowired
		    private WebClient.Builder webClientBuilder;
		
		    public Mono<String> doOtherStuff() {
		        return webClientBuilder.build().get().uri("http://stores/stores")
		        				.retrieve().bodyToMono(String.class);
		    }
		}
* 重试机制相关属性  
	* spring.cloud.loadbalancer.retry.enabled=fals  关闭配置
	* client.ribbon.MaxAutoRetries    最大重试次数
	* client.ribbon.MaxAutoRetriesNextServer  重试服务器个数
	* client.ribbon.OkToRetryOnAllOperations 	
	
* 自定重试义补偿策略 

		@Configuration
		public class MyConfiguration {
		    @Bean
		    LoadBalancedBackOffPolicyFactory backOffPolciyFactory() {
		        return new LoadBalancedBackOffPolicyFactory() {
		            @Override
		            public BackOffPolicy createBackOffPolicy(String service) {
		        		return new ExponentialBackOffPolicy();
		        	}
		        };
		    }
		}
* 重试监听器  
	
		@Configuration
		public class MyConfiguration {
		    @Bean
		    LoadBalancedRetryListenerFactory retryListenerFactory() {
		        return new LoadBalancedRetryListenerFactory() {
		            @Override
		            public RetryListener[] createRetryListeners(String service) {
		                return new RetryListener[]{new RetryListener() {
		                    @Override
		                    public <T, E extends Throwable> boolean open(RetryContext context, RetryCallback<T, E> callback) {
		                        //TODO Do you business...
		                        return true;
		                    }
		
		                    @Override
		                     public <T, E extends Throwable> void close(RetryContext context, RetryCallback<T, E> callback, Throwable throwable) {
		                        //TODO Do you business...
		                    }
		
		                    @Override
		                    public <T, E extends Throwable> void onError(RetryContext context, RetryCallback<T, E> callback, Throwable throwable) {
		                        //TODO Do you business...
		                    }
		                }};
		            }
		        };
		    }
		}
##### WebFlux WebClient 作为负载均衡客户端 

使用 LoadBalancerExchangeFilterFunction。
 
	public class MyClass {
	    @Autowired
	    private LoadBalancerExchangeFilterFunction lbFunction;
	
	    public Mono<String> doOtherStuff() {
	        return WebClient.builder().baseUrl("http://stores")
	            .filter(lbFunction)
	            .build()
	            .get()
	            .uri("/stores")
	            .retrieve()
	            .bodyToMono(String.class);
	    }
	}