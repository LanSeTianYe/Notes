时间：2020-09-11 15:22:22

参考：

1.  [https://dgraph.io/downloads#download-linux](https://dgraph.io/downloads#download-linux)

环境：

1. CentOS7

## 安装使用

### 单机安装

执行如下脚本:

```shell
curl -sSf https://get.dgraph.io | bash
```

### 单机运行 

需要运行三个组件,  alpha数据存储、zero集群控制和ratel UI可视化界面，运行完成之后访问[http://localhost:8000](http://localhost:8000) 查询和管理数据。 

1. 运行 alpha。

    ```shell
    # 默认8080端口
    /usr/local/bin/dgraph alpha --lru_mb 1024
    # 指定端口偏移量 10000，则是18080端口
    /usr/local/bin/dgraph alpha --lru_mb 1024 -o 10000
    ```

2. 运行 zero。

    ```shell
    /usr/local/bin/dgraph zero
    ```

3. 运行 ratel UI，完成之后访问 [http://localhost:8000](http://localhost:8000) 访问Web管理界面。

    ```shell
    # 默认 800端口
    /usr/local/bin/dgraph-ratel
    ```
