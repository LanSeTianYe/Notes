时间： 2018/6/9 10:40:08   

参考：  

1. [官网](https://kubernetes.io/)
2. [minikube](https://github.com/kubernetes/minikube)


## 简介 

Kubernetes 是一个跨主机管理、提供基础的部署机制、维护和扩展容器化应用程序的开源系统。

### 概念

* Pod（荚）：为了管理和网络的原因绑定在一起的一个或多个容器的分组。



## 准备使用  
### minikube 安装  

1. [minikube](https://github.com/kubernetes/minikube) 参考github地址。

		curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
2. 启动 minikube 

		minikube start --vm-driver=xhyve
3. 使用 

		# 获取服务的URL地址
		minikube service hello-node

### kubectl 安装 

1. 下载安装
 
		curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl
2. 命令使用

		# 选择容器 
		kubectl config use-context minikube
		# 获取部署状态 
		kubectl get deployments
		# 获取pods
		kubectl get pods
		# 查看集群事件
		kubectl get events
		# 查看 kubectl 配置信息
		kubectl config view
		# 暴露服务，集群外的机器可以访问
		kubectl expose deployment hello-node --type=LoadBalancer
		# 查看运行的服务
		kubectl get services
		# 查看日志
		kubectl logs <POD-NAME>
		# 更新应用
		kubectl set image deployment/hello-node hello-node=hello-node:v2
### docker 应用程序编写

1. 编写代码（node） 

		var http = require('http');
		
		var handleRequest = function(request, response) {
		  console.log('Received request for URL: ' + request.url);
		  response.writeHead(200);
		  response.end('Hello World!');
		};
		var www = http.createServer(handleRequest);
		www.listen(8080);
2. 编辑docker配置文件（DockerFile）

		FROM node:6.9.2
		EXPOSE 8080
		COPY server.js .
		CMD node server.js
3. 构建docker镜像  

		docker build -t hello-node:v1 .



		
		