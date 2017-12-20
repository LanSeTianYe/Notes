## 关于  

平时记录的一些笔记，方便自己随时查询。严格来说并不能称为博客，因为大多是记录一些技术的使用。  

内容会一直完善。  

## 目前可以作什么    

Blogger内容以md文档进行存储。

Blogger内容存储在Github上，后台项目启动时会从Github拉取更新，项目运行期间也可以调接口更新Blogger内容。

在本地编辑完成之后，把更改提交到Github，然后调用接口就可以更新网站的内容。

考虑后期文件可能变更目录，所以数据库存储的数据的主键根据文件名生成，这样在变更文件所属的目录之后，文件的相关信息不会丢失。缺点是如果文件名相同，文件名的信息会混乱。

## 怎么搭建

### 项目组成

1. [后台](https://github.com/longlongxiao/Blogger_FrontEnd) 基于Java的系统，记录数据以及提供数据查询接口，可以直接以jar包的方式运行。
2. [前端](https://github.com/longlongxiao/Blogger_Backstage) 数据展示以及数据查询。
3. [内容](https://github.com/longlongxiao/Notes) 博客内容，通过目录结构组织起来的md文档，前端也以目录结构的方式进行展示。

### 项目搭建（Linux）    
#### 准备：  

1. 安装的软件 `git` 拉取项目，`nginx` 发布前端项目，`maven`打包后端项目，`jdk`运行后台项目， `mysql` 存储项目数据。

#### 搭建： 

1. 用 `git` 把 `后台项目`，`前端项目` 和 `你的Blogger内容` 拉到服务器上。
2. 在mysql中创建存放数据的数据库，如 `blogger`。
2. 修改前端项目的接口请求地址, 在 `javascript/constant.js`里面，如：

		var HOST = 'http://www.sunfeilong.cn:8080';
3. 修改 `nginx` 配置文件 `/conf/nginx.conf`,指定静态目位置。

		location / {
            root   /home/xiaotian/workspace/Blogger_FrontEnd;
            index  html/blogger.html;
        }
3. 进入后端项目目录使用 `mvn clean; mvn install` 打包后端项目，然后复制 `target` 目录下的jar包，到你想要放置项目文件的目录。

4. 在防止项目jar包的目录创建 `application.properties`  文件，添加如下内容，并修改为你自己的内容。

		## 后台项目启动端口号
		server.port = 8080
		## 数据库连接信息
		spring.datasource.url=jdbc:mysql://127.0.0.1:3306/你创建的数据库名称
		spring.datasource.username=你的数据库用户名
		spring.datasource.password=你的数据库密码
		spring.datasource.driver-class-name=com.mysql.jdbc.Driver
		
		# Specify the DBMS
		spring.jpa.database = MYSQL
		# Show or not log for each sql query
		spring.jpa.show-sql = true
		# Hibernate ddl auto (create, create-drop, update)
		spring.jpa.hibernate.ddl-auto = update
		# Naming strategy
		spring.jpa.hibernate.naming-strategy = org.hibernate.cfg.ImprovedNamingStrategy
		
		# stripped before adding them to the entity manager)
		spring.jpa.properties.hibernate.dialect = org.hibernate.dialect.MySQL5Dialect
		
		## filePath Blogger内容的目录
		filePath=/home/xiaotian/workspace/Notes
		
		## 允许跨域访问的地址，多个以逗号分割
		allowOrigins=http://localhost:63342,http://www.sunfeilong.cn,http://182.61.52.178
		## 首页展示内容的名字
		initLoadArticleName=AboutMe
		
		## 需要隐藏的文件的名字(不在左侧目录结构里面展示)
		hideInLeftMenuFileName=AboutMe,ReadMe
		
5. 执行如下命令，在后台启动后台项目，下面 `blogger.jar` 是第三步打的jar包的名字。

		nohup java --add-modules java.xml.bind -jar -Dfile.encoding=UTF-8 -Dspring.config.location=./application.properties ./blogger.jar > log.txt &
6. 启动nginx，此时访问你的网站应该可以看到数据。



