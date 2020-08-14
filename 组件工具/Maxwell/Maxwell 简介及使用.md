时间： 2020-08-14 11:38:38

参考：

1. [Maxwell 官网](http://maxwells-daemon.io/)

## Maxwell 简介及使用 

### 是什么 

Maxwell 是一个读取 `MySQL binlog`，把行数据变更以 `JSON` 格式发送到 `Redis` 、`Kafka`、`RabbitMQ`  等平台的工具。

### 怎么用

#### 监听 binlog 

Maxwell 会把监听binlog，读取数据变更。

```shell
bin/maxwell --config config_stream.properties --client_id maxwell_stream --replica_server_id 6382
```

#### 主动读取数据

1. 通过命令执行读取数据操作。

    ```shell
    # 客户端id为maxwell_stream的客户端读取数据库test的person表的数据
    bin/maxwell-bootstrap --client_id maxwell_stream --database test --table person
    # 客户端id为maxwell_stream的客户端读取数据库test的person表的id大于1的数据
    bin/maxwell-bootstrap --client_id maxwell_stream --database test --table person --where "id > 10" 
    ```
2. 通过执行SQL读取数据

    ```shell
    # 客户端id为maxwell_stream的客户端读取数据库test的person表的数据
    insert into maxwell.bootstrap (database_name, table_name, client_id) values ('test', 'person', 'maxwell_stream');
    # 客户端id为maxwell_stream的客户端读取数据库test的person表的数据，指定开始执行时间
    insert into maxwell.bootstrap (database_name, table_name, client_id, started_at) values ('test', 'person', 'maxwell_stream', '2020-08-08 12:30:00');
    ```

### 数据格式

|字段|含义|
|::|::|
|database|数据库|
|table   |表|
|type|类型 insert、update、delete、bootstrap-start、bootstrap-insert和bootstrap-complete|
|ts|时间戳|
|xid|InnoDB 事务ID|
|commit|是否已经提交|
|data|变更之后的数据|
|old|变更之前的旧数据|

#### 数据变更消息

**插入数据消息**

```json
{"database":"test","table":"person","type":"insert","ts":1596612213,"xid":19174,"commit":true,"data":{"id":11154,"create_time":"2020-08-05 15:23:11.000000","name":"11"}}

```

**更新数据消息**

```json
{"database":"test","table":"person","type":"update","ts":1596612517,"xid":19952,"commit":true,"data":{"id":11154,"create_time":"2020-08-05 15:23:11.000000","name":"22"},"old":{"name":"11"}}
```

**删除数据消息**

```json
{"database":"test","table":"person","type":"delete","ts":1596612554,"xid":20066,"commit":true,"data":{"id":11154,"create_time":"2020-08-05 15:23:11.000000","name":"22"}}
```

#### bootstrap 消息

**bootstrap 开始**

```json
message -> {"database":"test","table":"person","type":"bootstrap-start","ts":1597378133,"data":{}}
```

**bootstrap 数据**

```json
{"database":"test","table":"person","type":"bootstrap-insert","ts":1597377821,"data":{"id":11149,"create_time":"2020-07-23 04:35:14.000000","name":"149"}}
```

**bootstrap 完成**

```json
message -> {"database":"test","table":"person","type":"bootstrap-complete","ts":1597378133,"data":{}}
```
