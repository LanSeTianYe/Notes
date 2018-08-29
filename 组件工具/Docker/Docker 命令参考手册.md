时间：2017/6/3 18:12:27  
参考：
 
1. [docker 安装](https://yeasy.gitbooks.io/docker_practice/install/centos.html)
 
## Docker 命令

1. 拉取镜像： `docker pull IMAGE_NAME:IMAGE_VERSION`
3. 查看镜像容器所占空间： `docker system df`
4. 镜像相关 `docker image command`   

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
5. 运行镜像
	* 指定端口，后台运行 `docker run -d -p 8080:80 image_id/image_name`

6. 构建镜像 `docker build [选项] 上下文路径（Docker服务器中的路径）`

	* 从当前文件加下构建： `docker build -t nginx:v3 .`
	* 从git仓库构建： `docker build https://github.com/twang2218/gitlab-ce-zh.git#:8.14`
	* 从压缩包构建：`docker build http://server/context.tar.gz`

	Docker命令行通过API调用的方式和Docker服务通信，构造的时候会把指定路径的内容打包上传到Docker服务器（默认为当亲目录）。
7. 容器相关 `docker container`

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
