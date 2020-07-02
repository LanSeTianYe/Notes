##  
时间：2017/8/14 20:38:38  
参考：  

*  [http://man.linuxde.net/kill](http://man.linuxde.net/kill)   

##  
### kill 命令简介 

kill命令用来删除执行中的程序或工作。kill可将指定的信息送至程序。预设的信息为SIGTERM(15),可将指定程序终止。若仍无法终止该程序，可使用SIGKILL(9)信息尝试强制删除程序。
 
### 语法  

	kill(选项)(参数)

### 选项    

* a：当处理当前进程时，不限制命令名和进程号的对应关系。
* l <信息编号>：若不加<信息编号>选项，则-l参数会列出全部的信息名称。
* p：指定kill 命令只打印相关进程的进程号，而不发送任何信号。
* s <信息名称或编号>：指定要送出的信息。
* u：指定用户。

### 参数
进程或作业识别号：指定要删除的进程或作业。


### 例子  

1. 列出所有信息。

		[root@qyi]# kill -l
		 1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL       5) SIGTRAP
		 6) SIGABRT      7) SIGBUS       8) SIGFPE       9) SIGKILL     10) SIGUSR1
		11) SIGSEGV     12) SIGUSR2     13) SIGPIPE     14) SIGALRM     15) SIGTERM
		16) SIGSTKFLT   17) SIGCHLD     18) SIGCONT     19) SIGSTOP     20) SIGTSTP
		21) SIGTTIN     22) SIGTTOU     23) SIGURG      24) SIGXCPU     25) SIGXFSZ
		26) SIGVTALRM   27) SIGPROF     28) SIGWINCH    29) SIGIO       30) SIGPWR
		31) SIGSYS      34) SIGRTMIN    35) SIGRTMIN+1  36) SIGRTMIN+2  37) SIGRTMIN+3
		38) SIGRTMIN+4  39) SIGRTMIN+5  40) SIGRTMIN+6  41) SIGRTMIN+7  42) SIGRTMIN+8
		43) SIGRTMIN+9  44) SIGRTMIN+10 45) SIGRTMIN+11 46) SIGRTMIN+12 47) SIGRTMIN+13
		48) SIGRTMIN+14 49) SIGRTMIN+15 50) SIGRTMAX-14 51) SIGRTMAX-13 52) SIGRTMAX-12
		53) SIGRTMAX-11 54) SIGRTMAX-10 55) SIGRTMAX-9  56) SIGRTMAX-8  57) SIGRTMAX-7
		58) SIGRTMAX-6  59) SIGRTMAX-5  60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2
		63) SIGRTMAX-1  64) SIGRTMAX

	常用信息介绍：

		HUP     1    终端断线
		INT     2    中断（同 Ctrl + C）
		QUIT    3    退出（同 Ctrl + \）
		TERM   15    终止（默认）
		KILL    9    强制终止
		CONT   18    继续（与STOP相反， fg/bg命令）
		STOP   19    暂停（同 Ctrl + Z）

2. 强制终止指定进程。

	kill -9 pid
