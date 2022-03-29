时间: 2021-03-28 20:15

参考:

1. [How to Clear RAM Memory Cache, Buffer and Swap Space on Linux](https://www.tecmint.com/clear-ram-memory-cache-buffer-and-swap-space-on-linux/)
2. [slab机制](https://www.cnblogs.com/wangzahngjun/p/4977425.html)

## Linux 内存

### Linux 内存简介

系统运行一段时间后内存里面缓存的数据占用大量空间，导致服务器访问变慢。可以通过命令清理空间。（1核1G的服务器😭）

```shell
[root@xiaotian ~]# free -h
              total        used        free      shared  buff/cache   available
Mem:           981M        119M        555M         48M        306M        614M
Swap:          2.0G         91M        1.9G
```

各项含义：

```shell
total       Total installed memory (MemTotal and SwapTotal in /proc/meminfo)

used        Used memory (calculated as total - free - buffers - cache)

free        Unused memory (MemFree and SwapFree in /proc/meminfo)

shared      Memory used (mostly) by tmpfs (Shmem in /proc/meminfo, available on kernels 2.6.32, displayed as zero if not available)

buffers     Memory used by kernel buffers (Buffers in /proc/meminfo)

cache       Memory used by the page cache(缓存磁盘文件的内存) and slabs (Cached and Slab in /proc/meminfo)(内核对象缓存)

buff/cache  Sum of buffers and cache
```

### 清理 Linux 内存

下面三个命令可以在杀掉任何进程的情况下清理系统缓存。

```shell
# 清理  page cache
# sync; echo 1 > /proc/sys/vm/drop_caches      
# 清理 目录项和inode
# sync; echo 2 > /proc/sys/vm/drop_caches
# 清理 page cache 和 目录项和inode
# sync; echo 3 > /proc/sys/vm/drop_caches 
```

page cache 是缓存在磁盘上的文件信息，清理之后，读文件会时先到磁盘读，然后把信息缓存在内存中。

### 清理 Linux 交换空间

```shell 
swapoff -a && swapon -a
```

