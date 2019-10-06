时间：2019/9/18 20:14:27  

参考： 

1. [Linux系统调用列表](https://www.ibm.com/developerworks/cn/linux/kernel/syscall/part1/appendix.html)

## Linux 系统调用  

在 Linux 中进程不能和硬件直接交互，当需要访问硬件（硬盘、鼠标、键盘）时，需要由用户态切换到内核态执行系统调用，简介的操作硬件。

### 系统调用  

#### 进程控制   

1. `fork`: 创建一个新进程。
2. `clone`: 按指定条件创建子进程。
3. `execve`: 运行可执行文件。
4. `exit`: 终止进程。
5. `_exit`: 立即终止当前进程。
6. `getdtablesize`: 进程能打开的最大文件数。
7. `getpgid`: 获取指定进程组标识号。
8. `setpgid`: 设置指定进程组标志号。
9. `getpgrp`: 获取当前进程组标识号。
10. `setpgrp`: 设置当前进程组标志号。
11. `getpid`: 获取进程标识号。
12. `getppid`: 获取父进程标识符。
13. `getpriority`: 获取调度优先级。
14. `setpriority`: 设置调度优先级。
15. `modify_ldt`: 读写进程的本地描述表。
16. `nanosleep`: 使进程睡眠指定的时间。
17. `nice`: 改变分时进程的优先级。
18. `pause`: 挂起进程，等待信号。
19. `personality`: 设置进程运行域。
20. `prctl`: 对进程进行特定操作。

#### 文件系统控制

1. `fcntl`: 文件控制。
2. `open`: 打开文件。
3. `creat`: 创建文件。
4. `close`: 关闭文件描述符。
5. `read`: 读文件。
6. `write`: 写文件。
7. `readv`: 从文件读入数据到缓冲数组中。
8. `writev`: 将缓冲数组里的数据写入文件。
9. `pread`: 对文件随机读。
10. `pwrite`: 对文件随机写。
11. `lseek`: 移动文件指针。
12. `_llseek`: 在64位地址空间里移动文件指针。
13. `dup`: 复制已打开的文件描述字。
14. `dup2`: 按指定条件复制文件描述字。
15. `flock`: 文件加/解锁。
16. `poll`: IO 多路转换。
17. `truncate`: 截断文件。
18. `umask`: 设置文件权限掩码。
19. `fsync`: 把文件在内存中的部分写回磁盘。

#### 系统控制 

1. `ioctl`: IO总线控制。
2. `getrlimit`: 获取系统资源上限。
3. `swapon`: 打开交换文件和设备。
4. `sysfs`: 取核心支持的文件系统类型。
5. `sysinfo`: 取得系统信息。
6. `adjtimex`: 调整系统时钟。
7. `getitimer`: 获取计时器值。
8. `gettimeofday`: 取时间和时区。
9. `times`: 取进程运行时间。
10. `init_module`: 初始化模块。
11. `query_module`: 查询模块信息。

#### 内存管理 

1. `brk`: 改变数据段空间的分配。
2. `mlock`: 内存页面加锁。
3. `munlock`: 内存页面解锁。
4. `mlockall`: 调用进程所有内存页面加锁。
5. `mmap`: 	映射虚拟内存页。
6. `munmap`: 去除内存页映射。
7. `msync`: 将映射内存中的数据写回磁盘。
8. `getpagesize`: 获取页面大小。
9. `sync`: 将内存缓冲区数据写回硬盘。
10. `cacheflush`: 将指定缓冲区中的内容写回磁盘。

#### 网络管理  

1. `getdomainname`: 取域名。
2. `setdomainname`: 设置域名。
3. `gethostid` 获取主机标识号。
4. `sethostid` 设置主机标识号。
5. `gethostname` 获取本主机名称。
6. `sethostname` 设置主机名称。

#### socket控制  
1. `socketcall`: socket 系统调用。
2. `scoket`: 建立socket。
3. `bind`: 绑定到指定端口。
4. `connect`: 连接远程主机。
5. `accept`: 响应socket连接请求。
6. `send`: 通过socket发送信息。
7. `recv`: 通过socket接收信息。
8. `listen`: 监听socket端口。
9. `select`: 对多路同步I/O进行轮询。
10. 

#### 用户管理  

1. `getuid`: 获取用户标识。
2. `setuid`：设置用户标识。
3. `getgid`: 获取用户组标识。

#### 进程间通信 

1. `ipc`: 	进程间通信总控制调用。

##### 信号  

1. `sigaction`: 设置对指定信号的处理方法。
2. `sigprocmask`: 根据参数对信号集中的信号执行阻塞/解除阻塞等操作。
3. `sigpending`: 为指定的被阻塞信号设置队列。
4. `sigsuspend`: 挂起进程等待特定信号。
5. `signal`: 参见signal。
6. `kill`: 向进程或进程组发信号。

##### 消息 

1. `msgctl`: 消息控制操作。
2. `msgget`: 获取消息队列。
3. `msgsnd`: 发消息。
4. `msgrcv`: 取消息。

##### 管道 

1. `pipe` 创建管道。

##### 信号量  

1. `semctl` 信号量控制。
2. `semget` 获取一组信号量。
3. `semop` 信号量操作。

##### 共享内存  

1. `shmctl` 控制共享内存。
2. `shmget` 获取共享内存。
3. `shmat` 连接共享内存。
4. `shmdt` 拆卸共享内存。