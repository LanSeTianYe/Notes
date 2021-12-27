时间：2021-12-27 16:04:04

参考:

1. [websocket](https://www.cnblogs.com/niuben/p/14607999.html)

## Nginx 配置使用

### Nginx 转发 websocket 头

**错误：nginx 没有转发websocket upgrade 头**

```shell
websocket: the client is not using the websocket protocol: 'upgrade' token not found in 'Connection' head
```

**解决方案：**

```shell
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection upgrade
```

#### 配置模板

```shell
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
