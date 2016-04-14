## 说明
创建日期：2016-2-16 22:57:18  
开发工具  

 * Intellij Idea  
 * Maven
 * java

## 具体构建
可以参考：
[SpringBoot参考指南](https://qbgbook.gitbooks.io/spring-boot-reference-guide-zh/content/)

## 创建项目
1. 创建一个空的Maven项目。
2. 增加 pom文件的内容。

		<?xml version="1.0" encoding="UTF-8"?>
		<project xmlns="http://maven.apache.org/POM/4.0.0"
		         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
		    <modelVersion>4.0.0</modelVersion>
		
		    <groupId>com.sun.SpringBoot</groupId>
		    <artifactId>SpringDemo1</artifactId>
		    <version>1.0-SNAPSHOT</version>
		
		    <properties>
		        <spring.boot.version>1.1.4.RELEASE</spring.boot.version>
		    </properties>
		
		    <dependencies>
		        <dependency>
		            <groupId>org.springframework.boot</groupId>
		            <artifactId>spring-boot-starter-web</artifactId>
		            <version>${spring.boot.version}</version>
		        </dependency>
		    </dependencies>
		
		    <build>
		        <plugins>
		            <plugin>
		                <groupId>org.springframework.boot</groupId>
		                <artifactId>spring-boot-maven-plugin</artifactId>
		                <version>${spring.boot.version}</version>
		                <executions>
		                    <execution>
		                        <goals>
		                            <goal>repackage</goal>
		                        </goals>
		                    </execution>
		                </executions>
		            </plugin>
		        </plugins>
		    </build>
		
		</project>

3. 增加启动类，在src/main/java 下面创建启动类。

		import org.springframework.boot.SpringApplication;
		import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
		import org.springframework.web.bind.annotation.RequestMapping;
		import org.springframework.web.bind.annotation.RestController;
		
		/**
		 * 描述：
		 * 所属工程： SpringBootDemo
		 * 作者：     sunfeilong1993
		 * 创建日期： 2016:02:16  22:51
		 */
		
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

4. 启动。

 1. 点击开发工具右上角的  
 ![](http://7xle4i.com1.z0.glb.clouddn.com/mackdown1.jpg)
 2. 找到SpringBoot  
 ![](http://7xle4i.com1.z0.glb.clouddn.com/mackdown2.jpg)
 3. 配置完成  
 ![](http://7xle4i.com1.z0.glb.clouddn.com/mackdown3.jpg)
 4. 运行  
如果使用一个浏览器打开localhost:8080，你应该可以看到以下输出：

5. 创建一个可执行jar,install之后运行jar的结果。

		sunfeilong1993@SUNFEILONG /E
		$ java -jar SpringDemo1-1.0-SNAPSHOT.jar
		
		  .   ____          _            __ _ _
		 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
		( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
		 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
		  '  |____| .__|_| |_|_| |_\__, | / / / /
		 =========|_|==============|___/=/_/_/_/
		 :: Spring Boot ::        (v1.1.4.RELEASE)
		
		2016-02-16 23:21:47.914  INFO 7916 --- [           main] Example                                  : Starting Example on sunfeilong with PID 7916 (E:\SpringDemo1-1.0-SNAPSHOT.jar started by sunfeilong1993 in e:\)
		2016-02-16 23:21:47.996  INFO 7916 --- [           main] ationConfigEmbeddedWebApplicationContext : Refreshing org.springframework.boot.context.embedded.AnnotationConfigEmbeddedWebApplicationContext@165cee0b: startup date [Tue Feb 16 23:21:47 CST 2016]; root of context hierarchy
		2016-02-16 23:21:48.581  INFO 7916 --- [           main] o.s.b.f.s.DefaultListableBeanFactory     : Overriding bean definition for bean 'beanNameViewResolver': replacing [Root bean: class [null]; scope=; abstract=false; lazyInit=false; autowireMode=3; dependencyCheck=0; autowireCandidate=true; primary=false; factoryBeanName=org.springframework.boot.autoconfigure.web.ErrorMvcAutoConfiguration$White
		labelErrorViewConfiguration; factoryMethodName=beanNameViewResolver; initMethodName=null; destroyMethodName=(inferred); defined in class path resource [org/springframework/boot/autoconfigure/web/ErrorMvcAutoConfiguration$WhitelabelErrorViewConfiguration.class]] with [Root bean: class [null]; scope=; abstract=false; lazyInit=false; autowireMode=3; dependencyCheck=0; autowireCandidate=true; primary=
		false; factoryBeanName=org.springframework.boot.autoconfigure.web.WebMvcAutoConfiguration$WebMvcAutoConfigurationAdapter; factoryMethodName=beanNameViewResolver; initMethodName=null; destroyMethodName=(inferred); defined in class path resource [org/springframework/boot/autoconfigure/web/WebMvcAutoConfiguration$WebMvcAutoConfigurationAdapter.class]]
		2016-02-16 23:21:49.921  INFO 7916 --- [           main] .t.TomcatEmbeddedServletContainerFactory : Server initialized with port: 8080
		2016-02-16 23:21:50.388  INFO 7916 --- [           main] o.apache.catalina.core.StandardService   : Starting service Tomcat
		2016-02-16 23:21:50.390  INFO 7916 --- [           main] org.apache.catalina.core.StandardEngine  : Starting Servlet Engine: Apache Tomcat/7.0.54
		2016-02-16 23:21:50.600  INFO 7916 --- [ost-startStop-1] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
		2016-02-16 23:21:50.600  INFO 7916 --- [ost-startStop-1] o.s.web.context.ContextLoader            : Root WebApplicationContext: initialization completed in 2615 ms
		2016-02-16 23:21:51.457  INFO 7916 --- [ost-startStop-1] o.s.b.c.e.ServletRegistrationBean        : Mapping servlet: 'dispatcherServlet' to [/]
		2016-02-16 23:21:51.461  INFO 7916 --- [ost-startStop-1] o.s.b.c.embedded.FilterRegistrationBean  : Mapping filter: 'hiddenHttpMethodFilter' to: [/*]
		2016-02-16 23:21:51.812  INFO 7916 --- [           main] o.s.w.s.handler.SimpleUrlHandlerMapping  : Mapped URL path [/**/favicon.ico] onto handler of type [class org.springframework.web.servlet.resource.ResourceHttpRequestHandler]
		2016-02-16 23:21:51.929  INFO 7916 --- [           main] s.w.s.m.m.a.RequestMappingHandlerMapping : Mapped "{[/],methods=[],params=[],headers=[],consumes=[],produces=[],custom=[]}" onto java.lang.String Example.home()
		2016-02-16 23:21:51.933  INFO 7916 --- [           main] s.w.s.m.m.a.RequestMappingHandlerMapping : Mapped "{[/error],methods=[],params=[],headers=[],consumes=[],produces=[],custom=[]}" onto public org.springframework.http.ResponseEntity<java.util.Map<java.lang.String, java.lang.Object>> org.springframework.boot.autoconfigure.web.BasicErrorController.error(javax.servlet.http.HttpServletRequest)
		2016-02-16 23:21:51.933  INFO 7916 --- [           main] s.w.s.m.m.a.RequestMappingHandlerMapping : Mapped "{[/error],methods=[],params=[],headers=[],consumes=[],produces=[text/html],custom=[]}" onto public org.springframework.web.servlet.ModelAndView org.springframework.boot.autoconfigure.web.BasicErrorController.errorHtml(javax.servlet.http.HttpServletRequest)
		2016-02-16 23:21:51.961  INFO 7916 --- [           main] o.s.w.s.handler.SimpleUrlHandlerMapping  : Mapped URL path [/**] onto handler of type [class org.springframework.web.servlet.resource.ResourceHttpRequestHandler]
		2016-02-16 23:21:51.962  INFO 7916 --- [           main] o.s.w.s.handler.SimpleUrlHandlerMapping  : Mapped URL path [/webjars/**] onto handler of type [class org.springframework.web.servlet.resource.ResourceHttpRequestHandler]
		2016-02-16 23:21:52.241  INFO 7916 --- [           main] o.s.j.e.a.AnnotationMBeanExporter        : Registering beans for JMX exposure on startup
		2016-02-16 23:21:52.479  INFO 7916 --- [           main] s.b.c.e.t.TomcatEmbeddedServletContainer : Tomcat started on port(s): 8080/http
		2016-02-16 23:21:52.481  INFO 7916 --- [           main] Example                                  : Started Example in 5.691 seconds (JVM running for 7.228)
