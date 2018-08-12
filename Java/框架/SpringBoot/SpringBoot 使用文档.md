时间：2018/7/18 11:02:37 

参考： 

1.[Spring Boot Reference Guide](https://docs.spring.io/spring-boot/docs/2.0.3.RELEASE/reference/htmlsingle/)

##  SpringBoot 使用文档 

注：完整代码可参考 [https://github.com/LanSeTianYe/DemoContainer/tree/master/springboot](https://github.com/LanSeTianYe/DemoContainer/tree/master/springboot)
### 使用基础
#### 特性
* 创建独立的Spring应用项目。
* 内嵌Tomcat、Jetty和Undertoe容器，不需要把项目打成 `war` 包，直接运行 `jar` 包即可。
* 提供第三方框架或者工具 `starter` 依赖，简化构造应用程序。
* 尽可能自动配置Spring和第三方类库。
* 提供指标、健康状况和外部配置等生产环境需要的功能。
* 完全不需要代码生成和 `Xml` 配置文件。

#### 系统要求

基本环境要求：

1. Java8/Java9
2. Spring 5.0.7 或以上版本
3. Maven3.2+ 或 Gradle 4

内嵌容器版本：Tomcat8.5、Jetty 9.4 Undertow 1.4等，可以运行再任何实现 `Servlet 3.1 ` 规范的容器上。

#### 第一个项目

当前可用版本是 `2.0.3` ，下面引入parent依赖、Web模块儿依赖和构建插件。 

	<!--父项目，管理依赖的版本-->
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>2.0.3.RELEASE</version>
	</parent>

	<!--Web模块依赖-->
	<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>
	</dependencies>

	<!--插件-->
	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>

#### 项目入口

	@RestController
	@EnableAutoConfiguration
	public class Example {
	
		@RequestMapping("/")
		String home() {
			return "Hello World!";
		}
	
		public static void main(String[] args) throws Exception {
			SpringApplication.run(Example.class, args);
		}
	
	}

* @RestController：标识 ResetController 
* @EnableAutoConfiguration：自动扫描配置类
* @RequestMapping：请求路径
* main方法是项目的启动入口

### 使用进阶

#### CommandLineRunner

实现 `CommandLineRunner` 接口的 Bean 会在 `SpringApplication` 开始之后运行。同一个项目可以有多个 `CommandLineRunner` 的实现，可以通过 `Order`注解指定执行顺寻。 多个 `CommandLineRunner` 会按照顺序同步执行。

	@Order(1)
	@Component
	public class TestCommandLineRunner implements CommandLineRunner {
	
	    private final static Logger logger = LogManager.getLogger(TestCommandLineRunner.class);
	
	    private final PersonService personService;
	
	    @Autowired
	    public TestCommandLineRunner(TestAsyncMethod testAsyncMethod, PersonService personService) {
	        this.testAsyncMethod = testAsyncMethod;
	        this.personService = personService;
	    }
	
	    @Override
	    public void run(String... args) throws Exception {
	        ArrayList<Person> personList = new ArrayList<>();
	        for (int i = 0; i < 10; i++) {
	            Person person = new Person();
	            person.setName("name" + i);
	            personList.add(person);
	        }
	        personService.addAll(personList);
	    }
	}

#### HandlerMethodArgumentResolver

`Handler` 方法参数注入，使用示例：


	@Component
	public class PersonParameterHandlerMethodArgumentResolver implements HandlerMethodArgumentResolver {
	
	    private final PersonService personService;
	
	    @Autowired
	    public PersonParameterHandlerMethodArgumentResolver(PersonService personService) {
	        this.personService = personService;
	    }
	
	    @Override
	    public boolean supportsParameter(MethodParameter parameter) {
	        if(parameter.getParameterType().equals(Person.class)) {
	            return true;
	        }
	        return false;
	    }
	
	    @Nullable
	    @Override
	    public Object resolveArgument(MethodParameter parameter, @Nullable ModelAndViewContainer mavContainer, NativeWebRequest webRequest, @Nullable WebDataBinderFactory binderFactory) throws Exception {
	        String personId = webRequest.getParameter("personId");
	        if (null == personId || "".equals(personId)) {
	            return Person.NULL;
	        }
	        Optional<Person> personOptional = personService.findByPersonId(Long.valueOf(personId));
	        return personOptional.orElse(Person.NULL);
	    }
	}


配置使用参数注入工具： 

	@Configuration
	public class AppConfig implements WebMvcConfigurer {
	
	    private final PersonParameterHandlerMethodArgumentResolver personParameterHandlerMethodArgumentResolver;
	
	    public AppConfig(PersonParameterHandlerMethodArgumentResolver personParameterHandlerMethodArgumentResolver) {
	        this.personParameterHandlerMethodArgumentResolver = personParameterHandlerMethodArgumentResolver;
	    }
	
	    @Override
	    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
	        resolvers.add(personParameterHandlerMethodArgumentResolver);
	    }
	}

#### Filter 过滤器

过滤器需要实现 `Filter` 接口，然后添加 `@WebFilter`  注解即可。

	@WebFilter
	public class MyFilter implements Filter {
	
	    private final static Logger logger = LogManager.getLogger(MyFilter.class);
	
	    @Override
	    public void init(FilterConfig filterConfig) throws ServletException {
	        logger.info("Filter init");
	    }
	
	    @Override
	    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
	        logger.info("Filter do filter: " + servletRequest.getRemoteAddr());
	        filterChain.doFilter(servletRequest, servletResponse);
	    }
	
	    @Override
	    public void destroy() {
	        logger.info("Filter destroy...");
	    }
	}

