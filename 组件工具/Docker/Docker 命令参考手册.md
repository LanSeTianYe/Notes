时间：2017/6/3 18:12:27  
参考：
 
1. [docker 安装](https://yeasy.gitbooks.io/docker_practice/install/centos.html)
 
## Docker 命令    

docker 帮助信息 `docker --help`

docker 具体命令帮助信息 `docker command --help`

容器存放目录：`/var/lib/docker/containers`

镜像存放目录：`/var/lib/docker/devicemapper/`
 
### 容器命令  

0. 从镜像启动容器 `docker run`，例如: `docker run -d -p 8080:80 image_id/image_name command`

	`command` 表示要在容器中执行的命令，如 打开命令行 `/bin/bash`，启动nginx `nginx -g "deamon off"`
	* `-d`: 后台运行。 
	* `-p`: 指定 `宿主机端口：容器暴露端口`
	* `-P`：对外公开容器构造时暴露的端口，并绑定到一个随机端口上。
	* `--name`: 指定容器名字。
	* `--net`：指定容器使用的网络。同一个网络中的容器可以通过容器名直接访问 `ping container_name`。
	* `--restart condition`: 当容器停止运行之后自动重启容器。
		* `always`: 总是自动重启。
		* `on-failure`: 当容器推出代码不为0时自动重启。
		* `on-failure:failure_times`: 限制重启次数，超过之后不重启。  
0. 停止运行中的容器：
	* `docker stop`：发送停止命令。
	* `docker kill`：直接结束运行。

0. 删除容器: `docker rm container_id`
	* `-f` 删除运行中的容器。
	* `docker rm 'docker ps -a -q'`

0. 查看运行的容器  `docker ps`
	* `-l`: 最后运行的一个容器
	* `-a`: 所有运行的（包含已经结束运行的）。 
	* `-q`: 只显示容器Id。
	* `-n number`： 显示最后运行的 `number`  个容器（包含已经结束的容器）。
0. 查看容器详细信息 `docker inspect continer_id`

0. 查看容器内运行的进程 `docker top container_id`

0. 查看容器运行状态 `docker stats container_id1 container_id1 ...`

0. 容器内部运行进程 `docker exec`

	* 交互式命令行 `docker exec -it containers_id /bin/bash`
	* 后台进程 `docker exec -d containers_id 进程名字`

0. 查看镜像容器所占空间： `docker system df`

0. 运行日志 `docker logs`
	* 默认输出最后几行日志
	* `-f`：持续输出。
	* `-t`：显示日志时间。
0. 查看绑定端口：`docker port container_id`

### 镜像命令

0. 账号登陆 `docker login` 

0. 拉取镜像： `docker pull IMAGE_NAME:IMAGE_VERSION`

0. 提交镜像：`docker commit container_id username/container_name:tag`
	* `-a`：作者信息
	* `-m`：注释
0. 推送镜像 `docker push image_name:image_version`

0. 查找镜像： `docker search image_name`

0. 删除镜像 `docker rmi image_id`。 

0. 列出docker里面的镜像 `docker images`
 
0. 镜像 `docker image command`   

	    build       Build an image from a Dockerfile
		history     Show the history of an image
		import      Import the contents from a tarball to create a filesystem image
		inspect     Display detailed information on one or more images
		load        Load an image from a tar archive or STDIN
		ls          List images
		prune       Remove unused images
		pull        Pull an image or a repository from a registry
		push        Push an image or a repository to a registry
		rm          Remove one or more images
		save        Save one or more images to a tar archive (streamed to STDOUT by default)
		tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE

0. 构建镜像 `docker build [选项] 上下文路径（Docker服务器中的路径）`
	
	* `--no-cache`：不使用构造缓存。  
	* `-t "user_name/image_name:version"`：指定镜像名和版本。  
	* `--build-arg`:传递参数给Deckerfile里面的变量名 `docker build --build-arg build=1234 -t jamtur01/webapp .`  
	* `-v`：把宿主机的目录挂载到容器。卷可以在容器间共享。即便容器停止，卷里的内容依旧存在。  

	例子：

	* 从当前文件加下构建： `docker build -t nginx:v3 .`  
	* 从git仓库构建： `docker build https://github.com/twang2218/gitlab-ce-zh.git#:8.14`  
	* 从压缩包构建：`docker build http://server/context.tar.gz`  
	* 挂载目录:（`ro:只读 rw：读写`）   
 
			docker run -d -p 80 --name website -v $PWD/website:/var/www/html/website:ro jamtur01/nginx nginx

	Docker命令行通过API调用的方式和Docker服务通信，构造的时候会把指定路径的内容打包上传到Docker服务器（默认为当前目录）。

0. 镜像构造过程： `docker history image_id`  
0. 容器相关 `docker container`

		attach      Attach local standard input, output, and error streams to a running container
		commit      Create a new image from a container's changes
		cp          Copy files/folders between a container and the local filesystem
		create      Create a new container
		diff        Inspect changes to files or directories on a container's filesystem
		exec        Run a command in a running container
		export      Export a container's filesystem as a tar archive
		inspect     Display detailed information on one or more containers
		kill        Kill one or more running containers
		logs        Fetch the logs of a container
		ls          List containers
		pause       Pause all processes within one or more containers
		port        List port mappings or a specific mapping for the container
		prune       Remove all stopped containers
		rename      Rename a container
		restart     Restart one or more containers
		rm          Remove one or more containers
		run         Run a command in a new container
		start       Start one or more stopped containers
		stats       Display a live stream of container(s) resource usage statistics
		stop        Stop one or more running containers
		top         Display the running processes of a container
		unpause     Unpause all processes within one or more containers
		update      Update configuration of one or more containers
		wait        Block until one or more containers stop, then print their exit codes




