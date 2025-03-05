时间：2025-03-05 14:41:41

参考：

1. [使用 buildx 构建多种系统架构支持的 Docker 镜像](http://dockeradv.baoshu.red/buildx/multi-arch-images.html)


## Docker buildx

使用 buildx 可以跨平台编译 Docker 镜像。

Docker 默认的 builder 实例不支持同时指定多个 `--platform`，我们必须首先创建一个新的 builder 实例手动替换。

```shell
docker buildx create --use --name mybuilder
```

**启动构建器**：

```shell
docker buildx inspect mybuilder --bootstrap  
```

**查看支持的平台**：

```shell
docker buildx ls
```

编译命令

```shell
docker buildx build --platform  linux/amd64,linux/arm64,linux/arm,linux/ppc64le -t sunfeilong1993/mkdocs-git-nginx:0.0.2 . --push
```

示例 Dockerfile：

```Dockerfile
FROM python:3.10.16-alpine3.21

# 安装
RUN apk update && \
    apk add git && \
    apk add nginx && \
    pip install mkdocs && \
    pip install mkdocs-material && \
    pip install mkdocs-git-revision-date-localized-plugin && \
    pip install mkdocs-awesome-pages-plugin && \
    pip install mkdocs-git-committers-plugin-2 && \
    pip install mkdocs-git-authors-plugin && \
    pip install mkdocs-git-revision-date-localized-plugin
    
# 当前处理器架构
# docker build -t sunfeilong1993/mkdocs-git-nginx:0.0.1 .
# docker push sunfeilong1993/mkdocs-git-nginx:0.0.1
# 支持多处理器架构构建
# docker buildx create --use --name mybuilder
# docker buildx inspect mybuilder --bootstrap
# docker buildx build --platform  linux/amd64,linux/arm64,linux/arm,linux/ppc64le -t sunfeilong1993/mkdocs-git-nginx:0.0.2 . --push
```