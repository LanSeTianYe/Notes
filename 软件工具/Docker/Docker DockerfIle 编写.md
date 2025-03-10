时间：2018-08-27 16:47:53 

参考： 

1. [使用 Dockerfile 定制镜像](https://yeasy.gitbooks.io/docker_practice/image/build.html)

## DockerFile 编写

### 命令介绍

1. `FROM`：指定基础镜像。 

    |类型|镜像名称|
    |:--:|:--:|
    |空白镜像|scratch|
    |系统|alpine|
    |系统|ubuntu|
    |系统|centos|
    |系统|fedora|
    |服务器|nginx|
    |服务器|redis|
    |服务器|mysql|
    |服务器|httpd|
    |服务器|tomcat|
    |语言|openjdk|
    |语言|python|
    |语言|golang|


2. `RUN`：执行命令。

  *  shell 格式：`RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html`

   需要执行多个命令的时候，为了减少分层，把多个命令定义成一个变量，然后执行。

   注：在变量结尾添加清除命令，清除安装过程产生的临时文件

  ```Dockerfile
  RUN buildDeps='gcc libc6-dev make' && apt-get update && apt-get purge -y --auto-remove $buildDeps
  ```

   *  exec 格式：`RUN ["可执行文件", "参数1", "参数2"]`

3. `COPY` 复制文件，文件必需和 Dockerfile 在统一目录下（原始文件不解压）。

    * 单文件复制：`COPY <源路径>... <目标路径>`， 比如 `COPY package.json /usr/src/app/`，支持正则表达式，比如 `COPY hom?.txt /mydir/`。
    * 多文件复制：`COPY ["<源路径1>",... "<目标路径>"]` ，源路径可以是多个文件，或者则表达式。

4. `ADD` 文件复制的补充，自动解压缩，从URL下载文件等。将构建环境中的文件复制到镜像中（不推荐使用），当文件是压缩文件时会自动解压。（优先使用 COPY）

    ```shell
    # 把构建目录下的index.html文件复制到镜像指定目录
    ADD index.html /user/share/nginx/index.html
    # 自动解压到目录
    ADD ubuntu-xenial-core-cloudimg-amd64-root.tar.gz /
    ```

5. `CMD` 指定容器启动时运行的命令和参数，如果 `docker run` 后面有指令则会覆盖 `CMD`。
	
	* `CMD <命令>`，比如：`CMD echo $HOME`
	* `CMD ["可执行文件", "参数1", "参数2"...]`。比如：`CMD ["nginx", "-g", "daemon off;"]`
	
6. `ENTRYPOINT` 入口点，传递参数给执行的命令。`docker run` 后面的指令会被当作 `ENTRYPOINT` 的参数。
	
    ```dockerfile
    FROM ubuntu:16.04
    RUN apt-get update \
    && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*
    ENTRYPOINT [ "curl", "-s", "http://ip.cn"]
    ```
	
    运行容器 `docker run myip -i`，`-i` 会作为参数传递给 `ENTRYPOINT` 指定的命令。
    
7. `ENV` 环境变量。不仅在镜像构建过程中可用，而且会被持久化到镜像里。当基于该镜像启动容器时，这些环境变量会在容器内部生效，可被容器内的进程访问。

    ```
    ENV <key> <value>
    ENV <key1>=<value1> <key2>=<value2>...
    ```

    例子：

    * `ENV RVM_PATH /home/redis`：设置环境变量。
    * `ENV RVM_PATH /home/redis RVM_ARCHFLAGS="-arch i386"`:设置多个环境变量。
    * `WORKDIR $RVM_PATH`: 引用环境变量。

8. `ARG`: 定义参数名称，以及定义其默认值。该默认值可以在构建命令 `docker build` 中用 `--build-arg <参数名>=<值>` 覆盖。

    * 主要用于构建镜像阶段，作用范围仅限于 `Dockerfile` 内部的构建过程。一旦镜像构建完成，这些参数不会保留在镜像中，也不会传递到基于该镜像运行的容器中。 
    * 如果在 `FROM` 指令前，只能用在 `FROM` 指令中。

    ```shell
    # 参数名字
    ARG build
    ARG webapp_user=user
    # 传递参数 build接收1234，webapp_user使用默认值 
    docker build --build-arg build=1234 -t jamtur01/webapp .
    ```

9. `VOLUME` 指令用于在 Docker 镜像中创建一个或多个挂载点。

    这些挂载点可以用来将容器内的目录与宿主机上的目录进行绑定挂载，或者在多个容器之间共享数据。其主要目的是实现数据的持久化存储和容器间的数据共享，避免因容器的销毁而导致数据丢失。

    当在 `Dockerfile` 中使用 `VOLUME` 指令创建挂载点后，在基于该镜像创建容器时，`Docker` 会自动为这些挂载点分配存储空间。如果没有指定宿主机上的具体挂载目录，`Docker` 会在宿主机的 `/var/lib/docker/volumes` 目录下创建一个匿名卷，并将其挂载到容器内指定的路径。如果指定了宿主机上的挂载目录，那么容器内的挂载点将与宿主机上的目录进行绑定，实现数据的同步。

    `VOLUME` 指令会阻止后续对该目录的任何 `RUN`、`COPY` 或 `ADD` 操作。也就是说，如果在 `VOLUME` 指令之后尝试对挂载点目录进行文件复制或修改操作，这些操作将不会生效。

    ```dockerfile
    # 格式
    VOLUME ["<路径1>", "<路径2>"...]
    
    # 单个挂载点
    VOLUME ["/path/in/container"]
    # 多个挂载点
    VOLUME ["/path1/in/container", "/path2/in/container"]
    ```

10. `EXPOSE` 指令用于声明容器运行时会监听的端口。

    `EXPOSE` 指令向 `Docker` 表明容器内应用程序监听的端口号，让 `Docker` 知道容器打算使用哪些端口进行通信。这有助于在容器之间进行网络连接和端口映射时提供清晰的元数据。例如，一个 `Web` 应用容器通常会监听 `80` 端口（HTTP）或 443 端口（HTTPS），使用 `EXPOSE` 指令声明这些端口，能让其他容器或外部系统了解该容器的网络访问需求。

    需要注意的是，`EXPOSE` 指令本身并不会实际完成端口映射的操作。它只是一个声明，用于记录容器使用的端口信息。实际的端口映射是在使用 `docker run` 命令时通过 `-p`（用于将容器端口映射到宿主机的指定端口）或 `-P`（随机将容器端口映射到宿主机的一个高端口）选项来实现的。

    ```dockerfile
    # 格式为 
    EXPOSE <端口1> [<端口2>...]
    
    # 声明容器监听 80 端口，使用默认的 TCP 协议
    EXPOSE 80
    # 声明容器同时监听 80 端口（TCP协议）和 443 端口（TCP协议）
    EXPOSE 80 443
    # 声明容器监听53端口，明确指定UDP协议
    EXPOSE 53/udp 
    ```

11. `WORKDIR` 指令用于为 `Dockerfile` 中后续的 `RUN`、`CMD`、`ENTRYPOINT`、`COPY` 和 `ADD` 指令设置工作目录。简单来说，它就像是在容器内部 “切换目录”，后续的操作都会基于这个指定的目录来执行。

      ```dockerfile
      WORKDIR /opt/webapp/db
      RUN bundle install
      WORKDIR /opt/webapp
      ENTRYPOINT ["rackup"]
      ```

12. `USER` 指定镜像以什么用户运行。默认使用 root 用户运行。

       ```dockerfile
       RUN groupadd -r nginx && useradd -r -g nginx nginx
       USER nginx
       RUN ["nginx"]
       ```

13. `HEALTHCHECK` 健康检查。

      ```dockerfile
      FROM nginx:latest
      
      # 设置健康检查，每隔 5 秒检查一次，超时时间为 3 秒，启动 10 秒后开始检查，最多允许失败 2 次
      HEALTHCHECK --interval=5s --timeout=3s --start-period=10s --retries=2 \
          CMD curl -f http://localhost/ || exit 1
      ```

14. `ONBUILD` 添加触发器，当镜像作为基础镜像使用时触发，会在 `FROM` 之后执行触发器指定的任务。

       ```dockerfile
       # 语法
       ONBUILD <其它 Dockerfile 指令>
       
       这里 <其它 Dockerfile 指令> 可以是除 FROM、MAINTAINER、ONBUILD 之外的任何 Dockerfile 指令，像 RUN、COPY、ADD 等。
       
       # 例子
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
       ```

       基于上面的镜像构造镜像（会把Dockerfile目录下的所有文件拷贝到 /var/www 目录）：

       ```shell
       FROM jamtur01/apache2　
       MAINTAINER James Turnbull "james@example.com"　
       ENV APPLICATION_NAME webapp　
       ENV ENVIRONMENT development
       ```

15. `LABEL`: 给镜像添加元数据。允许你将一些描述性信息嵌入到 Docker 镜像中。这些信息可以包含镜像的作者、版本、用途、许可证等，就像是给镜像贴上了 “标签”，方便后续对镜像进行识别和管理。

      ```dockerfile
      LABEL version="1.0"
      LABEL location="New York" type="Data Center" role="Web Server"
      ```

16. `SHELL`：用于指定后续 `RUN`、`CMD` 和 `ENTRYPOINT` 指令所使用的默认 shell 命令。

     ```dockerfile
     # 指定使用 /bin/bash 并开启 -o pipefail 选项
     SHELL ["/bin/bash", "-o", "pipefail", "-c"]
     
     # 后续的 RUN 指令会使用指定的 shell 执行
     RUN apt-get update && apt-get install -y some-package
     ```

17. `STOPSIGNAL`：设置停止容器时发送什么系统调用信号给容器。这个信号必须是内核系统调用表中合法的数，如 9，或者 `SIGNAME` 格式中的信号名称，如 `SIGKILL`。