时间：2024-02-28 17:41:41

参考：

1. [certbot 使用说明](https://certbot.eff.org/instructions?ws=nginx&os=centosrhel7&tab=standard)
2. [Installing snap on CentOS](https://snapcraft.io/docs/installing-snap-on-centos)

环境：

* Centos7

## Certbot 安装

### 简介

Certbot 会根据 Web 服务器的配置文件自动生成 HTTPS 证书，自动续期证书。

注：如果执行 certbot 没有反应，可能是 snapd 服务挂掉了，重启即可。

```
# 查看服务状态
systemctl status snapd.service
# 重启服务
systemctl restart snapd.service
```

### 第一步 安装 snapd

```
# 添加 epel 仓库
sudo yum install epel-release
# 安装 snapd
sudo yum install snapd
# 添加通信 socket
sudo systemctl enable --now snapd.socket
# 命令行支持
sudo ln -s /var/lib/snapd/snap /snap
```
### 第二步 删除用系统命令安装的 Certbot

```
sudo yum remove certbot
```

### 第三步 安装 Certbot

安装过程中需要在命令行 输入 邮箱，选择域名等。

```
# 安装
sudo snap install --classic certbot
# 命令行支持
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

### 第四步 运行 Certbot

运行之后会根据nginx配置文件里面的域名自动生成证书。

nginx 配置：

```
server {
    gzip on;
    gzip_buffers 4 16k;
    gzip_comp_level 6;
    gzip_vary on;
    gzip_types text/plain text/css application/json application/x-javascript text/xml  application/xml application/xml+rss text/javascript;

    listen       80;
    server_name  www.sunfeilong.com;

    access_log /var/log/nginx/www_sunfeilong_com_$logdate.log main;

    location / {
        proxy_pass http://127.0.0.1:7860;
        proxy_set_header Host $http_host;
        add_header Cache-Control "public, max-age=36000";
    }
}
```

**自动生成**：只需配置80端口，certbot 会自动生成 443 的配置

```shell
sudo certbot --nginx
```

**手动生成**：生成之后手动修改配置文件，以后不需要手动修改配置文件

```shell
sudo certbot certonly --nginx
```

配置如下：

```

server {
    listen   443 ssl;
    server_name  note.sunfeilong.com; #根据这里生成证书
    
    # ssl    on;
    ssl_certificate /etc/letsencrypt/live/note.sunfeilong.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/note.sunfeilong.com/privkey.pem; # managed by Certbot
    
    //....
}
```

### 第五步 测试自动续期


```
sudo certbot renew --dry-run
```

查看定时任务，里面有 certbot

```
systemctl list-timers
```

输出如下:

```
NEXT                         LEFT     LAST     PASSED        UNIT                        ACTIVATES
Thu 2024-02-29 11:49:00 CST  18h left  n/a      n/a     snap.certbot.renew.timer     snap.certbot.renew.service
```

### 第六步 验证网址是否支持 HTTPS

用 HTTPS 的方式访问网址，查看是否有证书 `https://yourwebsite.com`。

