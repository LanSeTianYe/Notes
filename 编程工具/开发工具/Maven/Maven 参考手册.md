时间：2019/6/27 22:42:19  

参考：

1. 《Mavan 实战》-- 徐晓斌 
   
## Maven 参考手册

`jar` 搜索网站：

* [https://mvnrepository.com](https://mvnrepository.com)

### Tips  

* 当 Maven 加载的依赖存在问题时，可以手动删除本地仓库里的缓存。

### 常用命令  

* 帮助：`mvn -h`
* 版本：`mvn -v`
* 系统属性：` mvn help:system`
* 清理：`mvn clean`  
* 编译：`mvn compile`
* 执行测试：`mvn test`
* 打包：`mvn package`
* 强制更新：`mvn clean install -U`  
* 查看依赖：`mvn dependency:[list][tree][analyze]`
* 跳过执行测试：`mvn install -Dmaven.test.skip=true` 
* 发布到远程仓库 `mvn deploy`
* 构建站定：`mvn site`
* 多生命周期（每个生命周期只可以指定一个命令）：`mvn clean deploy site-deploy`  

### `setting.xml` 配置文件  

Maven 安装目录下的是全局配置，`~/.m2` 目录下的是用户配置。

### 坐标 

Maven 使用坐标表示 `jar` 包的位置，使用坐标在仓库中查找对应的依赖。

* `groupId`: 项目，比如：`com.xiaotian.note`
* `artifactid`：模块，比如 `note-server` `note-core` 等。
* `version`: 版本号，比如 `1.1.0-SNAPSHOT` `1.1.0-RELEASE` 等。
* `packaging`：打包方式， 比如 `war` `pom` `jar` 等。默认 `jar`。
* `classifier`：由插件帮助生成。

项目命名规范：

 * groupId： `com.xiaotian.部门.项目`
 * artifactid：`项目名-模块`
 * version：`主版本.阶段性版本.次要变更`

### 版本  

快照版本：`snapshot` 每次的时候会从仓库里找最新的版本。  
发布版本：`release`  构建的时候不会自动拉取最新的版本。  

### 生命周期  

执行指定命令，会执行生命周位于该命令之前的所有命令。

* clean:清理项目
	* pre-clean：清理前需要完成的工作
	* clean：清理上一次构建生成的文件
	* post-clean ：清理后需要完成的工作
* default:构建项目
	* validate
	* initialize
	* generate-sources
	* process-sources:处理项目资源文件，一般来说是对 `src/main/resources` 里面的资源进行变量替换，然后输出到classpath目录中。
	* generate-resources
	* process-resources 
	* compile:编译项目源代码，把 `src/main/java` 里的代码编译至 classpath
	* process-classes
	* generate-test-sources
	* process-test-sources 处理项目测试资源
	* generate-test-resources
	* process-test-resources
	* test-compile 编译项目测试代码
	* process-test-classes
	* test 执行单元测试
	* prepare-package
	* package 打包成可发布的格式，如 jar
	* pre-integration-test
	* integtration-test 集成测试
	* post-integration-test
	* verify
	* install 安装到本地仓库
	* deploy 推送到远程仓库
* site:建立和发布项目站点
	* pre-site 之前的准备工作
	* site 生成项目站点文档
	* post-site 之后需要完成的工作
	* site-deploy 将项目生成的站点发布到服务器上 

### 依赖  

快照版本和稳定版本，Maven 会从仓库中查找快照版本的最新版本。开发测试时可以指定打包的版本为快照版本，加上后缀即可。

依赖解析机制： 

1. 依赖范围是 `system` 时，直接从本地文件系统解析。   
2. 从本地仓库查找，没有下一步。
3. 从所有远程仓库查找。
4. 如果依赖的版本是 `RELEASE` 或 `LATEST` 则读取所有远程仓库的 jar 包元信息（maven-metadata.xml），计算出实际的值，然后根据实际值进行 `2` `3` 步操作。
5. 如果依赖的是快照版本，则遍历所有仓库，读取源信息，查出最新的版本，然后进行 `2` `3` 步操作。
6. 如果得到的构建版本是时间戳格式的快照，则复制时间戳格式文件到对应的快照版本。

依赖元素配置：

* `groupId`: 项目，比如：`com.xiaotian.note`
* `artifactid`：模块，比如 `note-server` `note-core` 等。
* `version`: 版本号，比如 `1.1.0-SNAPSHOT` `1.1.0-RELEASE` 等。
* `type`：依赖的类型，对应坐标的 `packaging`。
* `scope`：依赖范围：Maven有三种 `classpath`，分别是 编译、测试和运行时。
	* `test`：测试有效。
	* `provider`：编译和测试有效。
	* `runtime`：测试和运行有效。  
	* `compile`：编译、测试和运行时有效。默认配置。
	* `system`：慎用。
	* `import`：
* `optional`：标记依赖是否可选。
* `execlusions`：`排除依赖`。 

### 中央仓库、本地仓库、私服

推荐：本地仓库 -> 私服 -> 远程仓库的架构。

**中央仓库：**是存储 `jar` 包的公共仓库，可以通过网络访问。      
**私服：** 位于中央仓库和本地仓库之间，用于代理中央仓库，仓库中不存在的 `jar` 包会中央仓库下载。   
**本地仓库：** jar 包在电脑上的缓存仓库。  

远程仓库配置：

```xml
<profile>
    <id>good_repository</id>
    <!-- jar包仓库-->
    <repositories>
        <repository>
            <id>taobao</id>
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        </repository>
        <repository>
            <id>mvnrepository</id>
            <url>http://repo1.maven.org/maven2/</url>
        </repository>
        <repository>
            <id>spring-snapshots</id>
            <url>http://repo.spring.io/snapshot</url>
            <snapshots><enabled>true</enabled></snapshots>
        </repository>
        <repository>
            <id>spring-milestones</id>
            <url>http://repo.spring.io/milestone</url>
        </repository>
    </repositories>

    <!--插件仓库-->
    <pluginRepositories>
        <pluginRepository>
            <id>spring-snapshots</id>
            <url>http://repo.spring.io/snapshot</url>
        </pluginRepository>

        <pluginRepository>
            <id>spring-milestones</id>
            <url>http://repo.spring.io/milestone</url>
        </pluginRepository>
    </pluginRepositories>
</profile>

# 默认jdk版本

<profile>
    <id>jdk-1.8</id>
    <activation>
        <activeByDefault>true</activeByDefault>
        <jdk>1.8</jdk>
    </activation>
    <properties>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
    </properties>
</profile>
```

发布到远程仓库

	<distributionManagement>
		<repository>
			<id>nexus-releases</id>
			<url>http://192.168.1.110:8081/nexus/content/repositories/releases</url>
		</repository>
		<snapshotRepository>
			<id>nexus-snapshots</id>
			<url>http://192.168.1.110:8081/nexus/content/repositories/snapshots</url>
		</snapshotRepository>
	</distributionManagement>

### 仓库密码 

和指定仓库的ID对应即可。

	<server>
	  <id>nexus-releases</id>  
	  <username>admin</username>  
	  <password>admin</password> 
	</server>  
	<server> 
	  <id>nexus-snapshots</id>  
	  <username>admin</username>  
	  <password>admin</password> 
	</server> 

### 镜像仓库 中央仓库的完全复制

`mirrorOf` 指定对哪个仓库的访问会从当前镜像仓库中拉取数据。支持 `*` 所有，`external:*` 所有，除了本地访问(地址中包含localhost),`id1,id2` 指定id `*,!id1` 排除指定Id。 

	<mirror>
	  <id>mirrorId</id>
	  <mirrorOf>repositoryId</mirrorOf>
	  <name>Human Readable Name for this Mirror.</name>
	  <url>http://my.repository.com/repo/path</url>
	</mirror>

### 模块管理  

定义一个Mavan项目作为聚合项目，负责统一管理子模块的生命周期管理。在聚合模块执行命令相当于对所有的子模块执行命令。类似于批量管理，多用于不同模块内容经常一起变更的情况，此时可以对变更的模块进行统一执行测试，构建，打包，发布等生命周期。

	<modules>
	    <module>springcloud-context</module>
	    <module>springcloud-gateway</module>
	
	    <module>springcloud-eureka-server</module>
	    <module>springcloud-eureka-client</module>
	    <module>springcloud-eureka-center</module>
	
	    <module>springcloud-config-server</module>
	    <module>springcloud-config-client</module>
	
	    <module>springcloud-hystrix</module>
	    <module>springcloud-hystrix-dashboard</module>
	    <module>springcloud-hystrix-turbine</module>
	</modules>

### 父模块    
父模块，子模块会继承父模块的依赖和配置。通常会在公司内部定义统一的父模块（pom）进行jar包版本统一管理，其他项目的继承该pom，maven默认会从上级目录找父pom，如果没父pom和当前项目在同一级目录，需要指定父pom的路径 `<relativePath>../../spring-boot-dependencies</relativePath>`。

	<dependencyManagement>
	    <dependencies>
	        <dependency>
	            <groupId>org.springframework.boot</groupId>
	            <artifactId>spring-boot</artifactId>
	            <version>2.0.2.RELEASE</version>
	        </dependency>
	</dependencyManagement>

## 插件 

mvn 默认配置生命周期的全部插件版本，需要的时候只需指定引入插件的名字即可。如 生成源码、生成配置文件、编译组件等。

## 使用命令安装jar包到本地仓库  

命令： 

	mvn install:install-file -Dfile=G:\authorise-core.jar -DgroupId=com.enerbos -DartifactId=authorise-core -Dpackaging=jar -Dversion=2.0

安装dubbo:

    mvn install:install-file -Dfile=./dubbo-2.8.4.jar -DgroupId=com.alibaba -DartifactId=dubbo -Dpackaging=jar -Dversion=2.8.4