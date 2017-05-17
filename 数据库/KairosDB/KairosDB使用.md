下载地址 : [kairosdb-1.1.1-1](http://pan.baidu.com/s/1hstYDUG)
****
## 安装

### ubuntu安装  
1. 解压之后，在bin目录里面运行 `./kairosdb.sh run` 即可启动。
### windows安装
2. 解压之后, cmd命令行切换到bin目录下面，执行 `./kairosdb.bat run` 即可启动。

## 配置 `cassandra` 存储.
1. 选用 `cassandrs`， 修改 `kairosdb` 的配置文件`kairosdb.properties`

    
        #kairosdb.service.datastore=org.kairosdb.datastore.h2.H2Module
        kairosdb.datastore.concurrentQueryThreads=5
        kairosdb.service.datastore=org.kairosdb.datastore.cassandra.CassandraModule
        #kairosdb.service.datastore=org.kairosdb.datastore.remote.RemoteModule
        
        #this module is built using the code at https://github.com/brianhks/opentsdb
        #kairosdb.service.datastore=net.opentsdb.kairosdb.HBaseModule

2. 修改 `cassandra` 的配置文件 `conf/cassandra.yaml`,修改下面三项内容.

        start_rpc: true
        rpc_address: localhost
        rpc_port: 9160