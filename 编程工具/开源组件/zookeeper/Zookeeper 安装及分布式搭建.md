## 文档信息

创建日期：2016-08-22 17:08:40 

## 系统环境

1. win10 64位
2. ubuntu 10.14 64位虚拟机
3. windows jdk1.8/linux jdk1.7
4. windows防火墙关闭

## 单独一个安装(window)

1. [下载](http://zookeeper.apache.org/releases.html) zookeeper，并解压。（我用的 [zookeeper-3.5.2](http://apache.org/dist/zookeeper/) ）。

2. 创建配置文件，在 `conf` 目录下创建 `zoo.cfg`，添加如下内容，`dataDir=D:\\zookeeper` 数据存放的位置，根据自己的需要修改。

    ```
    # The number of milliseconds of each tick
    tickTime=2000
    # The number of ticks that the initial 
    # synchronization phase can take
    initLimit=10
    # The number of ticks that can pass between 
    # sending a request and getting an acknowledgement
    syncLimit=5
    # the directory where the snapshot is stored.
    # do not use /tmp for storage, /tmp here is just 
    # example sakes.
    dataDir=D:\\zookeeper
    # the port at which the clients will connect
    clientPort=2181
    # the maximum number of client connections.
    # increase this if you need to handle more clients
    #maxClientCnxns=60
    #
    # Be sure to read the maintenance section of the 
    # administrator guide before turning on autopurge.
    #
    # http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
    #
    # The number of snapshots to retain in dataDir
    #autopurge.snapRetainCount=3
    # Purge task interval in hours
    # Set to "0" to disable auto purge feature
    #autopurge.purgeInterval=1
    ```

3. 启动，进入 `bin` 目录，双击 `zkServer.cmd`即可。也可以在命令行运行。

## 集群安装

windows安装一个，Linux虚拟机安装一个，这里没有遵从 `2n+1` 的规则。

### windows配置

1. 修改配置文件。

    ```
    # The number of milliseconds of each tick
    tickTime=2000
    # The number of ticks that the initial 
    # synchronization phase can take
    initLimit=5
    # The number of ticks that can pass between 
    # sending a request and getting an acknowledgement
    syncLimit=2
    # 数据存放目录
    dataDir=D:\zookeeper
    # the port at which the clients will connect
    clientPort=2181
    # the maximum number of client connections.
    # increase this if you need to handle more clients
    #maxClientCnxns=60
    #
    # Be sure to read the maintenance section of the 
    # administrator guide before turning on autopurge.
    #
    # http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
    #
    # The number of snapshots to retain in dataDir
    #autopurge.snapRetainCount=3
    # Purge task interval in hours
    # Set to "0" to disable auto purge feature
    #autopurge.purgeInterval=1

    # zookeeper服务列表，集群里每一个zookeeper的列表配置都要相同。第一个是本机，第二个是linux虚拟机
    server.1=192.168.1.66:2888:3888
    server.2=192.168.37.128:2888:3888
    ```

2. 指定 `zookeeper` 的id。
在 `数据存放目录` 创建 `myid` 文件，文件内容为当前zookeeper的id（自己指定，必须为整数），要和配置文件里面的 `server.X` 的 X `对应`。这里是 `1`。

3. 启动项目，双击运行。

### Linux配置

1. 复制 `windows` 上的文件到虚拟机。

2. 修改配置文件，只需修改配置文件中的数据存放目录即可。

    ```
    ## 我的位置
    dataDir=\home\用户名\zookeeper
    ```

3. 指定 `zookeeper` 的id。
在 `数据存放目录` 创建 `myid` 文件，文件内容为当前zookeeper的id（自己指定，必须为整数），要和配置文件里面的 `server.X` 的 X `对应`。这里是 `2`

4. 启动项目 `zkServer.sh start`