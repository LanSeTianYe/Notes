时间：2024-10-09 16:49:49

参考：
1. [frp 官网](https://gofrp.org/zh-cn/)
2. [frp 代码库](https://github.com/fatedier/frp)
3. [frp 下载](https://github.com/fatedier/frp/releases)

## 内网穿透 Frp

Frp 是一个简单高效的内网穿透工具。

Frp 采用 C/S 模式，将服务端部署在具有公网 IP 的机器上，客户端部署在内网或防火墙内的机器上，通过访问暴露在服务器上的端口，反向代理到处于内网的服务。 在此基础上，Frp 支持 TCP, UDP, HTTP, HTTPS 等多种协议，提供了加密、压缩，身份认证，代理限速，负载均衡等众多能力。此外，还可以通过 xtcp 实现 P2P 通信。

### 部署安装

**第一步：** 从 https://github.com/fatedier/frp/releases 页面下载对应版本的包，然后解压到本地目录。（也可以从源代码编译）

**第二步：** 启动服务端。在服务端机器上解压下载的文件，然后进入目录，启动服务端 `./frps -c frps.toml`。

`frps.toml` 文件内容如下：

```toml
bindPort = 7000
# 认证密码是，客户端连接时使用的密码，客户端配置文件和这里的密码一致才能连上服务器
auth.token = "认证密码"

# 默认为 127.0.0.1，如果需要公网访问，需要修改为 0.0.0.0。
webServer.addr = "127.0.0.1"
webServer.port = 7500
# dashboard 用户名密码，可选，默认为空
webServer.user = "登录服务端Web管理界面的用户名"
webServer.password = "登录服务端Web管理界面的密码"
```

**第三步：** 启动客户端。在客户端机器上解压下载的文件，然后进入目录，启动客户端 `./frpc -c frpc.toml`。

`frpc.toml` 文件内容如下：

```toml
# 服务端IP
serverAddr = "服务端IP地址"
# 服务端端口
serverPort = 7000
# 服务端认证密码
auth.token = "认证密码"

# 客户端管理界面地址
webServer.addr = "127.0.0.1"
# 客户端管理界面端口
webServer.port = 7400
# 客户端管理界面用户名
webServer.user = "登录客户端Web管理界面用户名"
# 客户端管理界面用户名
webServer.password = "登录客户端Web管理界面用户名"

# 代理客户端管理界面服务
[[proxies]]
name = "admin_ui"
type = "tcp"
localPort = 7400
remotePort = 7400
```

后面需要添加代理的端口，可以直接在客户端的管理界面添加如下内容，然后点击同步即可：

```toml
[[proxies]]
name = "服务的名字"
type = "tcp"
localPort = 7400
remotePort = 7400
```

> 注：服务的名字需要唯一
