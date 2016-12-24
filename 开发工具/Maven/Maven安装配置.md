
日期：2016/12/24 23:04:17
  
*************************

## 下载安装
1. 下载地址  [http://maven.apache.org/](http://maven.apache.org/) 。
2. 解压之后再环境变量中增加 `Maven` 的 `bin` 目录。

## 配置

### 修改本地Maven仓库位置

Maven 默认的本地仓库位置是当前用户目录下的 `.m2\repository` 目录。  

1. 从 Maven 的 config 目录下面复制 `setting.xml` 放在默认的本地仓库目录下。
2. 在 `setting.xml` 目录下添加如下配置(路径是新Maven仓库位置):

		<localRepository>D:\.m3\repository</localRepository>


  
### 修改远程仓库

1. 在 `setting.xml` 中添加仓库地址下内容，（主要是淘宝的）

		<profiles>
			<!--Maven 远程仓库-->
			<profile>
				<id>good_repository</id>
		
				<activation>
					<property>
						<name>target_rep</name>
						<value>constum_rep</value>
					</property>
				</activation>

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
			
		  </profiles>

		  <activeProfiles>
		    <activeProfile>good_repository</activeProfile>
		  </activeProfiles>



	