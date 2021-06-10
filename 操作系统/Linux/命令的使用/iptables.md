时间：2021-06-09 19:58:58

参考：

1. [iptables 使用方式整理](https://blog.konghy.cn/2019/07/21/iptables/)

## iptables

iptables规则按照先后顺序一次执行，配置的时候注意规则的配置顺序，前面的规则匹配之后，后面面的规则就不会匹配。

### 常用示例

1. 查看默认链配置规则。

    ```
    iptables -L
    ```
    
1. 清空所有规则

    ```
    iptables -L
    ```

1. 开放端口

    ```
    iptables -I INPUT -p udp --dport 11301 -j ACCEPT && iptables -I INPUT -p udp --dport 12301 -j ACCEPT
    ```
    
2. 默认丢弃所有输入流量。

    ```
    iptables -P INPUT DROP
    ```
3. 在最前面添加规则,允许ping命令。

    ```
    iptables -I INPUT -p icmp -j ACCEPT
    ```

4. 允许指定网段访问22端口。

    ```
    # 允许
    iptables -I INPUT -s 192.168.10.0/24 -p tcp --dport 22 -j ACCEPT
    # 拒绝
    iptables -I INPUT -p tcp --dport 22 -j REJECT
    ```
    
5. 拒绝访问指定端口。

    ```
    iptables -I INPUT -p udp --dport 8080 -j REJECT
    iptables -I INPUT -p tcp --dport 8080 -j REJECT
    ```
    
6. 拒绝主机访问指定端口。

    ```
    iptables -I INPUT -p tcp -s 192.168.10.2 --dport 80 -j REJECT
    ```
    
7. 拒绝访问端口。

    ```
    iptables -I INPUT -p tcp --dport 1000:2000 -j REJECT
    iptables -I INPUT -p udp --dport 1000:2000 -j REJECT
    ```

8. 保存配置到文件。

    ```
    service iptables save
    ```

