时间：2017/12/15 10:59:59   
参考：

1. [etcd官网](https://coreos.com/etcd/)
2. [etcd3.2.11 文档](https://coreos.com/etcd/docs/latest/)


##

### 是什么

A distributed, reliable key-value store for the most critical data of a distributed system.

用于存储分布式系统关键数据的一个分布式的、可靠的键值存储系统。

#### 数据模型  
1. 用 `key-value` 的方式存储数据， 历史数据不会被删除，而是以版本号的方式更新数据，历史版版本的数据也可以被查询。  
  
#### 系统限制 
* 请求限制：目前可以保证1M数据量的的RPC请求，数据过大会导致其他请求的延迟提高。
* 存储限制：默认可以存储的数据量是2GB。可以通过 `--quota-backend-bytes` 进行配置，最大支持8GB。
#### 硬件要求  

#### 参数配置
 

### 可以做什么



  

