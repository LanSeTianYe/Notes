时间：2018-12-28 15:30:55 

## Docker镜像仓库搭建 

### 使用镜像搭建 

1. 拉取镜像: `docker pull registry`。

2. 启动镜像仓库: `docker run -d -p 5000:5000 registry:latest`。

2. 给本地镜像打标签：`docker tag image_id 127.0.0.1:5000/username/image_name`。

3. 推送镜像: `docker push 127.0.0.1:5000/username/image_name`。