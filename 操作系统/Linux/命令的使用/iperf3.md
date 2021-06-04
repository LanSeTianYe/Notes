时间：2021-06-04 10:16:16

参考：

1. [CentOS/RHEL Linux安装EPEL第三方软件源](https://www.vpser.net/manage/centos-rhel-linux-third-party-source-epel.html)


## iperf3

安装第三方源： `yum install epel-release`

安装iperf3：`yum install iperf3`

### 接收端

1. 启动服务，指定端口。`-s`表示服务器，`-p` 指定端口。

    ```
    iperf3 -s -p 11301
    ```

### 发送端

1.  启动客户端向服务端发送数据，`-c 172.16.1.94` 指定ip， `-p` 指定端口，`-u` 表示udp，`-b` 表示网卡带宽， `-n` 表示发送的数据，`-l` 表示缓冲大小。

    ```
    iperf3 -c 172.16.1.94 -p 11301 -u -b 10000m -n 100G -l 65507
    ```