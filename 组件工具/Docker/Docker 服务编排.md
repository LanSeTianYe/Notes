时间：2019/1/7 14:39:59   

## Docker 服务编排   

### Docker Compose

#### Docker Compose 简介  

使 Docker容器 像服务一样运行，通过编写 `yaml` 文件，定制 docker 容器的运行方式。 

#### 下载和安装  

1. 下载： `sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`

2. 变更为可执行文件： `chmod +x /usr/local/bin/docker-compose`
3. 检查版本：`docker-compose --version`

#### Docker-Compose 命令使用  

**选项：**

* `help`：显示帮助信息。
* `up`：启动容器服务。
	* `-d`：后台运行。
* `ps`：显示启动容器列表。
* `logs`：显示日志信息。
* `stop`：停止服务。
* `kill`：停止服务。
* `start`：开始服务。
* `rm`：删除服务。

#### 配置文件 

	web:
	  image:
	    sunfeilong1993/app:0.0.1
	  command:
	    python app.py
	  ports:
	    - "5000:5000"
	  volumes:
	    - .:/compose
	  links:
	    - redis
	
	redis:
	  image:
	    redis






















