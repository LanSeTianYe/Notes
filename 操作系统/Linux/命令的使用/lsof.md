时间: 2021-12-03 10:18:18

参考：

0. [lsof 一切皆文件](https://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/lsof.html)

1. [Linux 列出行程開啟的檔案，lsof 指令用法教學與範例](https://blog.gtwang.org/linux/linux-lsof-command-list-open-files-tutorial-examples/)

##  lsof

对于Uinx系统来说，一切都是文件。

lsof 列出系统打开的文件信息。

### 输出信息说明


```
[root@localhost SmartEditor]# lsof -d 3
COMMAND    PID    USER   FD      TYPE             DEVICE SIZE/OFF     NODE NAME
systemd      1    root    3u  a_inode               0,10        0     8534 [timerfd]
systemd-j  544    root    3u     unix 0xffff942a76118cc0      0t0    11145 /run/systemd/journal/stdout
lvmetad    562    root    3u     unix 0xffff942a75908cc0      0t0    13868 /run/lvm/lvmetad.socket
systemd-u  580    root    3u  netlink                         0t0    13491 KOBJECT_UEVENT
auditd     733    root    3u  netlink                         0t0    23590 AUDIT
dbus-daem  758    dbus    3u     unix 0xffff942a761f8880      0t0    25757 /run/dbus/system_bus_socket
systemd-l  765    root    3u     unix 0xffff942a75f60000      0t0    23399 socket
polkitd    767 polkitd    3r  a_inode               0,10        0     8534 inotify
crond      770    root    3uW     REG               0,20        4    23413 /run/crond.pid
NetworkMa  784    root    3u  a_inode               0,10        0     8534 [eventfd]
sshd      1094    root    3u     IPv4              30219      0t0      TCP *:ssh (LISTEN)
rsyslogd  1098    root    3r  a_inode               0,10        0     8534 inotify
tuned     1099    root    3w      REG              253,0    31446      168 /var/log/tuned/tuned.log
container 1104    root    3uW     REG              253,0  1048576 68730766 /var/lib/containerd/io.containerd.metadata.v1.bolt/meta.db
dockerd   1349    root    3u     unix 0xffff942a761fdd80      0t0    31759 /var/run/docker/metrics.sock
master    1355    root    3u     unix 0xffff942a75f66600      0t0    30377 socket
pickup    1363 postfix    3r     FIFO                0,9      0t0    30870 pipe
qmgr      1364 postfix    3r     FIFO                0,9      0t0    30870 pipe
sshd      1830    root    3u     IPv4              27124      0t0      TCP localhost.localdomain:ssh->192.168.88.1:62850 (ESTABLISHED)
dhclient  1946    root    3u     unix 0xffff942aa21561c0      0t0    31097 socket
main      2010    root    3w      REG              253,0  6660597  4146792 /root/SmartEditor/log-debug.log
gocode    2059    root    3u     unix 0xffff942a75841980      0t0    15183 /tmp/gocode-daemon.root
anacron   7396    root    3uW     REG              253,0        9 34035953 /var/spool/anacron/cron.daily
lsof      7491    root    3r      DIR                0,3        0        1 /proc
```

* COMMAND：进程名
* PID：进程标识符
* PPID：父进程标识符
* USER：打开进程用户
* FD：文件描述符

    ```shell
    cwd 当前工作目录
    rtd 根目录
    txt 程序可执行文件
    pd  parent directory
    mem memory-mapped file
    # 分三部分
    # 第一部分：*代表数字。 0 1 2 分别标识 标准输入、输出和错误  
    # 第二部分：一个字母。
    u      文件处于读写模式
    r      文件处于读模式
    w      文件处于写模式
    [空格]  unknow 且没有锁定
    -      unknow 且被锁定
    # 第三部分：一个字母。(可能没有)
    N：for a Solaris NFS lock of unknown type;
    r：for read lock on part of the file;
    R：for a read lock on the entire file;
    w：for a write lock on part of the file;（文件的部分写锁）
    W：for a write lock on the entire file;（整个文件的写锁）
    u：for a read and write lock of any length;
    U：for a lock of unknown type;
    x：for an SCO OpenServer Xenix lock on part      of the file;
    X：for an SCO OpenServer Xenix lock on the      entire file;
    space：if there is no lock.
    ```

* TYPE：文件类型

    ```shell
    IPv4   for an IPv4 socket;
    IPv6   for an open IPv6 network file - even if its address is IPv4, mapped in an IPv6 address;
    ax25   for a Linux AX.25 socket;
    inet   for an Internet domain socket;
    lla    for a HP-UX link level access file;
    rte    for an AF_ROUTE socket;
    sock   for a socket of unknown domain;
    unix   for a UNIX domain socket;
    x.25   for an HP-UX x.25 socket;
    BLK    for a block special file;
    CHR    for a character special file;
    DEL    for a Linux map file that has been deleted;
    DIR    for a directory;
    DOOR   for a VDOOR file;
    FIFO   for a FIFO special file;
    KQUEUE for a BSD style kernel event queue file;
    LINK   for a symbolic link file;
    MPB    for a multiplexed block file;
    PIPE   for pipes
    ```

* DEVICE：磁盘名称

* SIZE/OFF：文件的大小

* NODE：索引标识，文件在磁盘上的 `inode` (通过 `stat` 命令可以查看文件信息)。

* NAME：文件名字

### 使用

```shell
# 显示父进程
lsof -R
# 指定进程名字
lsof -c main
# 指定文件描述符
lsof -d 3
# 指定进程
lsof -p 2010
# 指定用户
lsof -u root[user2[user3]]
lsof -u root -u user2 -u user3
# 非root用户
lsof -u ^root
# 列出所有网络连接
lsof -i
# 列出TCP连接
lsof -i tcp
# 列出指定用户打开的进程和所有的网络连接（不同选项或关系）
lsof -u root -i
# 列出指定用户打开的进程从中过滤网络连接（不同选项and关系）
lsof -a -u root -i
# 查看端口占用
lsof -i :7070
# 重复执行，每三秒输出一次
lsof -r 3
# 查看删除之后没有释放的文件
lsof | grep deleted
```