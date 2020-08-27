时间：2020-08-27 18:20:20

环境：

1.  CentOS7

## 开机启动软件

使用`systemctl` 的 `enable` 可以设置开机启动软件。核心是制作一个 `software_name.service` 文件。可以参考 `/usr/lib/systemd/system` 里面的配置。

```
# 设置软件开机启动
systemctl enable software.service
```

## 文件模板

```shell
[Unit]
Description=halo
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
ExecStart=/bin/bash /home/root/software/halo/run_halo.sh
ExecReload=/bin/bash /home/root/software/halo/run_halo.sh
Restart=always

[Install]
WantedBy=multi-user.target
```



