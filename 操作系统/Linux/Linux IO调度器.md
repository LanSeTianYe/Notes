时间：2018-01-06 00:05:52 

参考：

1. [调整 Linux I/O 调度器优化系统性能](https://www.ibm.com/developerworks/cn/linux/l-lo-io-scheduler-optimize-performance/index.html)
2. [Linux的IO调度](https://liwei.life/2016/03/14/linux_io_scheduler/)
3. [How to change the Linux I/O scheduler to fit your needs](https://www.techrepublic.com/article/how-to-change-the-linux-io-scheduler-to-fit-your-needs/)

## Linux I/O 调度器

### Linux I/O 调度器 简介

Linux I/O 调度器是Linux内核中的一个组成部分，可以通过调整这个调度器来优化系统性能。

* 查看系统支持的调度器，以及当前使用的调度器：

    命令：
    
        ```
        dmesg | grep -i scheduler
        ```

	结果：default是当前使用的调度器

        ```
        [    0.876354] io scheduler noop registered
        [    0.876356] io scheduler deadline registered (default)
        [    0.876394] io scheduler cfq registered
        ```

* 查看一个硬盘使用的I/O调度器 `cat /sys/block/vda/queue/scheduler`

* 修改调度器： 

    ```
    //1.修改某个磁盘的调度器，临时
    echo noop > /sys/block/sdb/queue/scheduler	
    //2.修改系统调度器，永久
    grubby --grub --update-kernel=ALL --args="elevator=deadline"
    //3.编辑配置文件 vim /etc/default/grub ,然后重启电脑
    GRUB_TIMEOUT=5
    GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
    GRUB_DEFAULT=saved
    GRUB_DISABLE_SUBMENU=true
    GRUB_TERMINAL_OUTPUT="console"
    //修改这一行
    GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap net.ifnames=0 biosdevname=0 rhgb quiet"
    //修改之后
    GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap net.ifnames=0 biosdevname=0 rhgb quiet elevator=noop"
    GRUB_DISABLE_RECOVERY="true"
    ```

### 主流调度器

* DeadLine  

	截止时间调度器，是对Linus Elevator的一种改进，它避免有些请求太长时间不能被处理。另外可以区分对待读操作和写操作。DEADLINE额外分别为读I/O和写I/O提供了FIFO队列。
* CFQ

	CFQ全称Completely Fair Scheduler ，中文名称完全公平调度器，它是现在许多 Linux 发行版的默认调度器，CFQ是内核默认选择的I/O调度器。它将由进程提交的同步请求放到多个进程队列中，然后为每个队列分配时间片以访问磁盘。对于通用的服务器是最好的选择,CFQ均匀地分布对I/O带宽的访问。CFQ为每个进程和线程,单独创建一个队列来管理该进程所产生的请求,以此来保证每个进程都能被很好的分配到I/O带宽，I/O调度器每次执行一个进程的4次请求。该算法的特点是按照I/O请求的地址进行排序，而不是按照先来后到的顺序来进行响应。简单来说就是给所有同步进程分配时间片，然后才排队访问磁盘
* NOOP

	NOOP全称No Operation,中文名称电梯式调度器，该算法实现了最简单的FIFO队列，所有I/O请求大致按照先来后到的顺序进行操作。NOOP实现了一个简单的FIFO队列,它像电梯的工作主法一样对I/O请求进行组织。它是基于先入先出（FIFO）队列概念的 Linux 内核里最简单的I/O 调度器。此调度程序最适合于固态硬盘。

### 调度器适用场景 

* Deadline适用于大多数环境,特别是写入较多的文件服务器，从原理上看，DeadLine是一种以提高机械硬盘吞吐量为思考出发点的调度算法，尽量保证在有I/O请求达到最终期限的时候进行调度，非常适合业务比较单一并且I/O压力比较重的业务，比如Web服务器，数据库应用等。
* CFQ 为所有进程分配等量的带宽,适用于有大量进程的多用户系统，CFQ是一种比较通用的调度算法，它是一种以进程为出发点考虑的调度算法，保证大家尽量公平,为所有进程分配等量的带宽,适合于桌面多任务及多媒体应用。
* NOOP 对于闪存设备和嵌入式系统是最好的选择。对于固态硬盘来说使用NOOP是最好的，DeadLine次之，而CFQ效率最低。
