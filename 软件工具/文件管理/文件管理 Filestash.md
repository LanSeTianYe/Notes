时间：2024-10-09 17:28:28

参考：

1. [Filestash 官网](https://www.filestash.app/)
2. [https://github.com/mickael-kerjean/filestash](https://github.com/mickael-kerjean/filestash)



## Filestash

Filestash 是一个在线Web文件管理系统，可以连接多种文件系统：如 S3、SFTP、FTP、FTPS、Minio、Mysql等。可以查看文本、图片、视频、word、excel、ppt 等类型的文件。

### 安装-Docker

```shell
# 创建目录
mkdir filestash && cd filestash && touch docker-compose.yml
# 把下面内容添加到 docker-compose.yml 文件后启动服务
docker-compose up -d
```

`docker-compose.yml` 内容如下:

```dockerfile
version: '2'
services:
  app:
    container_name: filestash
    image: machines/filestash
    restart: always
    environment:
      - APPLICATION_URL=
      - GDRIVE_CLIENT_ID=<gdrive_client>
      - GDRIVE_CLIENT_SECRET=<gdrive_secret>
      - DROPBOX_CLIENT_ID=<dropbox_key>
      - ONLYOFFICE_URL=http://onlyoffice
    ports:
      - "8334:8334"
    volumes:
      - filestash:/app/data/state/

  onlyoffice:
    container_name: filestash_oods
    image: onlyoffice/documentserver:8.0.1
    restart: always
    environment:
      JWT_ENABLED: "false"

volumes:
    filestash: {}
```



启动完成之后，通过 http://127.0.0.1:8334 访问服务。

### 问题

**问题1：** 如果用 nginx 代理服务，需要加如下Header。

```nginx
# 在 nginx.config 的 http 模块里面加入如下内容
map $time_iso8601 $logdate {
  '~^(?<ymd>\d{4}-\d{2}-\d{2})' $ymd;
  default                       'date-not-found';
}

map $http_host $this_host {
  "" $host;
  default $http_host;
}

map $http_x_forwarded_proto $the_scheme {
  default $http_x_forwarded_proto;
  "" $scheme;
}

map $http_x_forwarded_host $the_host {
  default $http_x_forwarded_host;
  "" $this_host;
}

map $http_upgrade $proxy_connection {
  default upgrade;
  "" close;
}

proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection $proxy_connection;
proxy_set_header X-Forwarded-Host $the_host;
proxy_set_header X-Forwarded-Proto $the_scheme;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;


# 在 server 的 location 模块下加入如下内容
proxy_set_header Host $http_host;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection $proxy_connection;
proxy_set_header X-Forwarded-Host $the_host;
proxy_set_header X-Forwarded-Proto $the_scheme;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_http_version 1.1;
```

**问题2：** 请求资源限制。

需要修改 onlyoffice 容器里面的配置文件，然后重启服务。

```dockerfile
# 复制容器内的文件到本地
docker cp f94931fd7b3a:/etc/onlyoffice/documentserver/default.json ./

# 编辑如下内容
"request-filtering-agent" : {
  "allowPrivateIPAddress": true,
  "allowMetaIPAddress": true
},

# 复制到容器内
docker cp ./default.json f94931fd7b3a:/etc/onlyoffice/documentserver/default.json
```





