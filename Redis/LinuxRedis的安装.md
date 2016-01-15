## Redis的安装
1. 下载安装包
2. 解压 `tar -avxf redis.3.0.5`
3. 进入到解压后的目录 `cd redis.3.0.5`
4. 安装 执行make命令
5. 把配置文件拷贝到 /etc/目录下面 `cp redis.conf /etc/`
6. 配置path，把需要运行的命令拷贝到/usr/bin/目录下  `cp redis-benchmark redis-cli redis-server /usr/bin/ `
7. 之后在命令行输入命令即可启动redis `redis-server` `redis-cli`