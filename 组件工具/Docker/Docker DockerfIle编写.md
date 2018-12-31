时间：2018/8/27 16:47:53   
参考： 

1. [使用 Dockerfile 定制镜像](https://yeasy.gitbooks.io/docker_practice/image/build.html)


## 构建Docker镜像    

### 命令介绍

1. `FROM` :指定基础镜像。  

	常用的基础镜像 nginx、redis、mongo、mysql、httpd、php、tomcat等。

2. `RUN` 执行命令。

	* 执行 Shell 命令：`RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html`
	
		需要执行多个命令的时候，为了减少分层，把多个命令定义成一个变量，然后执行。  
		注：在变量结尾添加清除命令，清除安装过程产生的临时文件

			RUN buildDeps='gcc libc6-dev make' \
		    && apt-get update 
			&& apt-get purge -y --auto-remove $buildDeps
	*  exec 命令

3. `COPY` 复制文件，文件必需和Dockerfile在统一目录下（原始文件不解压）。

	* 单文件复制：`COPY <源路径>... <目标路径>`， 比如 `COPY package.json /usr/src/app/`
	* 多文件复制：`COPY ["<源路径1>",... "<目标路径>"]` ，源路径可以是多个文件，或者则表达式。

4. `ADD` 文件复制的补充，自动解压缩，从URL下载文件等。将构建环境中的文件复制到镜像中（不推荐使用），当文件是压缩文件时会自动解压。

		# 把构建目录下的index.html文件复制到镜像指定目录
		ADD index.html /user/share/nginx/index.html
5. `CMD` 指定容器启动时运行的命令和参数，如果 `docker run` 后面有指令则会覆盖 `CMD`。
	* `CMD <命令>`
	* `CMD ["可执行文件", "参数1", "参数2"...]`（推荐使用）。
	
	例如：`["/bin/bash", "-l"]` 

6. `ENTRYPOINT` 入口点，传递参数给执行的命令。`docker run` 后面的指令会被当作 `ENTRYPOINT`的参数。

	Dokcer 文件：
	
		FROM ubuntu:16.04
		RUN apt-get update \
	    && apt-get install -y curl \
	    && rm -rf /var/lib/apt/lists/*
		ENTRYPOINT [ "curl", "-s", "http://ip.cn" ]
	
	运行容器 `docker run myip -i`，`-i` 会作为参数传递给 `ENTRYPOINT` 指定的命令。
7. `ENV` 环境变量

		ENV <key> <value>
		ENV <key1>=<value1> <key2>=<value2>...

	例子：
	* `ENV RVM_PATH /home/redis`：设置环境变量。
	* `ENV RVM_PATH /home/redis RVM_ARCHFLAGS="-arch i386"`:设置多个环境变量。
	* `WORKDIR $RVM_PATH`: 引用环境变量。

8. `ARG` 构建参数

		格式：ARG <参数名>[=<默认值>]

9. `VOLUME` 向基于镜像创建的容器添加卷。一个卷可以存在于一个或多个容器内的特定目录，这个目录可以绕过联合文件系统，提供数据共享或持久化的功能。

	* 容器间共享和重用。
	* 卷不一定必须共享。
	* 对卷的修改立即生效。
	* 对卷的修改不会对更新镜像产生影响。
	* 卷会一直存在直到没有任何容器再使用它。

    通过卷可以将数据、数据库获取他内容天机大到镜像中，而不是提交到镜像中，并且允许多个容器共享这些内容。
		
		VOLUME ["<路径1>", "<路径2>"...]
		VOLUME <路径>
	例子：
	* `VOLUME ["/opt/project"]`
10. `EXPOSE` 声明端口

		格式为 EXPOSE <端口1> [<端口2>...]

11. `WORKDIR` 在容器内部设置一个工作目录，`ENTRYPOINT` 和 `CMD` 指定的程序会在这个目录下执行。

		WORKDIR /opt/webapp/db
		RUN bundle install
		WORKDIR /opt/webapp
		ENTRYPOINT ["rackup"]

12. `USER` 指定镜像以什么用户运行。默认使用 root 用户运行。

	* `user nginx`: 用 nginx 身份运行。
13. `HEALTHCHECK` 健康检查
14. `ONBUILD` 添加触发器，当镜像作为基础镜像使用时触发，会在 `FROM` 之后执行触发器指定的任务。

	添加触发器：

		FROM ubuntu:14.04　
		MAINTAINER James Turnbull "james@example.com"　
		RUN apt-get update && apt-get install -y apache2　
		ENV APACHE_RUN_USER www-data　
		ENV APACHE_RUN_GROUP www-data　
		ENV APACHE_LOG_DIR /var/log/apache2　
		ONBUILD ADD . /var/www/　
		EXPOSE 80　
		ENTRYPOINT ["/usr/sbin/apache2"]　
		CMD ["-D", "FOREGROUND"]
	基于上面的镜像构造镜像（会把Dockerfile目录下的所有文件拷贝到 /var/www 目录）：

		FROM jamtur01/apache2　
		MAINTAINER James Turnbull "james@example.com"　
		ENV APPLICATION_NAME webapp　
		ENV ENVIRONMENT development


15. `LABEL`: 给镜像添加元数据。

		LABEL version="1.0"
		LABEL location="New York" type="Data Center" role="Web Server"
16. `STOPSIGNAL`：设置停止容器时发送什么系统调用信号给容器。这个信号必须是内核系统调用表中合法的数，如9，或者SIGNAME格式中的信号名称，如SIGKILL。
17. `ARG`: 接收docker运行镜像时传递的参数。

		#参数名字
		ARG build
		ARG webapp_user=user
		# 传递参数 build接收1234，webapp_user使用默认值 
		docker build --build-arg build=1234 -t jamtur01/webapp .
