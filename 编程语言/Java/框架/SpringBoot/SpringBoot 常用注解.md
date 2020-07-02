## 几个常用注解的使用
#### @Bean

> 标注在方法前面，表明方法的返回值将成为一个被Spring容器管理的Bean。

#### @Configuration  

> 标注在类前面，表明类的方法会产生一个或者多个@Bean注解的方法将会被Spring容器初始化成为Bean，这些Bean会在运行时被请求。

#### @EnableAutoConfiguration  

> 注解在启动类前面，表明当你需要Bean的时候，会尝试自动去寻找并配置你需要的Bean。自动配置类依赖你的的ClassPath和已经定义的Bean。

#### @ComponentScan  

> 配置在启动类前面，自动从有@Configuration配置的类里面扫描Bean组件。

#### @SpringBootApplication  

如果你的启动类在根路径之下则 `@SpringBootApplication` 等价于 `@Configuration` 、 `@ComponentScan` 和 `@EnableAutoConfiguration`  

SpringBoot建议你将主应用class（main application class）放在包根路径上，即其他子包之上。@EnableAutoConfiguration通常放在你的main class上，这样也隐含的指定了对某些配置项的搜索路径。比如，对@Entity的搜索。

#### 多种Bean加载方式
Spring提供两种方式将定义在另外一个带有@Configuration的类中的Bean加载：

1. 在Application类中使用@Import指定该类。
2. 让@ComponentScan扫描到该类。

#### Bean的自动配置
SpringBoot有一个非常神秘的注解@EnableAutoConfiguration，官方的解释已经在上面的部分给出，简单点说就是它会根据定义在classpath下的类，自动的给你生成一些Bean，并加载到Spring的Context中。  
它的神秘之处，不在于它能做什么，而在于它会生成什么样的Bean对于开发人员是不可预知（或者说不容易预知）。举个例子：  
要开发一个基于Spring JPA的应用，会涉及到下面三个Bean的配置，DataSource，EntityManagerFactory，PlatformTransactionManager。  


	@Configuration
	@EnableJpaRepositories
	@EnableTransactionManagement
	public class ApplicationConfig {
	  @Bean
	  public DataSource dataSource() {
	      ...
	  }
	
	  @Bean
	  public EntityManagerFactory entityManagerFactory() {
	      ..
	      factory.setDataSource(dataSource());
	      return factory.getObject();
	  }
	
	  @Bean
	  public PlatformTransactionManager transactionManager() {
	      JpaTransactionManager txManager = new JpaTransactionManager();
	      txManager.setEntityManagerFactory(entityManagerFactory());
	      return txManager;
	  }
	}
@EnableJpaRepositories会查找满足作为Repository条件（继承父类或者使用注解）的类。  

@EnableTransactionManagement的作用：Enables Spring’s annotation-driven transaction management capability, similar to the support found in Spring’s <tx:*> XML namespace。  

但是，如果你使用了@EnableAutoConfiguration，那么上面三个Bean，你都不需要配置。在classpath下面只引入了MySQL的驱动和SpringJpa。  

	compile 'mysql:mysql-connector-java:5.1.18'
	compile 'org.springframework.boot:spring-boot-starter-data-jpa'
 在Application类中写下下面这段代码，可以查看SpringBoot给你生成了这些Bean：

	ConfigurableApplicationContext ctx = SpringApplication.run(Application.class, args);
	System.out.println("Let's inspect the beans provided by Spring Boot:");
	
	Object dataSource = ctx.getBean("dataSource");
	Object transactionManager = ctx.getBean("transactionManager");
	Object entityManagerFactory = ctx.getBean("entityManagerFactory");
	System.out.println(dataSource);
	System.out.println(entityManagerFactory);
	System.out.println(transactionManager);
	System.out.println(((JpaTransactionManager)transactionManager).getDataSource());
	System.out.println(((JpaTransactionManager)transactionManager).getEntityManagerFactory());

输出如下：

	org.apache.tomcat.jdbc.pool.DataSource@4f0e94db{ConnectionPool[defaultAutoCommit=null; defaultReadOnly=null; defaultTransactionIsolation=-1; defaultCatalog=null; driverClassName=com.mysql.jdbc.Driver; maxActive=100; maxIdle=100; minIdle=10; initialSize=10; maxWait=30000; testOnBorrow=true; testOnReturn=false; timeBetweenEvictionRunsMillis=5000; numTestsPerEvictionRun=0; minEvictableIdleTimeMillis=60000; testWhileIdle=false; testOnConnect=false; password=********; ... }
	
	org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean@5109d386
	
	org.springframework.orm.jpa.JpaTransactionManager@5c1e2bfa
	
	org.apache.tomcat.jdbc.pool.DataSource@4f0e94db{ConnectionPool[defaultAutoCommit=null; defaultReadOnly=null; defaultTransactionIsolation=-1; defaultCatalog=null; driverClassName=com.mysql.jdbc.Driver; maxActive=100; maxIdle=100; minIdle=10; initialSize=10; maxWait=30000; testOnBorrow=true; testOnReturn=false; timeBetweenEvictionRunsMillis=5000; numTestsPerEvictionRun=0; minEvictableIdleTimeMillis=60000; testWhileIdle=false; testOnConnect=false; password=********;... }
	
	org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean@5109d386

Bean中的URL，username和password是在属性文件中配置的：
	
	#Database
	spring.datasource.url=jdbc:mysql://localhost:3306/xxxx      
	spring.datasource.username=root
	spring.datasource.password=

#### Disable自动配置
如果你发现自动转配的Bean不是你想要的，你也可以disable它。
