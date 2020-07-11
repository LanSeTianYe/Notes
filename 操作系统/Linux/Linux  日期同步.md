时间：2020-07-11 18:14:14

环境:

1. CentOS 7

## 日期同步

### 时区设置 

1. 查看时区

    ```shell
    date -R
    ```
2. 修改时区。编辑 `vim /etc/profile` 文件，添加一行 `export TZ="Asia/Shanghai"`，然后执行 `source /ect/profile`。

###  dsad


```shell

server cn.ntp.org.cn
server cn.pool.ntp.org
server asia.pool.ntp.org
server ntp.aliyun.com
server time.asia.apple.com
server time.cloudflare.com
# 允许上层时间服务器主动修改本机时间
restrict cn.ntp.org.cn nomodify notrap noquery
restrict cn.pool.ntp.org nomodify notrap noquery
restrict asia.pool.ntp.org nomodify notrap noquery
restrict ntp.aliyun.com nomodify notrap noquery
restrict time.asia.apple.com nomodify notrap noquery
restrict time.cloudflare.com nomodify notrap noquery

```


