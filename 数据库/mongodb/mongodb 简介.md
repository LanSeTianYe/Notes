时间：2017/8/8 10:13:05  

参考：

1. [MongoDB 通过配置文件启动](https://blog.csdn.net/zhu_tianwei/article/details/44261235)
 
环境：
  
1. MongoDB 3.6.2 Community

## 简介  
### 核心概念    
#### [存储](https://docs.mongodb.com/manual/storage/)  
1. 存储引擎 
	* WiredTiger：3.2及之后版本默认的存储引擎。 提供文档级别的并发模型、检查点、数据压缩和其它特性。企业版支持数据加密。
	* MMAPv1：3.2之前版本的默认存储引擎，在大量读写和实时更新方面性能较好。
	* In-Memory Storage Engine ： 企业版特有，把数据存储在内存中。

1. [GridFS](https://docs.mongodb.com/manual/core/gridfs/)：文件存储系统，适用于大文件或大文档。 

### 特性  

1. [模式验证 （Schema Validation）](https://docs.mongodb.com/manual/core/schema-validation/)：限制字段存储数据的类型等。
2. [视图](https://docs.mongodb.com/manual/core/views/)：只读，不能改名。3.4+
3. [固定容量集合](https://docs.mongodb.com/manual/core/capped-collections/):集合大小固定，类似于一个环，当存储数据超过指定大小时，会删除以前的记录。不能删除元素，不能分片。

		# size bytes，最小 4096
		db.createCollection("log", { capped: true, size: 100000 } )
		db.createCollection("log", { capped: true, size: 5242880, max: 5000 } )
5. 文档字段可动态扩展。
6. 支持文档搜索和地理空间搜索，精简版的 Elasticsearch。
7. 支持索引。
8. 单文档原子性。
6. 集合分片，扩容。
7. 主从备份，容灾。

### Linux 安装（CentOS）

1. 安装依赖

		yum install libcurl openssl
	  
2. 下载 tar 压缩包，并解压

3. 修改 `/etc/profile` 文件，替换环境变量。

		export PATH=<mongodb-install-directory>/bin:$PATH
4. 修改配置文件
		
		# 数据存放目录
		dbpath= /home/data/mongodb/
		# 认证模式
		auth = false
		# 绑定IP
		bind_ip = 0.0.0.0

5. 启动

		mongod --config ../conf/mongod.conf







	