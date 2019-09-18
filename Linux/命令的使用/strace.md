时间：2019/9/18 20:00:25  

## strace 
### 简介  

跟踪进程产生的内核调用和信号。包括参数、返回值和执行时间。

###  参数 

* `-c`: 统计每一个系统调用的所执行的时间,次数和出错的次数等。

		% time     seconds  usecs/call     calls    errors syscall
		------ ----------- ----------- --------- --------- ----------------
		 23.68    0.000027           3         8           mmap
		 15.79    0.000018           5         4           mprotect
		 14.91    0.000017           4         4           open
		 13.16    0.000015           3         6           close
		  9.65    0.000011           2         5           fstat
		  6.14    0.000007           7         1           munmap
		  6.14    0.000007           2         4           brk
		  5.26    0.000006           3         2           read
		  2.63    0.000003           3         1           arch_prctl
		  2.63    0.000003           3         1           fadvise64
		  0.00    0.000000           0         1         1 access
		  0.00    0.000000           0         1           execve
		------ ----------- ----------- --------- --------- ----------------
		100.00    0.000114                    38         1 total
* `-p pid`: 跟踪指定PId。

### 用法 

1. 跟踪执行命令 

	命令：

		strace cat/dev/null
	输出结果：(等号左边系统调用和参数，等号右边返回值)

		execve("/usr/bin/cat", ["cat", "/dev/null"], [/* 28 vars */]) = 0
		brk(NULL)                               = 0x2131000
		mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ffb4096a000
		... ...
		close(3)                                = 0
		fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
		open("/dev/null", O_RDONLY)             = 3
		fstat(3, {st_mode=S_IFCHR|0666, st_rdev=makedev(1, 3), ...}) = 0
		fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
		read(3, "", 65536)                      = 0
		exit_group(0)                           = ?
		+++ exited with 0 +++


