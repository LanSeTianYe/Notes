时间：2020-08-27 10:15:15

环境：

1. CentOS7

参考：

1. [setup-ipsec-vpn](https://github.com/hwdsl2/setup-ipsec-vpn) 

## 使用 

### 服务器配置

1. 安装，使用脚本自动安装，[官方文档](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/README-zh.md)。

    ```shell
    wget https://git.io/vpnsetup-centos -O vpnsetup.sh && sudo sh vpnsetup.shsetup-ipsec-vpn
    ```

2. 配置密码。[官方文档](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/manage-users-zh.md)

   

       * 预共享密钥文件: `/etc/ipsec.secrets` 
       * 用户配置文件: `/etc/ppp/chap-secrets`

3. 重启服务

    ```shell
    service ipsec restart&&service xl2tpd restart
    ```

4. 卸载，[官方文档](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/uninstall-zh.md)。

### 客户端配置

具体参考官方文档 [官方文档](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients-zh.md)