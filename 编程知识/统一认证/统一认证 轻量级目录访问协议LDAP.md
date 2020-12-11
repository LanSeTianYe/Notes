时间：2020-12-11 10:14:14

参考:

1. [lam ldap管理客户端](https://github.com/LDAPAccountManager/lam)
2. [LDAP 介绍](https://www.ossez.com/t/ldap/523)

## 统一认证 轻量级目录访问协议LDAP 

Lightweigth Directory Access Protocol 轻量级目录访问协议。读效率高写效率低。不支持事务。

使用目录结构存储用户数据。可以快速查询。

### 怎么使用

管理员通过管理界面增加用户信息，其他登录服务通过接口查询用户信息，比较请求资源和用户信息，从而确认用户表时候可以登录。

### 结构图


![ldap](..\..\img\ldap\ldap.png)
