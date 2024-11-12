时间: 2020-07-10 14:13:13

环境: 

1. CentOS 7

参考：

1.  [Keepalived](https://github.com/acassen/keepalived)
2.  [Using Keepalived for managing simple failover in clusters](https://www.redhat.com/sysadmin/ha-cluster-linux)
3.  [Setting up a Linux cluster with Keepalived: Basic configuration](https://www.redhat.com/sysadmin/keepalived-basics)
4.  [基于 LVS + Keepalived 搭建负载均衡](https://dudashuang.com/load-blance/)

# Keepalived

## Keepalived 简介

### 一段话介绍 

小田要部署一个blog网站，他有两台服务器服务器A和服务器B，要求当服务器Ａ故障的时候服务器Ｂ可以替代服务器Ａ提供服务。服务器A的IP地址是  `192.168.0.201`，服务器B的IP地址是 `192.168.0.202`。小田有一个多余的 IP `192.168.0.203`。

解决方案一：假设服务器A和服务器B都是公网IP，当服务器A故障的时候把域名对应的DNS解析到服务器B即可。（基于DNS解析的解决方案）。缺点：DNS解析，而且需要手动变更配置，有一定的时间延迟。

解决方案二：虚拟路由器冗余协议 `VRRP(irtual Router Redundancy Protocol)`，一个网卡可以绑定多个IP地址，当服务器A正常的时候把 `192.168.0.203` 绑定到服务器A的网卡上，当服务器A故障的时候把 `192.168.0.203` 绑定到服务器B的网卡上。我们请求blog网站的时候访问 `192.168.0.203`，至于IP地址自动切换绑定不同主机就是 Keepalived 所作的事情。

Keepalived是一个维护Linux 架构的服务器负载均衡和高可用的简单并且健壮的工具。监控机器的状态，当机器故障的时候把虚拟IP绑定到正常状态的机器上，由于我们使用的IP是虚拟IP，当机器故障的时候，Keepalived把虚拟IP绑定到正常的机器上，我们的服务器仍然可用。

## Keepalived 使用 

### 安装配置 

1. 安装

    ```shell 
    yum install -y keepalived
    ```
    
2. 服务器A的配置

    ```shell
    ! Configuration File for keepalived

    global_defs {
       router_id 201
    }

    vrrp_instance VI_1 {
        state MASTER
        interface ens33
        mcast_src_ip 192.168.0.201
        virtual_router_id 51
        priority 100
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.0.203
        }
    }
    ```
    
3. 服务器B的配置

    ```shell
    ! Configuration File for keepalived

    global_defs {
       router_id 202
    }

    vrrp_instance VI_1 {
        state BACKUP
        interface ens33
        virtual_router_id 51
        mcast_src_ip 192.168.0.202
        priority 90
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.0.203
        }
    }
    ```

3. 查看效果。
    * 在服务器A和服务器B上分别启动 keepalived。此时虚拟IP应该绑定在服务器A上。
    * 停止服务器A的keepalived，此时虚拟IP应该绑定在服务器B上。
    * 重启服务器A的keepalived ，此时虚拟IP应该绑定在服务器A上。

    ```shell
    # 启动
    systemctl start keepalived
    # 停止
    systemctl stop keepalived
    # 查看虚拟IP绑定信息
    ip a
    ```

注：配置参数含义

* router_id：机器标识ID，不同服务器配置不同。
* state：状态。 `MASTER` 表示主机，`BACKUP` 表示备份机，当 `MASTER` 存活的时候 虚拟IP始终会绑定到 `MASTER` 上。
* interface：绑定的网卡名字，可以通过 `ip a`查看。
* virtual_router_id：虚拟路由Id，服务器A和服务器B需要配置相同的值。
* mcast_src_ip：当前机器IP。
* priority：优先级，数越大优先级越高，不同的机器需要配置不同的优先级。
* advert_int：广播间隔，单位秒。
* auth_type：认证类型。
* auth_pass：认证密码。
* virtual_ipaddress：虚拟IP地址。
