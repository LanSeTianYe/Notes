##### SpringMVC整合myBatis
## 首先是坑爹的classpath问题。
### 第一种解决办法
使用maven构建工程，package之后项目会被打包到一个war或jar包之中，这就会产生引入配置文件的问题。  

* classpath ：xxx.xml  会从项目的classpath路径下找对应的配置文件，即WEB-INF目录下面。
* classpath*：xxx.xml  会从项目或者jar包中找对应的配置文件。

所以，在项目中如web.xml中，配置配置文件的路径的时候要使用classpath*。

### 第二种解决办法，把配置文件放在src/main/resources目录下面。
src/mian/resources/config/xxx.xml
maven打包之后文件的路径为target/classes/config/xxx.xml

	<!-- 前端控制器 -->
	<servlet>
		<servlet-name>mvc-dispatcher</servlet-name>
		<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
		<init-param>
			<param-name>contextConfigLocation</param-name>
			<!-- 配置文件的地址 -->
			<param-value>classpath:config/mvc-dispatcher-servlet.xml</param-value>
		</init-param>
		<load-on-startup>1</load-on-startup>
	</servlet>

## log4j 配置文件路径问题
我把配置文件放在src/main/resources/config/log4j.properties目录下面    
maven打包之后文件的路径为target/classes/config/log4j.properties

	<!-- 加载log4j配置文件 --> 
	<context-param>
	<param-name>log4jConfigLocation</param-name>
	<param-value>classpath:config/log4j.properties</param-value>
	</context-param>  
	<listener>
	<listener-class>org.springframework.web.util.Log4jConfigListener</listener-class>
	</listener>
###关于路径问题，注意在BuildPath里面配置的Source floders,注意路径位置的对照