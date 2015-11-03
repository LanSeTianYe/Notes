## Maven搭建SpringMVC项目
1、创建一个maven的web项目(注意项目的目录结构)
 >src
 > > main  
 > > > java(java源代码)  
 > > > resources(所需的资源文件)  
 > > > webapp(项目页面文件)   
 > > > > WEB-INF  
 > > > > > jsp  
 > > > > > config (项目配置文件)  
 > > > > > wen.xml  
 > 


 > > test  
 > > > java  
 > > > resources  
 > 
 > > > webapp   


 > pom.xml  
 > 
 
## `pom.xml`  
	<project xmlns="http://maven.apache.org/POM/4.0.0" 
			 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	  		 xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
	 
		<modelVersion>4.0.0</modelVersion>
	 
	  <groupId>com.sunfeilong.maven-demo</groupId>
	  <artifactId>maven-demo</artifactId>
	  <packaging>war</packaging>
	  <version>0.0.1-SNAPSHOT</version>
	  <name>maven-demo Maven Webapp</name>
	  
	  <properties>
	  	<springMVC.version>4.1.3.RELEASE</springMVC.version>
	  </properties>
	  
	  <dependencyManagement>
	  	<dependencies>
	  		<dependency>
	  			<groupId>org.springframework</groupId>
				<artifactId>spring-framework-bom</artifactId>
				<version>${springMVC.version}</version>
				<type>pom</type>
	      		<scope>import</scope>
	  		</dependency>
	  	</dependencies>
	  </dependencyManagement>
	 
	
	  <dependencies>
	  
	  	<!-- springMVC -->
	  	<dependency>
	  		<groupId>org.springframework</groupId>
	  		<artifactId>spring-webmvc</artifactId>
	  	</dependency>
	  	
	  	<!-- lang -->
		<dependency>
			<groupId>commons-lang</groupId>
			<artifactId>commons-lang</artifactId>
			<version>2.6</version>
		</dependency>
		
		<!-- slf4j -->
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-log4j12</artifactId>
			<version>1.7.12</version>
			<exclusions>
				<exclusion>
					<groupId>org.slf4j</groupId>
					<artifactId>slf4j-api</artifactId>
				</exclusion>
			</exclusions>
		</dependency>
		
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-api</artifactId>
			<version>1.7.12</version>
		</dependency>
	  	
	  
	  	<!-- Junit测试 -->
	    <dependency>
	      <groupId>junit</groupId>
	      <artifactId>junit</artifactId>
	      <version>4.10</version>
	    </dependency>
	    
	    
	  </dependencies>
	  
	  <build>
	    <finalName>maven-demo</finalName>
	    <plugins>
	    	<plugin>
		    	<groupId>org.apache.tomcat.maven</groupId>
				<artifactId>tomcat7-maven-plugin</artifactId>
				<version>2.2</version>
				<executions>
					<execution>
						<phase>package</phase>
						<goals>
							<goal>run</goal>
						</goals>
					</execution>
				</executions>
	    	</plugin>
	    </plugins>
	  </build>
	</project>
## `web.xml`
	<?xml version="1.0" encoding="UTF-8"?>
	<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
			 xmlns="http://java.sun.com/xml/ns/javaee"
			 xmlns:web="http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd" 
			 xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd" 
			 id="WebApp_ID" 
			 version="2.5">
			 
	  <display-name>Create Maven Project</display-name>
	  
	  <!-- Spring上下文，Spring配置文件的路径 -->
	  <context-param>
	  	<param-name>contextConfigLocation</param-name>
	  	<param-value>/WEB-INF/config/spring/applicationContext*.xml</param-value>
	  </context-param>
	  
	  <listener>
	  	<listener-class>
	  		org.springframework.web.context.ContextLoaderListener
	  	</listener-class>
	  </listener>
	  
	  
	  <servlet>
	  	<servlet-name>mvc-dispatcher</servlet-name>
	  	<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
	  	<!-- DispatcherServlet 对应的上下文配置 ，默认为/WEB-INF/$servlet-name$-servlet.xml -->
	  	<init-param>
	  		<param-name>contextConfigLocation</param-name>
	  		<param-value>/WEB-INF/config/spring/mvc-dispatcher-servlet.xml</param-value>
	  	</init-param>
	  	<load-on-startup>1</load-on-startup>
	  </servlet>
	  
	  <!--处理所有的请求 -->
	  <servlet-mapping>
	  	<servlet-name>mvc-dispatcher</servlet-name>
	  	<url-pattern>/</url-pattern>
	  </servlet-mapping>
	  
	</web-app>
## `springMVC`配置文件
	<beans xmlns="http://www.springframework.org/schema/beans"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mvc="http://www.springframework.org/schema/mvc"
		xmlns:context="http://www.springframework.org/schema/context"
		xmlns:aop="http://www.springframework.org/schema/aop" xmlns:tx="http://www.springframework.org/schema/tx"
		xsi:schemaLocation="http://www.springframework.org/schema/beans 
			http://www.springframework.org/schema/beans/spring-beans-3.2.xsd 
			http://www.springframework.org/schema/mvc 
			http://www.springframework.org/schema/mvc/spring-mvc-3.2.xsd 
			http://www.springframework.org/schema/context 
			http://www.springframework.org/schema/context/spring-context-3.2.xsd 
			http://www.springframework.org/schema/aop 
			http://www.springframework.org/schema/aop/spring-aop-3.2.xsd 
			http://www.springframework.org/schema/tx 
			http://www.springframework.org/schema/tx/spring-tx-3.2.xsd ">
	
		<!-- 激活注解配置 -->
		<context:annotation-config  />
		<!-- 使用spring组件扫描 -->
		<context:component-scan base-package="com.sun.mavenDemo" >
			<context:include-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
		</context:component-scan>
		
		<mvc:annotation-driven />
		
		<!-- 静态资源 js,css,img -->
		<mvc:resources location="/resources" mapping="/resources**"/>
		
	
		<!-- 配置视图解析器 要求将jstl的包加到classpath -->
		<!-- ViewResolver -->
		<bean
			class="org.springframework.web.servlet.view.InternalResourceViewResolver">
			
			<property name="prefix" value="/WEB-INF/jsp/" />
			<property name="suffix" value=".jsp" />
		</bean>
		
	</beans>
## `Spring`配置文件
	<beans xmlns="http://www.springframework.org/schema/beans"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mvc="http://www.springframework.org/schema/mvc"
		xmlns:context="http://www.springframework.org/schema/context"
		xmlns:aop="http://www.springframework.org/schema/aop" xmlns:tx="http://www.springframework.org/schema/tx"
		xsi:schemaLocation="http://www.springframework.org/schema/beans 
			http://www.springframework.org/schema/beans/spring-beans-3.2.xsd 
			http://www.springframework.org/schema/mvc 
			http://www.springframework.org/schema/mvc/spring-mvc-3.2.xsd 
			http://www.springframework.org/schema/context 
			http://www.springframework.org/schema/context/spring-context-3.2.xsd 
			http://www.springframework.org/schema/aop 
			http://www.springframework.org/schema/aop/spring-aop-3.2.xsd 
			http://www.springframework.org/schema/tx 
			http://www.springframework.org/schema/tx/spring-tx-3.2.xsd ">
	
		<!-- 激活注解配置 -->
		<context:annotation-config  />
		<!-- 使用spring组件扫描 -->
		<context:component-scan base-package="com.sun.mavenDemo" >
			<context:include-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
		</context:component-scan>
		
		
	</beans>