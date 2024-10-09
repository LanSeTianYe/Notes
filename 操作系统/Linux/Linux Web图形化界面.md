时间：2024-10-09 16:28:45

参考：

1. [Cockpit 官网](https://cockpit-project.org/)
2. [安装和运行](https://cockpit-project.org/running.html)
3. [支持的应用程序](https://cockpit-project.org/applications.html)

## Cockpit

Cockpit 是给服务器提供的 Web 图形化界面。可以通过浏览器管理服务器。

提供如下功能：

* 性能监控。
* 网络管理。
* 软件管理。
* 终端登录。
* ... ...

### 安装

以 Centos 为例

```shell
# 安装
sudo yum install cockpit
# 开机启动
sudo systemctl enable --now cockpit.socket
# 开放防火墙（非必需，如果防火墙是关闭的则不需要该步骤）
sudo firewall-cmd --permanent --zone=public --add-service=cockpit
sudo firewall-cmd --reload
```

安装完成之后访问  https://localhost:9090

