时间：2020-09-11 15:22:22

参考：

1.  [https://dgraph.io/downloads#download-linux](https://dgraph.io/downloads#download-linux)

## 安装使用

### 单机安装

执行如下脚本:

```shell
curl -sSf https://get.dgraph.io | bash
```

### 单机运行 

需要运行三个组件，运行完成之后访问Web即可查询和管理数据。

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

4. 数据导入，需要先定义好数据结构。

    ```
    dgraph live -f 1million.rdf.gz --alpha localhost:offset+9080 --zero localhost:5080 -c 1
    ```