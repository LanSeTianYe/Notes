时间：2019/1/2 16:38:34  

## Docker 网络管理  

### Docker Networking  

用于容器之间的网络通信，支持不同宿主机上的容器进行通信。同一个网络中的容器可以通过容器名直接访问。一个容器可以属于多个不同的网络。

**创建网络:**  

	docker network create test_network
**支持的选项：**

* `connect`：     将容器连接到创建的网络上。
	
		docker network connect [OPTIONS] NETWORK CONTAINER
* `create`：      创建一个网络。
	* `--scope`: 指定网络的作用范围。`local` 本机， `overlay` 跨宿主机。
* `disconnect`：  断开容器和网络的连接。

		docker network disconnect [OPTIONS] NETWORK CONTAINER
* `inspect`：     Display detailed information on one or more networks
* `ls`：          List networks
* `prune`：       Remove all unused networks
* `rm`：          Remove one or more networks




  

