## 快照的方式持久话数据，保存到dump.rdp文件中
* `save seconds change` 用于配置redis服务器将数据持久化的时间。

* 默认参数如下：
        save 900 1 
        save 300 10
        save 60 100000
* 快照文件的生成过程
	1. Redis使用fork函数复制一份当前进程（父进程）的副本（子进程）。
	2. 父进程继续接收并处理客户端发来的命令，而子进程开始将内存中的数据写入硬盘上的临时文件中。
	3. 当子进程写入完所有的数据时，会用新的文件替换旧的快照文件。
	注:当子进程再写入的过程中，有新的操作改变了数据库的内容，操作系统会将改变的那一片数据复制一份，所以快照里面的信息，就是执行快照那一刻的数据。
* 另外save(主)和bgsave(子)命令也可以执行快照命令.
* 可以通过 dir(默认 dir ./) dbfilename(默认dump.rdb) 配置保存文件的目录和名字。

## AOF(append only file) 方式持久话数据
* 开启方式 配置文件中  `appendonly yes`
* 保存的文件名字  `appendfilename appendonly.aof`
* 开启之后 每一条回改变redis中的数据的命令都会被追加到文件中。
* 重写AOF文件，来缩小文件的大小，删除一下写无用的命令。
        auto-aof-rewrite-percentage 10 //当前文件超过上次重写文件大小的百分之多少
        auto-aof-rewrite-size  64mb    //限制重写文件的最小大小
* `bgrewriteaof` 手动重写,不会受上面两个参数的影响。
* `appendfsync ` no 系统默认30s always每次  everysec每秒

## Redis 主从服务器的配置 （数据复制）
* 主数据库master  从数据库 slave
* 从数据库一般是只读的，主数据库可以有多个从数据库，从数据库只能又一个主数据库。
* 配置 在从数据库的配置文件中加入 `slaveof (ip)127.0.0.1 (port)6379`
* 启动服务器和客户端命令：(建议使用配置的凡是这样可以长久保存)
        redis-server --port 6379
        redis-server --port 6380 -slaveof 127.0.0.1 6379
        redis-cli -p 6379
        redis-cli -p 6380
* 在redis-cli客户端中修改 slaveof 127.0.0.1 6379
* 可以设置 `slave-read-only yes`设置从服务器可写。
* `laveof no one` 停止从主服务器接收数据
* 用途实现读写分离，主数据库负责写，从数据库负责读。
* 数据安全：当从数据库崩溃时从其即可同步主数据库的数据，当主服务器崩溃的时候，把从服务器提升为主服务器即可。

## reids的安全
* 前提Redis运行在可信的环境下
* `bind 127.0.0.1` bind只能有一个参数，但是可以绑定多个ip地址。、
* 密码 `requirepass password` 设置密码  
* 密码验证 `auth password`

## 管理工具
* 查看耗时命令 `slowlog get`
* 配置耗时 `slowlog-log-slower-than 10000` 单位微秒
* `slowlog-max-len 128`  限制耗时日志的条数
* `monitor` 监控（一个监控会耗费redis将近一半的性能）
        ok
        1446478797.993426 [0 127.0.0.1:48057] "auth" "sunfeilong"
        1446478800.769308 [0 127.0.0.1:48057] "get" "name"
## 其他常用配置





