##   
时间：2017/6/3 18:12:27  
参考：
 
1. [慕课网Docker视频教程](http://www.imooc.com/video/14625)
 
##  

* 查看命令帮助文档

		sudo docker command_name --help
		sudo docker run --help0

* 常用命令

	* ps 列出容器列表

			sudo docker ps
	* images 列出镜像列表

			sudo docker images
	* run 创建一个新容器执行一个命令
		 * -d 后台运行
		 * -p 指定端口映射
		  
				# 本机端口映射到容器的80端口
				sudo docker run -d -p 8080:80 image_id/image_name
	* exec 在一个运行的容器中执行一个命令
	
			# 运行容器里的终端 
			sudo docker exec -it container_id/container_name bash
            # 运行ls命令
			sudo docker exec -it container_id/container_name ls
	* pull 从注册中心拉取一个镜像或 `repository`

			sudo docker pull image_name/image_ip_address
			sudo docker pull hub.c.163.com/library/nginx:latest
	* push 推送一个镜像或 `repository` 到注册中心
	* rname 重命名一个容器
	* rm  删除一个或多个容器
	* rmi 删除一个或多个镜像
	* kill 杀掉一个或多个运行的容器
	* stop 停止一个或多个正在运行的容器
	* build 执行DockerFile的命令
	* restart 重启容器
	
## 发布应用

### 运行 jpress
1. 下载jpress的war包，地址： [https://github.com/JpressProjects/jpress/tree/master/wars](https://github.com/JpressProjects/jpress/tree/master/wars)
2. 在Docker里下载Tomcat镜像。

		sudo docker pull hub.c.163.com/library/tomcat:latest
3. 创建 `Dockerfile`文件，并添加如下内容。(注意Dockerfile和jpress.war的位置)。

		# 以tomcat镜像为基础构建
		from hub.c.163.com/library/tomcat
		# 基本信息
		MAINTAINER xiaotian xiaotian163.com
		# 把要发布的war包拷贝到tomcat的webapps目录
		COPY jpress.war /usr/local/tomcat/webapps
4. 根据Dockerfile构建自己的镜像(在Dockerfile目录下执行)。

	    sudo docker build -t jpress:latest ./

5. 运行自己的镜像

		sudo docker run -d -p 8888:8080 jpress 
### 运行MySql数据库
1. 下载 mysql 镜像

		sudo docker pull hub.c.163.com/library/mysql:latest
2. 运行

		sudo docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=000000  -e MYSQL_DATABASE=jpress hub.c.163.com/library/mysql
3. 访问MySQL数据库。  
可以通过Docker所在主机的IP地址加端口号3306进行访问。
