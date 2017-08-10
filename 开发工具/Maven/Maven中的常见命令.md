## Maven中的常见命令
		
	`maven -v`    				查看maven的版本
	`maven clean` 				清除目标文件
	`maven complie` 			编译源代码
	`mvn test` 					执行测试
	`mvn package`				编译并打包项目，生成jar包 
	`mvn install` 				把当前项目发布到本地仓库中，如果其它项目依赖该模块就可以直接根据坐标从本
                                地仓库中查找
	`mvn archetype:generate` 	自动创建目录


## maven生命周期
	
	 clean  清理项目
		pre-clean 执行清理前的文件
		clean 清理上一次构建的文件
		post-clean 执行清理后的文件
	 default 构建项目     
	    compile
	    test
	    package
	    install
	 site 生成项目站点
	    pre-site 在生成项目站点前要完成的工作
	    site 生成项目的站点文档
	    post-site 在生成项目站点后要完成的工作
	    site-deploy 发布生成的站点到服务器

## 使用插件
	<build>
	  	<plugins>
	  		<plugin>
	  			<groupId>org.apache.maven.plugins</groupId>
	  			<artifactId>maven-source-plugin</artifactId>
	  			<version>2.4</version>
	  			<executions>
	  				<execution>
	  					<phase>package</phase>
	  					<goals>
	  						<goal>jar-no-fork</goal>
	  					</goals>
	  				</execution>
	  			</executions>
	  		</plugin>
	  	</plugins>
	  </build>

## 常用标签
* <project> pom的一些约束信息
* modelVersion 当前pom的版本
* groupId  反写的公司网址+项目名
* artifactId 项目名+模块名
* version 版本号
    三个数字   
	第一个0表示大版本号  
	第二个令表示分支版本号  
	第三个0小版本号  
	snapshot 快照  
	alpha 内部测试  
	beta  公测  
	Release  稳定版本  
	GA  发布版本
	
* packaging 打包的方式默认jar
* name 项目的描述名
* url 项目的地址
* description 项目的描述
* developers 开发人员列表
* license 许可证信息
* organization 组织信息
* dependencies 依赖
* deoendency
* groupId
* artifactId
* version
* type  
* scope依赖范围(test)只能在test目录下引入对应的类   

  compile 编译、测试和运行都有效  
  provided 测试和编译的时候有效，运行时不加入  
  runtime 测试和运行时有效  
  test 测试范围有效
  system 编译和测试的时候有效  
  import  只使用在dependencyManagement依赖管理表示从其他的pom中导入的dependency的配置
	
		<dependencies>
		    <dependency>
			   <groupId>junit</groupId>
			   <artifactId>junit</artifactId>
			   <version>3.8.1</version>
			   <!-- 依赖范围 -->
			   <scope>test</scope>
			</dependency>
		</dependencies>

* optional false 子项目继承  ture子项目必须显示引入
* exclusions 排除依赖
* exclusion
* dependencyManagement依赖管理，供子模块继承

		<dependencies>
			<dependency>
			</dependency>
		</dependencies>

* parent 继承
* modules 模块聚合



## pom文件配置jetty插件  
	<build>
    <plugins>
    	<plugin>
	    	<groupId>org.eclipse.jetty</groupId>
			<artifactId>jetty-maven-plugin</artifactId>
			<version>9.3.2.v20150730</version>
			<executions>
				<execution>
					<!-- 执行的指令 -->
					<phase>package</phase>
					<!-- 触发的jetty指令 -->
					<goals>
						<goal>run</goal>
					</goals>
				</execution>
			</executions>
    	</plugin>
    </plugins>
    </build>

## pom 配置tomcat插件
	<build>
	    <finalName>maven-demo</finalName>
	    <plugins>
	    	<plugin>
		    	<groupId>org.apache.tomcat.maven</groupId>
				<artifactId>tomcat7-maven-plugin</artifactId>
				<version>2.2</version>
				<executions>
					<execution>
						<!-- 执行的指令 -->
						<phase>package</phase>
						<!-- 触发的tomcat指令 -->
						<goals>
							<goal>run</goal>
						</goals>
					</execution>
				</executions>
	    	</plugin>
	    </plugins>
	  </build>
## 模块的依赖 直接写入对应的项目的坐标添加到项目即可
	<!-- 依赖的父模块 -->
    <dependency>
    	<groupId>com.sunfeilong.child1</groupId>
	    <artifactId>child1</artifactId>
	    <version>0.0.1-SNAPSHOT</version>
	    <!-- 排除依赖 -->
	    <exclusions>
	    	<exclusion>
	    		<groupId>com.sunfeilong.parent</groupId>
			    <artifactId>parent</artifactId>
	    	</exclusion>
	    </exclusions>
    </dependency>

## 依赖冲突
1、短的路径优先  

	A->B->C.jar  
	A->B->E->C.jar  
	结果：A依赖C.jar
2、路径长度相同先声明的优先

    A->B->C.jar  
	A->E->C.jar  
	结果：如果先配置A->B则A依赖C.jar

## 聚合:要把packaging改为pom,同时引入模块即可,模块会按顺序执行
	<packaging>pom</packaging>
	  
	<modules>
		<module>../parent</module>
		<module>../child1</module>
		<module>../grandson</module>
	</modules>
## 继承
1、父摸版的配置

	<packaging>pom</packaging>
	<properties>
	<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
	<junit.version>4.10</junit.version>
	</properties>
	
	<dependencyManagement>
		<dependencies>
	    <dependency>
	      <groupId>junit</groupId>
	      <artifactId>junit</artifactId>
	      <version>${junit.version}</version>
	      <scope>test</scope>
	    </dependency>
		 </dependencies>
	</dependencyManagement>

2、子模版的配置

		<parent>
			<groupId>com.sunfeilong.grandfather</groupId>
		<artifactId>grandfather</artifactId>
		<version>0.0.1-SNAPSHOT</version>
		</parent>
		
		<dependencies>
		<dependency>
		  <groupId>junit</groupId>
		  <artifactId>junit</artifactId>
		</dependency>
		</dependencies>