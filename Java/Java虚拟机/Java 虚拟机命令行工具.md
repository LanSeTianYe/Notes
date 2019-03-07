时间：2017/12/30 10:20:03   
参考：

1. 深入理解Java虚拟机 周志明  

环境：

1. jdk1.9 

## 
### 命令行工具
jdk自带的一些命令行工具，用来分析运行的java实例的内存使用情况。  

#### jps（JVM Process Status Tool）： 查看虚拟机进程状况  

* 说明： 

		usage: jps [-help]
	       jps [-q] [-mlvV] [<hostid>]
	
		Definitions:
		    <hostid>:      <hostname>[:<port>]  
	
* `-q` 显示进程ID
* `-m` 显示启动时传递给主类的参数 
* `-l` 输出主类的全名（包含包路径）
* `-v` 启动时指定的虚拟机配置参数

#### jstat (JVM Statistics Monitoring Tool)：虚拟机统计信息监视工具，以及传递配置参数给虚拟机 `-J-Xms48m`
* 详细解释参考：[jstat官方文档](https://docs.oracle.com/javase/9/tools/jstat.htm#JSWOR734)
	
* 说明：   

		Usage: jstat -help|-options
		       jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]
		Definitions:
		  <option>      An option reported by the -options option
		  <vmid>        Virtual Machine Identifier. A vmid takes the following form:
		                     <lvmid>[@<hostname>[:<port>]]
		                Where <lvmid> is the local vm identifier for the target
		                Java virtual machine, typically a process id; <hostname> is
		                the name of the host running the target Java virtual machine;
		                and <port> is the port number for the rmiregistry on the
		                target host. See the jvmstat documentation for a more complete
		                description of the Virtual Machine Identifier.
		  <lines>       Number of samples between header lines.
		  <interval>    Sampling interval. The following forms are allowed:
		                    <n>["ms"|"s"]
		                Where <n> is an integer and the suffix specifies the units as
		                milliseconds("ms") or seconds("s"). The default units are "ms".
		  <count>       Number of samples to take before terminating.
		  -J<flag>      Pass <flag> directly to the runtime system. 
* 支持的选项：

	* class: Displays statistics about the behavior of the class loader.

		* Loaded: Number of classes loaded.

		* Bytes: Number of KB loaded.
		
		* Unloaded: Number of classes unloaded.
		
		* Bytes: Number of KB loaded.
			
		* Time: Time spent performing class loading and unloading operations.

	* compiler: Displays statistics about the behavior of the Java HotSpot VM Just-in-Time compiler.

		* Compiled: Number of compilation tasks performed.
		
		* Failed: Number of compilations tasks failed.
		
		* Invalid: Number of compilation tasks that were invalidated.
		
		* Time: Time spent performing compilation tasks.
		
		* FailedType: Compile type of the last failed compilation.
		
		* FailedMethod: Class name and method of the last failed compilation.

	* gc: Displays statistics about the behavior of the garbage collected heap.

	* gccapacity: Displays statistics about the capacities of the generations and their corresponding spaces.

	* gccause: Displays a summary about garbage collection statistics (same as -gcutil), with the cause of the last and current (when applicable) garbage collection events.

	* gcnew: Displays statistics about the behavior of the new generation.

	* gcnewcapacity: Displays statistics about the sizes of the new generations and their corresponding spaces.

	* gcold: Displays statistics about the behavior of the old generation and metaspace statistics.

	* gcoldcapacity: Displays statistics about the sizes of the old generation.

	* gcmetacapacity: Displays statistics about the sizes of the metaspace.

	* gcutil: Displays a summary about garbage collection statistics.

	* printcompilation: Displays Java HotSpot VM compilation method statistics.

* 例如：

		// 查看进程id为59270的老年代信息，每隔五行输出一次标题，每隔一秒输出一次，只输出十次
		jstat -gcold -h5 59270 1000 10
#### jinfo 查看 Java配置信息  

* 详细参考： [jinfo官方文档](https://docs.oracle.com/javase/9/tools/jinfo.htm#JSWOR744)

* 说明：  

		Usage:
		    jinfo <option> <pid>
		       (to connect to a running process)
		
		where <option> is one of:
		    -flag <name>         to print the value of the named VM flag
		    -flag [+|-]<name>    to enable or disable the named VM flag
		    -flag <name>=<value> to set the named VM flag to the given value
		    -flags               to print VM flags
		    -sysprops            to print Java system properties
		    <no option>          to print both VM flags and system properties
		    -h | -help           to print this help message

* 使用：
		
		//搜索 `headless` 模式配置
 		jinfo 59270| grep "headless"
#### jmap 输出指定进程的详细信息  
* 详细参考：[jmap官方文档](https://docs.oracle.com/javase/9/tools/jmap.htm#JSWOR746)

* 说明：

		Usage:
		    jmap -clstats <pid>
		        to connect to running process and print class loader statistics
		    jmap -finalizerinfo <pid>
		        to connect to running process and print information on objects awaiting finalization
		    jmap -histo[:live] <pid>
		        to connect to running process and print histogram of java object heap
		        if the "live" suboption is specified, only count live objects
		    jmap -dump:<dump-options> <pid>
		        to connect to running process and dump java heap
		
		    dump-options:
		      live         dump only live objects; if not specified,
		                   all objects in the heap are dumped.
		      format=b     binary format
		      file=<file>  dump heap to <file>
		
		    Example: jmap -dump:live,format=b,file=heap.bin <pid>
* 使用:  

		jmap -dump:,format=b,file=heap.bin 59270

#### jhsdb 堆快照分析工具  

#### jstatd 用于远程分析  
* 遇到一个坑，由于1.9版本移除了 `tools.jar`，授权的时候会报错，解决了一段时间没有解决。

	开放所有权限（危险），依然没有解决：
	
		grant {
		    permission java.security.AllPermission;
		};

#### jstack 堆栈跟踪工具  

* 详细描述 ： [jstack官方文档](https://docs.oracle.com/javase/9/tools/jstack.htm#JSWOR748)

* 说明：  

		Usage:
		    jstack [-l] <pid>
		        (to connect to running process)
		
		Options:
		    -l  long listing. Prints additional information about locks
		    -h or -help to print this help message