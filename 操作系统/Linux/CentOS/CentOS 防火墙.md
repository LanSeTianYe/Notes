时间：2019/6/6 15:11:10
环境： 

1. `CentOS 7`   

参考：

1. `man firewalld`
2. `man firewall-cmd`
3. [Centos7 防火墙 firewalld 实用操作](https://www.cnblogs.com/stulzq/p/9808504.html)   
4. [firewalld防火墙详解](https://blog.51cto.com/andyxu/2137046)

## CentOS 防火墙管理      

`CentOS 7` 使用  `firewall-cmd` 进行防火墙配置管理。防火墙进程是 `firewalld`，`firewall-cmd` 用于在命令管理防火墙的运行时配置(runtime)和永久配置（permanent）。

`firewalld` 默认出口是全放开的，入口则尽量小的开放。

**Zone**: 用于表示计算机所处的区域。系统默认使用的是 `public` 区域，防火墙策略就是定义在区域上的一些流量规则。

|区域|默认规则|
|::|::|
|trusted|允许所有的数据包进出|
|home|拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh、mdns、ipp-client、amba-client与dhcpv6-client服务相关，则允许进入|
|Internal|等同于home区域|
|work|拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh、ipp-client与dhcpv6-client服务相关，则允许进入|
|public|拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh、dhcpv6-client服务相关，则允许进入|
|external|拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh服务相关，则允许|
|dmz|	拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh服务相关，则允许进入|
|block|拒绝进入的流量，除非与出去的流量相关|
|drop|拒绝进入的流量，除非与出去的流量相关|

**判断流量属于哪一个区域的过程：** 先根据 `source`（请求来源地址）判断属于哪一个区域，找不到则使用 `Interface`(访问的哪一个网卡) 判断属于哪一个区域，找不到则使用默认区域。然后使用区域的流量过滤规则。

### 启动或关闭防火墙    
* 打开防火墙 ：`systemctl start firewalld`
* 停止防火墙 ：`systemctl stop firewalld`
* 重启防火墙 ：`systemctl restart firewalld`

### 防火墙配置和管理 `firewall-cmd`  

#### 基础操作  
1. `--state`：查看状态。  
2. `--version`：查看版本。    
3. `--list-all`：查看防火墙配置。  
4. `--permanent`：表示设置永久配置，需要重启防火墙生效。不指定表示设定运行时配置。
4. `--reload`： 重新加载规则。  
5. `--get-zones`：显示可用的区域。
6. `--get-services`：显示预定义的服务。
5. `--runtime-to-permanent`：把运行时配置转换为永久配置。
6. `--get-log-denied`：查看决绝日志级别。
7. `--set-log-denied=value`：设置拒绝日志级别，设置之后对应级别的拒绝日志会被记录，默认值 `off`。 `all` `unicast` 单播 `broadcast` 广播 `multicast` 组播 and `off`
5. 紧急选项（打开之后拒绝接收所有数据包）。  

		--panic-on
		--panic-off  
		--query-panic  
### 管理防火请进出规则-简要配置  

注：不指定区域的情况下，规则都定义在默认区域上，如果需要指定区域则在命令中添加 `--zone=zone_name` 即可。
  
1. 开放端口。

		#添加端口/协议（TCP/UDP）
		firewall-cmd --add-port=<port>/<protocol> 
		#移除端口/协议（TCP/UDP）
		firewall-cmd --remove-port=<port>/<protocol> 
		#查看开放的端口
		firewall-cmd --list-ports

2. 开放服务。
			
		# 添加服务
		firewall-cmd --add-service=<service name>
		# 删除服务 
		firewall-cmd --remove-service=<service name>
		# 查看允许的服务  
		firewall-cmd --list-services
3. 开放协议。	  

		# 允许协议 (例：icmp，即允许ping)
		firewall-cmd --add-protocol=<protocol> 
		# 取消协议
		firewall-cmd --remove-protocol=<protocol>
		# 查看允许的协议 
		firewall-cmd --list-protocols 
 
### 管理防火墙进出规则-详细配置    

注：不指定区域的情况下，规则都定义在默认区域上，如果需要指定区域则在命令中添加 `--zone=zone_name` 即可。

2. 允许指定IP的所有流量。  

		firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="192.168.30.66" accept"

3. 允许指定IP、通过指定协议的所有流量。 

		firewall-cmd --add-rich-rule="rule family="ipv4" source address="192.168.30.67" protocol value="tcp" accept"

4. 允许指定IP地址、使用指定协议，访问指定端口的流量。

		firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="172.17.0.4" port protocol="tcp" port="3306" accept"  
5. 允许指定IP地址、访问指定服务。

		firewall-cmd --add-rich-rule="rule family="ipv4" source address="<ip>" service name="<service name>" accept"

6. 允许指定IP段、使用指定协议、访问指定端口的流量。根据子网掩码的长度计算IP段 `192.168.0.1 ~ 192.168.0.255`

		firewall-cmd --add-rich-rule="rule family="ipv4" source address="192.168.0.0/24" port protocol="tcp" port="22" accept"

7. 禁止访问。  

		firewall-cmd --add-rich-rule="rule family="ipv4" source address="192.168.0.0/24" port protocol="tcp" port="22" reject"
		firewall-cmd --add-rich-rule="rule family="ipv4" source address="192.168.0.0/24" port protocol="tcp" port="22" drop"