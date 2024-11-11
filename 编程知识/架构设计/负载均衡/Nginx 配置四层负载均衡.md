时间：2024-11-11 16:29:29

参考：

1. [nginx stream 配置](https://www.cnblogs.com/felixzh/p/8707102.html)

## Nginx 配置四层负载均衡

### 系统
CentOS Stream9

### 安装配置

**第一步：安装**

```shell
yum install nginx-mod-stream
```

 安装完成之后，模块会自动被引用。

 在 `/etc/nginx/nginx.conf` 文件开头处有引用安装的模块配置，默认有如下配置（如果没有需添加）。

```nginx
# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;
```

在 `/usr/share/nginx/modules/mod-stream.conf` 会添加如下内容（如果没有需手动添）

```nginx
load_module "/usr/lib64/nginx/modules/ngx_stream_module.so";
```

**第二步：配置**

**需求：**配置一个 `reids` 的代理，把本机（192.1698.0.200） `6379` 端口的流量代理到 `192.1698.0.201:6379` 和 `192.1698.0.202:6379`。

创建目录，并在目录下创建创建 `lb4.confg`，文件内容如下：

```nginx
stream {

    log_format proxy '$remote_addr [$time_local] '
                 '$protocol $status $bytes_sent $bytes_received '
                 '$session_time "$upstream_addr" '
                 '"$upstream_bytes_sent" "$upstream_bytes_received" "$upstream_connect_time"';

    # access_log 会在连接关闭的时候打印
    access_log /var/log/nginx/lb4.log proxy;
    open_log_file_cache off;

    upstream redis {
            server 192.1698.0.201:6379;
            server 192.1698.0.202:6379;
    }

    server {
            listen 6379;
            proxy_connect_timeout 3s;
            proxy_timeout 300s;
            proxy_pass redis;
    }
}
```

然后，在 `/etc/nginx/nginx.conf` 中引用该配置。

```nginx
# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;
# include lb4 config
include /root/workspace/anything/server/nginx/lb4config/*.conf;
```

然后，重新执行 `nginx -s reload` 加载nginx配置文件。
