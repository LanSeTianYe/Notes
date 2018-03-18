时间：2018/3/18 10:12:39   

##  

### 简介
### 基本概念
* groupId：定义到项目 `com.sun.xiaotian.learn`。
* artifactId：定义项目的模块 `learn-core`。
* version：版本 `1.0.0`。
* packaging：打包方式 `jar\war\pom` 等，可选属性，默认是 `jar`。
* classifier：定义构建输出的一些附属构件，不能显示指定，如 java doc等。
* dependencyManagement:依赖管理，用于约束子模块的版本，不会被实际引入到子项目。
* 继承：继承parent。
* 聚合：同时编译多个模块儿。
	
		<models>
			<model>mpdelA<model>
			<model>mpdelA<model>
		</models>
* 反应堆：先构造该项目依赖的项目。
* 私服：Nexus搭建私服。
* profile:可以用来灵活的指定当前项目使用的资源文件、远程仓库和jdk版本等。
		
		<profile>
				<id>prod</id>
				<properties>
					<env>dev</env>
				</properties>
				<build>
					<resources>
						<resource>
							<directory>src/main/resources-env/dev</directory>
						</resource>
						<resource>
							<directory>src/main/resources</directory>
						</resource>
					</resources>
				</build>
			</profile>

* 依赖传递：第一路径短的优先，第二在路径长短一样的情况下，在pom文件中，声明在前面的优先。
* 排除依赖：
* `version`:变量
* 仓库：本地仓库，远程仓库（公共仓库、私服、第三方公共仓库）
* 镜像：公共仓库的副本
* 生命周期：(每种生命周期的阶段是有序的，且后面的阶段依赖于前面的阶段)
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
* 编写打包插件以及构建项目插件 

### 命令
* mvn -h 显示帮助
* mvn clean：清空生成
* mvn compile
* mvn test 执行测试代码
* mvn package
* mvn install:安装到本地仓库
* mvn install -Dmaven.test.skip=true 跳过执行测试
* mvn clean install -U 更新最新版本
* mvn deploy 发布到远程仓库
* mvn site
* mvn clean deploy site-deploy 跨越三个生命周期
* mvn dependency:list 依赖列表
* mvn dependency:tree 依赖树
* mvn dependency:analyze 分析依赖问题
* mvn help：system 系统属性 

### 依赖配置 

	<dependency>
		<groupId></groupId>
		<artifactId></artifactId>
		<version></version>
		<type></type>  依赖的类型，对应于 packaging
		<scope></scope> 依赖范围
		<optional></optioinal>标记依赖是否可选
		<exclusions> 排除传递依赖
			<exclusion>
			</exclusion>
		</exclusions>
	</dependency>
* type：依赖范围 编译、测试和运行。
	* compile：默认
	* test ：
	* provided：
	* runtime：
	* system：
	* import：

		![依赖范围和classpath的关系](http://7xle4i.com1.z0.glb.clouddn.com/%E4%BE%9D%E8%B5%96%E8%8C%83%E5%9B%B4.png)