#### Interceptor 拦截器

拦截器需要继承 `HandlerInterceptorAdapter`， 并再 `Configuration` 类里面添加到容器的拦截器集合里面。

拦截器实现：

	@Component
	public class MyIntercepter extends HandlerInterceptorAdapter {
	
	    private final static Logger logger = LogManager.getLogger(MyIntercepter.class);
	
	    @Override
	    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
	        logger.debug("HandlerInterceptorAdapter_preHandle: " + request.getRequestURI());
	        return true;
	    }
	
	    @Override
	    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable ModelAndView modelAndView) throws Exception {
	        logger.debug("HandlerInterceptorAdapter_postHandle: " + request.getRequestURI());
	    }
	
	    @Override
	    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable Exception ex) throws Exception {
	        logger.debug("HandlerInterceptorAdapter_afterCompletion: " + request.getRequestURI());
	    }
	}
添加拦截器到容器：

	@Configuration
	public class AppConfig implements WebMvcConfigurer {
	
	    private final MyIntercepter filterIntercepter;
	
	  
	    public AppConfig(MyIntercepter filterIntercepter) {
	        this.filterIntercepter = filterIntercepter;
	       
	    }
	
	    @Override
	    public void addInterceptors(InterceptorRegistry registry) {
	        registry.addInterceptor(filterIntercepter);
	
	    }
	}

#### Async 异步方法

在方法上添加 `@Async` 注解，让类通过容器进行管理，调用方法的时候会异步执行。在项目启动类添加 `@EnableAsync` 注解。
	
	@Component
	public class TestAsyncMethod {
	
	    private final static Logger logger = LogManager.getLogger(TestAsyncMethod.class);
	
	    @Async
	    public void run() {
	        try {
	            TimeUnit.SECONDS.sleep(5);
	        } catch (InterruptedException e) {
	            e.printStackTrace();
	        }
	        logger.info("TestAsyncMethod run finished after 5 second ...");
	    }
	}

#### EventListener 事件监听器

##### ServletContextListener

Servlet容器初始化和销毁事件监听器，容器初始化和销毁的时候会发送事件到监听器。

	@WebListener
	public class MyServletContextListener implements ServletContextListener {
	
	    private final static Logger logger = LogManager.getLogger(MyServletContextListener.class);
	
	    @Override
	    public void contextInitialized(ServletContextEvent servletContextEvent) {
	        logger.info("contextInitialized ...");
	    }
	
	    @Override
	    public void contextDestroyed(ServletContextEvent servletContextEvent) {
	        System.err.println("contextDestroyed");
	    }
	}

##### HttpSessionListener

监听Session创建和关闭事件

	@WebListener
	public class MyHttpSessionListener implements HttpSessionListener {
	
	    private final static Logger logger = LogManager.getLogger(MyHttpSessionListener.class);
	
	    @Override
	    public void sessionCreated(HttpSessionEvent httpSessionEvent) {
	        logger.info("sessionCreated");
	    }
	
	    @Override
	    public void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
	        logger.info("sessionDestroyed");
	    }
	}

##### 整合 mybatis

* 引入依赖

        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>1.3.2</version>
         </dependency>

		<dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
* 增加数据库配置文件
		
		spring.datasource.url=jdbc:mysql://127.0.0.1:3306/spring_demo?useUnicode=true&characterEncoding=UTF-8
		spring.datasource.username=root
		spring.datasource.password=000000
		spring.datasource.driver-class-name=com.mysql.jdbc.Driver
* 启动类添加Mapper文件扫描注解

		@MapperScan("com.sun.xiaotian.demo.mybatis.mapper")

* 写Mapper文件
		
		@Mapper
		public interface CityMapper {
		
		    @Select("SELECT id, name, state, country FROM city WHERE state = #{state}")
		    List<City> findByState(String state);
		}

* 开始使用

		@Autowired
	    private final CityMapper cityMapper;

