时间：2025-01-08 18:10:10

参考:

1. [prometheus-book](https://yunlzheng.gitbook.io/prometheus-book/parti-prometheus-ji-chu/quickstart)


## Prometheus 简介

架构图如下：

![架构图](../../../img/prometheus/prometheus-architecture.png)

Prometheus Server 通过拉取的方式采集监控指标有几种方式：

**方式一：**需要监控的服务通过暴露接口的方式，如 Service。

**方式二：**把数据推送到代理服务，由代理服务暴露接口。如 Prometheus Gateway。

**方式三 ：**第三方服务采集数据，然后暴露端口。如 cAdvisor 采集容器内Pod的状态（内存、CPU，进程等）。

**方式四：** 通过注册中心发现需要采集数据的服务，然后采集数据。（服务需暴露端口）

### Prometheus 高可用

**存储高可用：**Prometheus 默认把数据存储在本地磁盘。也可以配置远程存储`remote_write/remote_read`，把数据存储在远程系统，防止数据丢失。如Influxdb，自定义适配器存储到其它服务中。通过远程存储实现存储高可用。

**服务高可用：**联邦集群模式，如上图所示 **中间层 Prometheus Server** 采集各个集群的数据，**中心 Prometheus Server** 汇总中间层的数据。

下图是一种模式的高可用集群：

![架构图](../../../img/prometheus/prometheus_federal.png)
