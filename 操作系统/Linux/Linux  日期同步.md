时间：2020-07-11 18:14:14

参考：

1. [网络时间协议](https://zh.wikipedia.org/wiki/%E7%B6%B2%E8%B7%AF%E6%99%82%E9%96%93%E5%8D%94%E5%AE%9A)
2. [rfc5905(NTP-v4)](https://tools.ietf.org/pdf/rfc5905.pdf)
3. [NTP 协议简单分析](https://blog.srefan.com/2017/07/ntp-protocol/)
4. [NTP服务的安装、配置和使用 ](http://blog.sina.com.cn/s/blog_605fc9b20100r17u.html)
5. [CentOS7 日期时间设置](https://www.jianshu.com/p/6c03ec89bda0)

环境:

1. CentOS 7

名词解释：

* 硬件时间：时间写入到 BIOS 中，由主板电池供电，当系统关机之后时间也会一直走下去。
* 系统时间：开机时从BOIS读取时间，开机之后一直走下去直到关机。

注：文档里面的授时服务器不可用时，可以在网上搜索可用的授时服务器，然后通过 `ntpdate 0.cn.pool.ntp.org`  验证服务器是否可用。
注：同步时间命令 `ntpdate -u cn.pool.ntp.org`

## NTP 时间同步

在各服务器或集群中的不同机器之间需要保持时间一致以及时间的精确性（和实际时间相同），以避免因为时间不一致导致的各种问题。

小田有三台服务器，`服务器A(192.168.0.201)`、`服务器B(192.168.0.202)`和`服务器C(192.168.0.202)`。需要三台服务器之间保持时间一致，以及保持时间精确。

`服务器A`从标准授时服务器同步时间（对表）以保证自己时间的精确性。同时做为授时服务器向`服务器B`和`服务器C`提供授时服务。`服务器B`和`服务器C`从授时`服务器A`同步时间以保证服务器之间时间的的一致性。

`服务器A`从标准授时服务器获取时间，保证时间的精确性。`服务器B`和`服务器C`都从`服务器A`同步时间，保证各服务器之间时间的一致性。

NTP (Network Time Protocol) 网络时间协议是用于服务器（计算机）之间时间同步的协议。在 CentOS 下有对应的软件可以通过 `yum install ntp` 安装，安装之后修改配置即可使用。 

### NTP 简介  

网络时间同步协议，基于UDP协议实现，端口号 123。 同步时间的过程是渐进式的，比如两个计算机之间从相差10秒到时间同步可能经历很长的时间，这样可以避免时间跳跃产生的穿越问题，因此启动服务之前需要先进行一次手动的时间同步。

### NTP 安装和使用 

`服务器A`作为授时服务器，`服务器B`和`服务器C`从`服务器A`同步时间。

1. 修改时区以及设置时间。

    ```shell
    # 查看时间及时区信息
     [root@test etc]# timedatectl
          Local time: Sun 2020-07-12 17:38:16 CST  系统时间
      Universal time: Sun 2020-07-12 09:38:16 UTC  UTC时间
            RTC time: Sun 2020-07-12 09:40:40      硬件时间
           Time zone: Asia/Chongqing (CST, +0800)  时区
         NTP enabled: no                           ntp 服务是否开启
    NTP synchronized: no                           ntp 时间是否同步
     RTC in local TZ: no                           硬件时间是否和本地时间时区相同
          DST active: n/a
    # 修改时区
    [root@test etc]# timedatectl set-timezone Asia/Shanghai
    # 设置本地时间
    [root@test etc]# timedatectl set-time "2020-07-12 17:45:45"
    ```

2. 安装 ntp

    ```shell
    yum install ntp
    ```

3. 修改配置文件 `/etc/ntf.conf`。

    * 修改服务器A的配置文件，只列出注释和修改的内容。

        ```shell
        # Hosts on local network are less restricted.
        # 允许本地局域网内服务器和服务器A通信
        # ignore 关闭所有联网服务 nomodify 不能修改 notrust 如果认证不通过则为不可信 noquery 不提供时间查询
        restrict 192.168.0.0 mask 255.255.255.0 nomodify notrap
        # 限制上层服务器的权限
        restrict 0.cn.pool.ntp.org nomodify notrap noquery
        restrict 1.cn.pool.ntp.org nomodify notrap noquery
        restrict 2.cn.pool.ntp.org nomodify notrap noquery
        restrict 3.cn.pool.ntp.org nomodify notrap noquery
        
        # Use public servers from the pool.ntp.org project.
        # 授时中心服务器地址
        server 0.cn.pool.ntp.org
        server 1.cn.pool.ntp.org
        server 2.cn.pool.ntp.org
        server 3.cn.pool.ntp.org
        
        # 授时中心不可用时使用本机时间
        server  127.127.1.0
        fudge   127.127.1.0 stratum 10
        
        # 同步时间后同步硬件时间(在最后一行添加)
        SYNC_HWCLOCK=yes 
        ```
        
    * 修改服务器B和服务器C的配置文件。

        ```shell        
        # Hosts on local network are less restricted.
        restrict 192.168.0.201 nomodify notrap noquery
        # Use public servers from the pool.ntp.org project.
        # 授时中心服务器地址
        server 192.168.0.201
        
        # 授时中心不可用时使用本机时间
        server  127.127.1.0
        fudge   127.127.1.0 stratum 10
        
        # 同步时间后同步硬件时间(在最后一行添加)
        SYNC_HWCLOCK=yes 
        ```

3. 启动服务。

    * 第一步，先同步服务器A的时间，然后启动服务器A的 `ntp` 服务。

        ```shell
        # 方法1 手动设置
        timedatectl set-time "2020-07-12 17:45:45"
        # 方法2 从服务器更新
        ntpdate 0.cn.pool.ntp.org
        # 启动服务
        systemctl start ntpd
        # 查看状态
        systemctl status ntpd
        # 设置服务开机启动
        systemctl enable ntpd
        ```
    *  第二步，在服务器B和服务器C上同步时间，然后启动服务。

        ```shell
        # 方法1 手动设置
        ntpdate 192.168.0.201
        # 方法2 从服务器更新
        timedatectl set-time "2020-07-12 17:45:45"
        # 启动服务
        systemctl start ntpd
        # 查看状态
        systemctl status ntpd
        # 设置服务开机启动
        systemctl enable ntpd
        ```

    * ntp 状态查看

        ```shell
        # 查看同步服务器信息，前面有 * 的表示最精确的服务器。
        ntpq -p
        # 查看当前同步的状态，服务刚启动的一段时间一致是从本地同步，启动一段时间之后才从服务器同步。
        ntpstat
        # 输出信息如下
        synchronised to NTP server (203.107.6.88) at stratum 3
           time correct to within 56 ms
           polling server every 1024 s
        ```

