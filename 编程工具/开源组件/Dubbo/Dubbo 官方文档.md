时间：2018/7/23 15:30:53   
参考： 

1. [Dubbo 官方中文文档](http://dubbo.apache.org/#!/docs/user/references/xml/dubbo-service.md?lang=zh-cn)

##   

### 参数配置以及用途说明  

#### xml 标签配置方式  
配置关系覆盖原则：`方法配置优先优先` 优先于 `接口配置` 优先于 `全局配置`。   
级别相同的情况下：消费端配置优先于提供放端配置，服务提供方配置通过URL经注册中心传递给服务消费方。

|标签|用途|说明|
|::|::|::|::|
|<dubbo:service/>	|服务配置	|用于暴露一个服务，定义服务的元信息，一个服务可以用多个协议暴露，一个服务也可以注册到多个注册中心|
|<dubbo:reference/> |引用配置	|用于创建一个远程服务代理，一个引用可以指向多个注册中心|
|<dubbo:protocol/>	|协议配置	|用于配置提供服务的协议信息，协议由提供方指定，消费方被动接受|
|<dubbo:application/>	|应用配置	|用于配置当前应用信息，不管该应用是提供者还是消费者|
|<dubbo:module/>	|模块配置	|用于配置当前模块信息，可选|
|<dubbo:registry/>	|注册中心配置	|用于配置连接注册中心相关信息|
|<dubbo:monitor/>	|监控中心配置	|用于配置连接监控中心相关信息，可选|
|<dubbo:provider/>	|提供方配置	|当 ProtocolConfig 和 ServiceConfig 某属性没有配置时，采用此缺省值，可选|
|<dubbo:consumer/>	|消费方配置	|当 ReferenceConfig 某属性没有配置时，采用此缺省值，可选|
|<dubbo:method/>	|方法配置	|用于 ServiceConfig 和 ReferenceConfig 指定方法级的配置信息|
|<dubbo:argument/>	|参数配置	|用于指定方法参数配置|

注：建议由服务提供方设置超时时间，服务方更了解接口的执行时间，同时消费放也不需要关心超时时间的设置。

#### properties 属性配置 

覆盖策略：`java -D` 优先于 `xml 配置` 优先于 `properties 属性配置`  

	dubbo.application.name=foo
	dubbo.application.owner=bar
	dubbo.registry.address=10.20.153.10:9090

#### 启动时检查  

默认会在启动时检查依赖的服务是否可用，不可用会抛出异常终止项目。   

* 关闭某个服务的启动时检查

		dubbo.reference.com.foo.BarService.check=false
* 关闭所有服务的启动时检查，强制改变所有 reference 的 check 值，就算配置中有声明，也会被覆盖

		dubbo.reference.check=false
* 设置 check 的缺省值，如果配置中有显式的声明，如：`<dubbo:reference check="true"/>`，显示声明不会受影响。

		dubbo.consumer.check=false
* 关闭注册中心启动时检查，前面两个都是指订阅成功，但提供者列表是否为空时否报错，如果注册订阅失败时，也允许启动，需使用此选项，将在后台定时重试。

		dubbo.registry.check=false

#### 集群容错  

在集群调用失败时，Dubbo 提供了多种容错方案，缺省为 failover 重试。

* Failover： 失败自动切换，当出现失败，重试其它服务器。通常用于读操作，但重试会带来更长延迟。可通过 `retries="2"` 来设置重试次数(不含第一次)。
* Failfast:  快速失败，只发起一次调用，失败立即报错。通常用于非幂等性的写操作，比如新增记录。
* Failsafe:  失败安全，出现异常时，直接忽略。通常用于写入审计日志等操作。
* Failback:  失败自动恢复，后台记录失败请求，定时重发。通常用于消息通知操作。
* Forking:  并行调用多个服务器，只要一个成功即返回。通常用于实时性要求较高的读操作，但需要浪费更多服务资源。可通过 `forks="2"` 来设置最大并行数。
* Broadcast:  广播调用所有提供者，逐个调用，任意一台报错则报错。通常用于通知所有提供者更新缓存或日志等本地资源信息。

#### 负载均衡   

在集群负载均衡时，Dubbo 提供了多种均衡策略，缺省为 random 随机调用。也可自行扩展负载均衡策略。

* Random： 
	* 随机，按权重设置随机概率。
	* 在一个截面上碰撞的概率高，但调用量越大分布越均匀，而且按概率使用权重后也比较均匀，有利于动态调整提供者权重。
* RoundRobin ：
	* 轮询，按公约后的权重设置轮循比率。
	* 存在慢的提供者累积请求的问题，比如：第二台机器很慢，但没挂，当请求调到第二台时就卡在那，久而久之，所有请求都卡在调到第二台上。
* LeastActive ：
	* 最少活跃调用数，相同活跃数的随机，活跃数指调用前后计数差。
	* 使慢的提供者收到更少请求，因为越慢的提供者的调用前后计数差会越大。
* ConsistentHash： 
	* 一致性 Hash，相同参数的请求总是发到同一提供者。
	* 当某一台提供者挂时，原本发往该提供者的请求，基于虚拟节点，平摊到其它提供者，不会引起剧烈变动。
	* 算法参见：http://en.wikipedia.org/wiki/Consistent_hashing
	* 默认只对第一个参数 Hash，如果要修改，请配置 <dubbo:parameter key="hash.arguments" value="0,1" />
	* 默认用 160 份虚拟节点，如果要修改，请配置 <dubbo:parameter key="hash.nodes" value="320" />

#### 线程模型  

如果事件处理的逻辑能迅速完成，并且不会发起新的 IO 请求，比如只是在内存中记个标识，则直接在 IO 线程上处理更快，因为减少了线程池调度。   
但如果事件处理逻辑较慢，或者需要发起新的 IO 请求，比如需要查询数据库，则必须派发到线程池，否则 IO 线程阻塞，将导致不能接收其它请求。  
如果用 IO 线程处理事件，又在事件处理过程中发起新的 IO 请求，比如在连接事件中发起登录请求，会报“可能引发死锁”异常，但不会真死锁。

调度器（Dispatcher）：

* all ：所有消息都派发到线程池，包括请求，响应，连接事件，断开事件，心跳等。
* direct ：所有消息都不派发到线程池，全部在 IO 线程上直接执行。
* message：只有请求响应消息派发到线程池，其它连接断开事件，心跳等消息，直接在 IO 线程上执行。
* execution ：只有请求消息派发到线程池，不含响应，响应和其它连接断开事件，心跳等消息，直接在 IO 线程上执行。
* connection ：在 IO 线程上，将连接断开事件放入队列，有序逐个执行，其它消息派发到线程池。

线程池（ThreadPool）：

* fixed ：（默认）固定大小线程池，启动时建立线程，不关闭，一直持有。
* cached：缓存线程池，空闲一分钟自动删除，需要时重建。
* limited：可伸缩线程池，但池中的线程数只会增长不会收缩。只增长不收缩的目的是为了避免收缩时突然来了大流量引起的性能问题。
* eager：优先创建Worker线程池。在任务数量大于corePoolSize但是小于maximumPoolSize时，优先创建Worker来处理任务。当任务数量大于maximumPoolSize时，将任务放入阻塞队列中。阻塞队列充满时抛出RejectedExecutionException。(相比于cached:cached在任务数量超过maximumPoolSize时直接抛出异常而不是将任务放入阻塞队列)

#### 直接连接到提供者  
 
开发测试环境绕过注册中心，直接连接指定的服务。支持三种配置方式。

* XML 配置

		<dubbo:reference id="xxxService" interface="com.alibaba.xxx.XxxService" url="dubbo://localhost:20890" />

* `java -D` 参数

		java -Dcom.alibaba.xxx.XxxService=dubbo://localhost:20890
* 文件映射  
		
		# 指定映射文件
		java -Ddubbo.resolve.file=xxx.properties
		# 映射文件内容
		com.alibaba.xxx.XxxService=dubbo://localhost:20890

#### 只订阅/只注册  

* 只订阅

	正在开发的服务只订阅依赖的服务，不发布正在开发的服务。可以通过直连的形式测试正在开发的服务。
	
		<dubbo:registry address="10.20.153.10:9090" register="false" />		

* 只注册：主注册到注册中心，不订阅注册中心的服务。

		<dubbo:registry id="hzRegistry" address="10.20.153.10:9090" />
		<dubbo:registry id="qdRegistry" address="10.20.141.150:9090" subscribe="false" />

#### 静态服务  

如果需要人工管理服务的上下线，则需要指定静态模式。服务提供者初次注册时为禁用状态，需人工启用。断线时，将不会被自动删除，需人工禁用。

	<dubbo:registry address="10.20.141.150:9090" dynamic="false" />

#### 多协议  

Dubbo 允许配置多协议，在不同服务上支持不同协议或者同一服务上同时支持多种协议。

* 不同服务不同协议：不同服务在性能上适用不同协议进行传输，比如大数据用短连接协议，小数据大并发用长连接协议

	    <!-- 多协议配置 -->
	    <dubbo:protocol name="dubbo" port="20880" />
	    <dubbo:protocol name="rmi" port="1099" />
	    <!-- 使用dubbo协议暴露服务 -->
	    <dubbo:service interface="com.alibaba.hello.api.HelloService" version="1.0.0" ref="helloService" protocol="dubbo" />
	    <!-- 使用rmi协议暴露服务 -->
	    <dubbo:service interface="com.alibaba.hello.api.DemoService" version="1.0.0" ref="demoService" protocol="rmi" /> 
* 多协议暴露服务，多个协议用逗号何个。

	 	<!-- 多协议配置 -->
	    <dubbo:protocol name="dubbo" port="20880" />
	    <dubbo:protocol name="hessian" port="8080" />
	    <!-- 使用多个协议暴露服务 -->
	    <dubbo:service id="helloService" interface="com.alibaba.hello.api.HelloService" version="1.0.0" protocol="dubbo,hessian" />

#### 多注册中心    

Dubbo 支持同一服务向多注册中心同时注册，或者不同服务分别注册到不同的注册中心上去，甚至可以同时引用注册在不同注册中心上的同名服务。

* 多注册中心注册

	    <!-- 多注册中心配置 -->
	    <dubbo:registry id="hangzhouRegistry" address="10.20.141.150:9090" />
	    <dubbo:registry id="qingdaoRegistry" address="10.20.141.151:9010" default="false" />
	    <!-- 向多个注册中心注册 -->
	    <dubbo:service interface="com.alibaba.hello.api.HelloService" version="1.0.0" ref="helloService" registry="hangzhouRegistry,qingdaoRegistry" />
* 不同服务使用不同注册中心

	 	<!-- 多注册中心配置 -->
	    <dubbo:registry id="chinaRegistry" address="10.20.141.150:9090" />
	    <dubbo:registry id="intlRegistry" address="10.20.154.177:9010" default="false" />
	    <!-- 向中文站注册中心注册 -->
	    <dubbo:service interface="com.alibaba.hello.api.HelloService" version="1.0.0" ref="helloService" registry="chinaRegistry" />
	    <!-- 向国际站注册中心注册 -->
	    <dubbo:service interface="com.alibaba.hello.api.DemoService" version="1.0.0" ref="demoService" registry="intlRegistry" />

* 多注册中心引用
	
	    <!-- 多注册中心配置 -->
	    <dubbo:registry id="chinaRegistry" address="10.20.141.150:9090" />
	    <dubbo:registry id="intlRegistry" address="10.20.154.177:9010" default="false" />
	    <!-- 引用中文站服务 -->
	    <dubbo:reference id="chinaHelloService" interface="com.alibaba.hello.api.HelloService" version="1.0.0" registry="chinaRegistry" />
	    <!-- 引用国际站站服务 -->
	    <dubbo:reference id="intlHelloService" interface="com.alibaba.hello.api.HelloService" version="1.0.0" registry="intlRegistry" />

#### 服务分组  

当一个接口有多种实现时，可以用 group 区分。

	# 注册	
	<dubbo:service group="feedback" interface="com.xxx.IndexService" />
	<dubbo:service group="member" interface="com.xxx.IndexService" />
	# 引用
	<dubbo:reference id="feedbackIndexService" group="feedback" interface="com.xxx.IndexService" />
	<dubbo:reference id="memberIndexService" group="member" interface="com.xxx.IndexService" />
	# 引用任意分组
	<dubbo:reference id="barService" interface="com.foo.BarService" group="*" />

#### 多版本  

当一个接口实现，出现不兼容升级时，可以用版本号过渡，版本号不同的服务相互间不引用。  

可以按照以下的步骤进行版本迁移：

* 在低压力时间段，先升级一半提供者为新版本。
* 再将所有消费者升级为新版本。
* 然后将剩下的一半提供者升级为新版本。

		# 消费者不区分版本调用
		<dubbo:reference id="barService" interface="com.foo.BarService" version="*" />

#### 分组聚合  

按组合并返回结果，比如菜单服务，接口一样，但有多种实现，用group区分，现在消费方需从每种group中调用一次返回结果，合并结果返回，这样就可以实现聚合菜单项。

#### 参数验证  
不稳定

#### 结果缓存  

结果缓存，用于加速热门数据的访问速度，Dubbo 提供声明式缓存，以减少用户加缓存的工作量。

缓存类型：

* lru: 基于最近最少使用原则删除多余缓存，保持最热的数据被缓存。
* threadlocal:  当前线程缓存，比如一个页面渲染，用到很多 portal，每个 portal 都要去查用户信息，通过线程缓存，可以减少这种多余访问。
* jcache: 与 `JSR107` 集成，可以桥接各种缓存实现。

		<dubbo:reference interface="com.foo.BarService" cache="lru" />

#### 泛化引用/泛化实现  
忽略

#### 回声测试  

回声测试用于检测服务是否可用，回声测试按照正常请求流程执行，能够测试整个调用是否通畅，可用于监控。 

所有服务自动实现 `EchoService` 接口，只需将任意服务引用强制转型为 `EchoService` 即可使用。

	<dubbo:reference id="memberService" interface="com.xxx.MemberService" />
	// 远程服务引用
	MemberService memberService = ctx.getBean("memberService"); 
	EchoService echoService = (EchoService) memberService; // 强制转型为EchoService
	// 回声测试可用性
	String status = echoService.$echo("OK"); 
	assert(status.equals("OK"));

#### 上下文信息  

上下文中存放的是当前调用过程中所需的环境信息。所有配置信息都将转换为 URL 的参数。

`RpcContext`是一个`ThreadLocal`的临时状态记录器，当接收到`RPC`请求，或发起`RPC`请求时，`RpcContext`的状态都会变化。比如:`A`调`B`，`B`再调`C`,则`B`机器上,在`B`调`C`之前，`RpcContext`记录的是`A`调`B`的信息，在 `B`调`C`之后，`RpcContext`记录的是`B`调`C`的信息。

服务消费方:

	// 远程调用
	xxxService.xxx();
	// 本端是否为消费端，这里会返回true
	boolean isConsumerSide = RpcContext.getContext().isConsumerSide();
	// 获取最后一次调用的提供方IP地址
	String serverIP = RpcContext.getContext().getRemoteHost();
	// 获取当前服务配置信息，所有配置信息都将转换为URL的参数
	String application = RpcContext.getContext().getUrl().getParameter("application");
	// 注意：每发起RPC调用，上下文状态会变化
	yyyService.yyy();

服务提供方：

	// 本端是否为提供端，这里会返回true
    boolean isProviderSide = RpcContext.getContext().isProviderSide();
    // 获取调用方IP地址
    String clientIP = RpcContext.getContext().getRemoteHost();
    // 获取当前服务配置信息，所有配置信息都将转换为URL的参数
    String application = RpcContext.getContext().getUrl().getParameter("application");
    // 注意：每发起RPC调用，上下文状态会变化
    yyyService.yyy();
    // 此时本端变成消费端，这里会返回false
    boolean isProviderSide = RpcContext.getContext().isProviderSide();

#### 隐式参数

可以通过`RpcContext`上的`setAttachment`和`getAttachment`在服务消费方和提供方之间进行参数的隐式传递。	  

 * `setAttachment`:  设置的 KV 对，在完成下面一次远程调用会被清空，即多次远程调用要多次设置。
 * `getAttachment`: 获取调用方设置的参数。

#### 异步调用

基于 NIO 的非阻塞实现并行调用，客户端不需要启动多线程即可完成并行调用多个远程服务，相对多线程开销较小。

调用配置：

	<dubbo:reference id="fooService" interface="com.alibaba.foo.FooService">
	      <dubbo:method name="findFoo" async="true" />
	</dubbo:reference>

调用代码：

	// 此调用会立即返回null
	fooService.findFoo(fooId);
	// 拿到调用的Future引用，当结果返回后，会被通知和设置到此Future
	Future<Foo> fooFuture = RpcContext.getContext().getFuture(); 
	// 如果foo已返回，直接拿到返回值，否则线程wait住，等待foo返回后，线程会被notify唤醒
	Foo foo = fooFuture.get(); 

是否等待消息发出设置/是否接收返回值：

	# 等待消息发出
	<dubbo:method name="findFoo" async="true" sent="true" />
	# 不接收返回值
	<dubbo:method name="findFoo" async="true" return="false" />

#### 本地调用  

本地调用使用了`injvm`协议，是一个伪协议，它不开启端口，不发起远程调用，只在`JVM`内直接关联，但执行`Dubbo`的`Filter`链。  

从 2.2.0 开始，每个服务默认都会在本地暴露。在引用服务的时候，默认优先引用本地服务。如果希望引用远程服务可以使用一下配置强制引用远程服务。

	<dubbo:reference ... scope="remote" />

#### 参数回调 

参数回调方式与调用本地 callback 或 listener 相同，只需要在 Spring 的配置文件中声明哪个参数是 callback 类型即可。Dubbo 将基于长连接生成反向代理，这样就可以从服务器端调用客户端逻辑。 

#### 事件通知

在调用之前、调用之后、出现异常时，会触发 oninvoke、onreturn、onthrow 三个事件，可以配置当事件发生时，通知哪个类的哪个方法。

#### 本地存根。
调用远程方法前进行预处理。

配置： 

	<dubbo:service interface="com.foo.BarService" stub="com.foo.BarServiceStub" />

实现：

	public class BarServiceStub implements BarService { 
	    private final BarService barService;
	    
	    // 构造函数传入真正的远程代理对象
	    public (BarService barService) {
	        this.barService = barService;
	    }
	 
	    public String sayHello(String name) {
	        // 此代码在客户端执行, 你可以在客户端做ThreadLocal本地缓存，或预先验证参数是否合法，等等
	        try {
	            return barService.sayHello(name);
	        } catch (Exception e) {
	            // 你可以容错，可以做任何AOP拦截事项
	            return "容错数据";
	        }
	    }
	}

#### 本地伪装  

通常用于服务降级，比如某验权服务，当服务提供方全部挂掉后，客户端不抛出异常，而是通过 Mock 数据返回授权失败。

配置： 

		<dubbo:reference interface="com.foo.BarService" mock="com.foo.BarServiceMock" />

实现：

	public class BarServiceMock implements BarService {
	    public String sayHello(String name) {
	        // 你可以伪造容错数据，此方法只在出现RpcException时被执行
	        return "容错数据";
	    }
	} 

#### 延迟暴露  

	# 延迟5秒
	<dubbo:service delay="5000" />
 	# 延迟到 Spring 初始化完成后
	<dubbo:service delay="-1" />

#### 并发控制   

限制每一个方法不能超过10个

	<dubbo:service interface="com.foo.BarService" executes="10" />

限制单个方法不能超过10个
	
	<dubbo:service interface="com.foo.BarService">
	    <dubbo:method name="sayHello" executes="10" />
	</dubbo:service>

#### 连接控制  

限制服务器端接受的连接不能超过 10 个：

	<dubbo:provider protocol="dubbo" accepts="10" />

限制客户端服务使用连接不能超过 10 个： 

	<dubbo:reference interface="com.foo.BarService" connections="10" />	

#### 延迟连接

延迟连接用于减少长连接数。当有调用发起时，再创建长连接。

	<dubbo:protocol name="dubbo" lazy="true" />

#### 粘滞连接

粘滞连接用于有状态服务，尽可能让客户端总是向同一提供者发起调用，除非该提供者挂了，再连另一台。

粘滞连接将自动开启延迟连接，以减少长连接数。

	<dubbo:protocol name="dubbo" sticky="true" />

#### 令牌验证

通过令牌验证在注册中心控制权限，以决定要不要下发令牌给消费者，可以防止消费者绕过注册中心访问提供者，另外通过注册中心可灵活改变授权方式，而不需修改或升级提供者。

	<!--随机token令牌，使用UUID生成-->
	<dubbo:provider interface="com.foo.BarService" token="true" />
	<!--固定token令牌，相当于密码-->
	<dubbo:provider interface="com.foo.BarService" token="123456" />

#### 路由规则

路由规则决定一次 dubbo 服务调用的目标服务器，分为条件路由规则和脚本路由规则，并且支持可扩展。

#### 配置规则

向注册中心写入动态配置覆盖规则。该功能通常由监控中心或治理中心的页面完成。

#### 服务降级

可以通过服务降级功能临时屏蔽某个出错的非关键服务，并定义降级后的返回策略。可以以返回空值的形式处理，相对于专业的框架功能较简单。
#### 优雅停机

Dubbo 是通过 JDK 的 ShutdownHook 来完成优雅停机的，所以如果用户使用 kill -9 PID 等强制关闭指令，是不会执行优雅停机的，只有通过 kill PID 时，才会执行。
	
	# 15秒之后如果没有停止则强制关机
	dubbo.service.shutdown.wait=15000

#### 指定日志框架

	dubbo.application.logger=log4j

#### 访问日志 

	# 默认输出到日志框架配置的文件中
	<dubbo:protocol accesslog="true" />	
	# 输出到指定文件
	<dubbo:protocol accesslog="http://10.20.160.198/wiki/display/dubbo/foo/bar.log" />

#### ReferenceConfig 缓存  

ReferenceConfig 实例很重，封装了与注册中心的连接以及与提供者的连接，需要缓存。否则重复生成 ReferenceConfig 可能造成性能问题并且会有内存和连接泄漏。在 API 方式编程时，容易忽略此问题。

因此，自 2.4.0 版本开始， dubbo 提供了简单的工具类 ReferenceConfigCache用于缓存 ReferenceConfig 实例。

使用： 
	
	ReferenceConfig<XxxService> reference = new ReferenceConfig<XxxService>();
	reference.setInterface(XxxService.class);
	reference.setVersion("1.0.0");
	......
	ReferenceConfigCache cache = ReferenceConfigCache.getCache();
	// cache.get方法中会缓存 Reference对象，并且调用ReferenceConfig.get方法启动ReferenceConfig
	XxxService xxxService = cache.get(reference);
	// 注意！ Cache会持有ReferenceConfig，不要在外部再调用ReferenceConfig的destroy方法，导致Cache内的ReferenceConfig失效！
	// 使用xxxService对象
	xxxService.sayHello();
消除 Cache 中的 ReferenceConfig，将销毁 ReferenceConfig 并释放对应的资源：
	
	ReferenceConfigCache cache = ReferenceConfigCache.getCache();
	cache.destroy(reference);

#### 线程自动dump

当业务线程池满时，我们需要知道线程都在等待哪些资源、条件，以找到系统的瓶颈点或异常点。dubbo通过Jstack自动导出线程堆栈来保留现场，方便排查问题。

默认策略:

* 导出路径，user.home标识的用户主目录
* 导出间隔，最短间隔允许每隔10分钟导出一次

指定导出路径：

	# dubbo.properties
	dubbo.application.dump.directory=/tmp
#### netty 支持 

dubbo 2.5.6版本新增了对netty4通信模块的支持

服务端启动：

	<dubbo:protocol server="netty4" />

消费端： 

	<dubbo:consumer client="netty4" />

### 配置参考

配置分为 服务发现、服务治理和性能调优。 

#### 服务匹配条件 
通过 `group`，`interface`，`version` 确定服务。

#### 服务提供者配置 `ServiceConfig`

* interface（必填）: 服务接口名。
* ref（必填）: 服务对象实现引用。
* version：服务版本，建议使用两位数字版本，如：1.0，通常在接口不兼容时版本号才需要升级。
* token：令牌，防止消费者越过注册中心直接访问。
* dynamic：服务是否动态注册，如果设为false，注册后将显示后disable状态，需人工启用，并且服务提供者停止时，也不会自动取消册，需人工禁用。

#### 服务消费者配置 `ReferenceConfig`
* id（必填）: 服务引用 `beanId`。
* interface（必填）：服务接口名。
* version：服务版本，与服务提供者的版本一致。
* group：服务分组，当一个接口有多个实现，可以用分组区分，必需和服务提供方一致。
* timeout：服务方法调用超时时间(毫秒)。
* retries：远程服务调用重试次数，不包括第一次调用，不需要重试设为0。
* protocol：只调用指定协议的服务提供方，忽略其它协议。

#### 服务提供者协议配置 `ProtocolConfig`

* id: 协议ID，通过ID引用协议。
* name（必填）：协议名称。
* port： 端口。
* host: 主机地址。
* threadpool：线程池类型，可选：fixed/cached， 默认 fixed。
* threads：服务线程池大小(固定大小)，默认 200。
* iothreads：io线程池大小(固定大小)，默认 CPU数 + 1。

#### 注册中心配置 `RegistryConfig`

* address(必填)：注册中心地址。
* protocol：注同中心地址协议，支持dubbo, http, local三种协议，分别表示，dubbo地址，http地址，本地注册中心。默认值 `dubbo`。
* transport：网络传输方式，可选mina，netty。 默认 netty 。
* check：注册中心不存在时，是否报错。默认 true。
* register：是否向此注册中心注册服务，如果设为false，将只订阅，不注册。默认 true。
* subscribe	：是否向此注册中心订阅服务，如果设为false，将只注册，不订阅。默认 true。
* dynamic：服务是否动态注册，如果设为false，注册后将显示后disable状态，需人工启用，并且服务提供者停止时，也不会自动取消册，需人工禁用。

#### 监控中心配置 `MonitorConfig`

* protocol: 监控中心协议，如果为protocol="registry"，表示从注册中心发现监控中心地址，否则直连监控中心。
* address: 直连监控中心服务器地址，`address="10.20.130.230:12080"`。 

#### 应用信息配置 `ApplicationConfig`

* name（必填）：当前应用名称，用于注册中心计算应用间依赖关系，注意：消费者和提供者应用名不要一样。
* version：当前应用的版本。
* organization：组织名称，用于注册中心区分服务来源。
* environment：应用环境，如：develop/test/product，不同环境使用不同的缺省值，以及作为只用于开发测试功能的限制条件。
* compiler：Java字节码编译器，用于动态类的生成，可选：`jdk` 或 `javassist`。默认 `javassist`。
* logger：日志输出方式，可选：slf4j,jcl,log4j,jdk， 默认 slf4j。

#### 模块信息配置 `ModuleConfig`

* name(必填) : 当前模块名称，用于注册中心计算模块间依赖关系。
* version：当前模块的版本

#### 服务提供者缺省值配置 `ProviderConfig`

该标签为 <dubbo:service> 和 <dubbo:protocol> 标签的缺省值设置。

* id: 协议BeanId，可以在 `<dubbo:service proivder="">` 中引用此ID 。
* protocol: 协议名称。

#### 服务消费者缺省值配置 `ConsumerConfig`

该标签为 <dubbo:reference> 标签的缺省值设置。

#### 方法级配置 `MethodConfig` 

该标签为 <dubbo:service> 或 <dubbo:reference> 的子标签，用于控制到方法级。

* name（必填）: 方法名。
* timeout：方法调用超时时间(毫秒)。
* return：方法调用是否需要返回值，async设置为true时才生效，如果设置为true，则返回future，或回调onreturn等方法，如果设置为false，则请求发送成功后直接返回 null。

		<dubbo:reference interface="com.xxx.XxxService">
		    <dubbo:method name="findXxx" timeout="3000" retries="2" />
		</dubbo:reference>

####  方法参数配置 `ArgumentConfig`

该标签为 <dubbo:method> 的子标签，用于方法参数的特征描述，示例：

	<dubbo:method name="findXxx" timeout="3000" retries="2">
	    <dubbo:argument index="0" callback="true" />
	</dubbo:method>

* index（必填）：方法名。
* type：与index二选一， 通过参数类型查找参数的index。
* callback： 参数是否为callback接口，如果为callback，服务提供方将生成反向代理，可以从服务提供方反向调用消费方，通常用于事件推送。

#### 选项参数配置 `Map`

该标签为<dubbo:protocol>或<dubbo:service>或<dubbo:provider>或<dubbo:reference>或<dubbo:consumer>的子标签，用于配置自定义参数，该配置项将作为扩展点设置自定义参数使用。

### 协议简介

#### dubbo 协议  

接口增加方法，对客户端无影响，如果该方法不是客户端需要的，客户端不需要重新部署。输入参数和结果集中增加属性，对客户端无影响，如果客户端并不需要新属性，不用重新部署。

输入参数和结果集属性名变化，对客户端序列化无影响，但是如果客户端不重新部署，不管输入还是输出，属性名变化的属性值是获取不到的。

**特性：**  

默认协议，使用基于 mina 1.1.7 和 hessian 3.2.1 的 tbremoting 交互。

* 连接个数：单连接
* 连接方式：长连接
* 传输协议：TCP
* 传输方式：NIO 异步传输
* 序列化：Hessian 二进制序列化
* 适用范围：传入传出参数数据包较小（建议小于100K），消费者比提供者个数多，单一消费者无法压满提供者，尽量不要用 dubbo 协议传输大文件或超大字符串。
* 适用场景：常规远程服务方法调用

**约束：**  

* 参数及返回值需实现 Serializable 接口。
* 参数及返回值不能自定义实现 List, Map, Number, Date, Calendar 等接口，只能用 JDK 自带的实现，因为 hessian 会做特殊处理，自定义实现类中的属性值都会丢失。
* Hessian 序列化，只传成员属性值和值的类型，不传方法或静态变量。

#### RMI 协议  

RMI 协议采用 JDK 标准的 `java.rmi.*` 实现，采用阻塞式短连接和 JDK 标准序列化方式。

**特性：**

* 连接个数：多连接
* 连接方式：短连接
* 传输协议：TCP
* 传输方式：同步传输
* 序列化：Java 标准二进制序列化
* 适用范围：传入传出参数数据包大小混合，消费者与提供者个数差不多，可传文件。
* 适用场景：常规远程服务方法调用，与原生RMI服务互操作

**约束：**

* 参数及返回值需实现 `Serializable` 接口
* `dubbo` 配置中的超时时间对 `RMI` 无效，需使用 `java` 启动参数设置：`-Dsun.rmi.transport.tcp.responseTimeout=3000`。 

#### hessian 协议 

Hessian 协议用于集成 Hessian 的服务，Hessian 底层采用 Http 通讯，采用 Servlet 暴露服务，Dubbo 缺省内嵌 Jetty 作为服务器实现。

Dubbo 的 Hessian 协议可以和原生 Hessian 服务互操作，即：

* 提供者用 Dubbo 的 Hessian 协议暴露服务，消费者直接用标准 Hessian 接口调用。
* 提供方用标准 Hessian 暴露服务，消费方用 Dubbo 的 Hessian 协议调用。
 
**特性：**

* 连接个数：多连接
* 连接方式：短连接
* 传输协议：HTTP
* 传输方式：同步传输
* 序列化：Hessian二进制序列化
* 适用范围：传入传出参数数据包较大，提供者比消费者个数多，提供者压力较大，可传文件。
* 适用场景：页面传输，文件传输，或与原生hessian服务互操作

**约束：**

* 参数及返回值需实现 Serializable 接口。
* 参数及返回值不能自定义实现 List, Map, Number, Date, Calendar 等接口，只能用 JDK 自带的实现，因为 hessian 会做特殊处理，自定义实现类中的属性值都会丢失。

### 注册中心介绍  

#### zookeeper 注册中心

Zookeeper 是 Apacahe Hadoop 的子项目，是一个树型的目录服务，支持变更推送，适合作为 Dubbo 服务的注册中心，工业强度较高，可用于生产环境。

**注册和订阅流程：**

1. 服务提供者启动时: 向 `/dubbo/com.foo.BarService/providers` 目录下写入自己的 URL 地址。
2. 服务消费者启动时: 订阅 `/dubbo/com.foo.BarService/providers` 目录下的提供者 URL 地址。并向 `/dubbo/com.foo.BarService/consumers` 目录下写入自己的 URL 地址。
3. 监控中心启动时: 订阅 /dubbo/com.foo.BarService 目录下的所有提供者和消费者 URL 地址。

**支持的功能：** 

* 当提供者出现断电等异常停机时，注册中心能自动删除提供者信息。
* 当注册中心重启时，能自动恢复注册数据，以及订阅请求。
* 当会话过期时，能自动恢复注册数据，以及订阅请求。
* 当设置 `<dubbo:registry check="false" />` 时，记录失败注册和订阅请求，后台定时重试。
* 可通过 `<dubbo:registry username="admin" password="1234" />` 设置 zookeeper 登录信息。
* 可通过 `<dubbo:registry group="dubbo" />` 设置 `zookeeper` 的根节点，不设置将使用无根树。
* 支持 * 号通配符 `<dubbo:reference group="*" version="*" />`，可订阅服务的所有分组和所有版本的提供者。

### Telnet 命令

进入命令行 `telnet localhost 20880` 或 `echo status | nc -i 1 localhost 20880`

#### ls

* ls : 显示服务列表。
* ls -l: 显示服务详细信息列表。
* ls XxxService: 显示服务的方法列表。
* ls -l XxxService: 显示服务的方法详细信息列表。

#### ps 

* ps: 显示服务端口列表。
* ps -l: 显示服务地址列表。
* ps 20880: 显示端口上的连接信息。
* ps -l 20880: 显示端口上的连接详细信息。

#### cd

* cd XxxService: 改变缺省服务，当设置了缺省服务，凡是需要输入服务名作为参数的命令，都可以省略服务参数
* cd /: 取消缺省服务

#### pwd

* pwd: 显示当前缺省服务

#### trace

* trace XxxService: 跟踪 1 次服务任意方法的调用情况
* trace XxxService 10: 跟踪 10 次服务任意方法的调用情况
* trace XxxService xxxMethod: 跟踪 1 次服务方法的调用情况
* trace XxxService xxxMethod 10: 跟踪 10 次服务方法的调用情况

#### count

* count XxxService: 统计 1 次服务任意方法的调用情况
* count XxxService 10: 统计 10 次服务任意方法的调用情况
* count XxxService xxxMethod: 统计 1 次服务方法的调用情况
* count XxxService xxxMethod 10: 统计 10 次服务方法的调用情况

#### invoke

* invoke XxxService.xxxMethod({"prop": "value"}): 调用服务的方法
* invoke xxxMethod({"prop": "value"}): 调用服务的方法(自动查找包含此方法的服务)

#### status

* status: 显示汇总状态，该状态将汇总所有资源的状态，当全部 OK 时则显示 OK，只要有一个 ERROR 则显示 ERROR，只要有一个 WARN 则显示 WARN
* status -l: 显示状态列表

#### log

* log debug: 修改 dubbo logger 的日志级别
* log 100: 查看 file logger 的最后 100 字符的日志

#### clear

* clear: 清除屏幕上的内容。
* clear 100: 清除屏幕上的指定行数的内容。

#### exit

* exit: 退出当前 telnet 命令行