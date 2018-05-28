* 时间： 2017/11/16 21:20:16  
* 参考：   
	1. [https://docs.docker.com/](https://docs.docker.com/)


###  构建Docker镜像    


### 运行 Service  

1. 创建docker-compose.yml 文件，写入下面内容。

		version: "3"
		services:
		  web:
		    # replace username/repo:tag with your name and image details
		    image: username/repo:tag
		    deploy:
			  # 复制因子，启动多少个
		      replicas: 5
		      resources:
		        limits:
		          cpus: "0.1"
		          memory: 50M
		      restart_policy:
		        condition: on-failure
 			# 主机端口：Docker内部端口
		    ports:
		      - "80:80"
		    networks:
		      - webnet
		networks:
		  webnet:
2. 执行命令，根据上面的配置文件启动容器。  

		docker stack deploy -c docker-compose.yml test_web

3. 相关命令

		docker service ls //查看启动的服务
		docker service ps test_web //查看对应服务下的container
4. 停止运行Service  
 
        docker stack rm test_web
		docker swarm leave --force

### Swarm (docker 集群)  

1. 初始化集群管理者  

		docker swarm init --advertise-addr 192.168.0.111  
2. 其他docker加入集群  

		docker swarm join --token 
3.    
			

 

