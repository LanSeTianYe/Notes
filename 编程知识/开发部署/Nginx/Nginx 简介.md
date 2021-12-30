时间：2021-12-27 16:04:04

参考:

1. [websocket](https://www.cnblogs.com/niuben/p/14607999.html)

## Nginx 简介

### Nginx 命令

停止、结束、重新加载配置文件。

```nginx
nginx -s stop   # fast shutdown
nginx -s quit   # graceful shutdown
nginx -s reload # reloading the configuration file
nginx -s reopen # reopening the log files
```

### Nginx 转发 websocket 头

**错误：nginx 没有转发websocket upgrade 头**

```nginx
websocket: the client is not using the websocket protocol: 'upgrade' token not found in 'Connection' head
```

**解决方案：**

```nginx
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection upgrade
```

#### 配置模板

```nginx
server {
    listen       80;
    server_name  ide.chainmaker.org.cn;

    access_log  /var/log/nginx/host.access.log  main;

    location / {
        proxy_pass http://172.21.0.15:7070;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection upgrade;
    }

    location ^~ /doc/ {
        alias /data/work/IDE/docs/site/;
        index index.html;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
```

### 配置模式

```nginx
# 以.git .jpg .png 结尾的文件
# ~ 表示后面的内容为正则表达式
location ~ \.(gif|jpg|png)$ {
    root /data/images;
}

# 代理到其它服务，支持WebSocker
location / {
    proxy_pass http://172.21.0.15:7070;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection upgrade;
}

# 负载均衡配置，不指定策略默认用轮询策略
http {
    # 定义一组服务
    upstream backend {
        # 提供服务服务器
        server backend1.example.com weight=5;
        server backend2.example.com;
        # 备用服务器,其它两个不可用时启动
        server 192.0.0.1 backup;
    }
    
    # 负载均衡到一组服务
    server {
        location / {
            proxy_pass http://backend;
        }
    }
}
# 负载均衡方法：
# 轮询：流量均匀分布到每一台机器
# 最少连接 least_conn: 优先转发到连接数最少的机器
# IP哈希 ip_hash: 根据IP的哈希进行转发
upstream backend {
    server backend1.example.com;
    server backend2.example.com;
    # 临时停用一台机器
    server backend3.example.com down;
}
# 通用哈希：consistent 一致性哈希（哈希环）
upstream backend {
    hash $request_uri consistent;
    server backend1.example.com;
    server backend2.example.com;
}
# 慢启动
upstream backend {
    server backend1.example.com slow_start=30s;
    server backend2.example.com;
    server 192.0.0.1 backup;
}
# DNS 负载均衡，定期请求服务器解析IP地址
http {
    # DNS 服务器
    resolver 10.0.0.1 valid=300s ipv6=off;
    resolver_timeout 10s;
    server {
        location / {
            proxy_pass http://backend;
        }
    }
    upstream backend {
        zone backend 32k;
        least_conn;
        # 解析的地址列表
        server backend1.example.com resolve;
        server backend2.example.com resolve;
    }
}
# TCP UDP 负载均衡
stream {
    upstream stream_backend {
        least_conn;
        server backend1.example.com:12345 weight=5;
        server backend2.example.com:12345 max_fails=2 fail_timeout=30s;
        server backend3.example.com:12345 max_conns=3;
    }
    
    upstream dns_servers {
        least_conn;
        server 192.168.136.130:53;
        server 192.168.136.131:53;
        server 192.168.136.132:53;
    }
    
    server {
        listen        12345;
        proxy_pass    stream_backend;
        proxy_timeout 3s;
        proxy_connect_timeout 1s;
    }
    
    server {
        listen     53 udp;
        proxy_pass dns_servers;
    }
    
    server {
        listen     12346;
        proxy_pass backend4.example.com:12346;
    }
}
```
