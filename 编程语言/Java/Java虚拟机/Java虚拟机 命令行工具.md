时间：2017-12-30 10:20:03

参考：

1. 深入理解Java虚拟机 周志明

环境：

1. jdk1.9 

## 命令行工具 

jdk自带的一些命令行工具，用来分析运行的java实例的内存使用情况。

### jps（JVM Process Status Tool）： 查看虚拟机进程状况  

* `-q` 显示进程ID
* `-m` 显示启动时传递给主类的参数 
* `-l` 输出主类的全名（包含包路径）
* `-v` 启动时指定的虚拟机配置参数

### jstat 虚拟机统计信息监视工具，以及传递配置参数给虚拟机

**用法：**`jstat options -hn <vmid> 输出时间间隔 输出次数`

`options` 可以是下面的参数，`-hn` 表示多少次之后输出一次标题。

* `-class`
* `-compiler`
* `-gc` GC 信息。
* `-gccapacity`
* `-gccause` 导致GC的原因，百分比形式显示。
* `-gcmetacapacity`
* `-gcnew`
* `-gcnewcapacity`
* `-gcold`
* `-gcoldcapacity`
* `-gcutil`
* `-printcompilation`

**示例：**

1. 监听老年代GC信息。

		jstat -gcold -h5 59270 1000 10
2. 监听虚拟机GC信息。 

		jstat -gc -h20 59270 1000 1000

### jinfo 查看系统参数，查看和设置 VMFLag。
1.  `jinfo 123456` 输出信息如下：

    ```shell
    Java System Properties:
    java.runtime.name = Java(TM) SE Runtime Environment
    java.vm.version = 25.221-b11
    sun.boot.library.path = /home/xiaotian/software/java/jdk1.8.0_221/jre/lib/amd64
    java.protocol.handler.pkgs = org.springframework.boot.loader
    java.vendor.url = http://java.oracle.com/
    java.vm.vendor = Oracle Corporation
    path.separator = :
    ... ...
    java.version = 1.8.0_221
    java.ext.dirs = /home/xiaotian/software/java/jdk1.8.0_221/jre/lib/ext:/usr/java/packages/lib/ext
    sun.boot.class.path = /home/xiaotian/software/java/jdk1.8.0_221/jre/lib/resources.jar:/home/xiaotian/software/java/jdk1.8.0_221/jre/lib/rt.jar:/home/xiaotian/software/java/jdk1.8.0_221/jre/lib/sunrsasign.jar:/home/xiaotian/software/java/jdk1.8.0_221/jre/lib/jsse.jar:/home/xiaotian/software/java/jdk1.8.0_221/jre/lib/jce.jar:/home/xiaotian/software/java/jdk1.8.0_221/jre/lib/charsets.jar:/home/xiaotian/software/java/jdk1.8.0_221/jre/lib/jfr.jar:/home/xiaotian/software/java/jdk1.8.0_221/jre/classes
    java.awt.headless = true
    java.vendor = Oracle Corporation
    catalina.base = /tmp/tomcat.5571146530846755836.8082
    com.zaxxer.hikari.pool_number = 1
    file.separator = /
    java.vendor.url.bug = http://bugreport.sun.com/bugreport/
    sun.io.unicode.encoding = UnicodeLittle
    sun.cpu.endian = little
    sun.cpu.isalist =

    VM Flags:
    Non-default VM flags: -XX:CICompilerCount=2 -XX:InitialHeapSize=134217728 -XX:MaxHeapSize=536870912 -XX:MaxNewSize=178913280 -XX:MinHeapDeltaBytes=196608 -XX:NewSize=44695552 -XX:OldSize=89522176 -XX:+PrintGC -XX:+PrintGCTimeStamps -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -XX:+UseFastUnorderedTimeStamps
    Command line:  -XX:+PrintGC -Xloggc:./gc.log -Xms128m -Xmx512m -Dloader.path=/home/xiaotian/tools/lib/ -Dspring.profiles.active=dev
    ```

2. 设置 VM FLAG。

	* `jinfo -flag <name>` 打印 VM Flag。
	* `jinfo [+|-] -flag` 启用或禁用 VM Flag。
	* `jinfo -flag <name>=<value>` 设置 VM flag。
	* `jinfo -flags 12345` 打印 VM Flag。
### jmap 输出指定进程的详细信息  

1. `jmap -h` 查看帮助信息。
2. `jmap -heap 12345` 查看虚拟机堆内存使用情况。
3. `jmap -histo 12345` 查看类的实例数量以及占用内存。
4. `jmap -clstats 12345` 查看类加载器统计信息。
5. `jmap -finalizerinfo 12345` 查看等待释放的类。
6. `jmap -dump:format=b,file=./heap.bin 12345` dump 堆栈信息。 

### jstack 堆栈跟踪工具  

1. `jstack -l 12345` 查看线程堆栈信息。 
2. `jstack -m 12345` 查看线程堆栈信息，内存地址模式。
3. `jstack -F -l 12345` 强制执行，当 `jstack -l` 无响应时使用。

## 命令行工具输出信息含义 

* `S0C、S1C、S0U、S1U、S0CMX、SC1MX ` Survior 0/1 容量、使用量和最大容量。
* `EC EU` Eden 区容量和使用量。
* `OC OU` 老年代容量和使用量。
* `M MC MU MCMN MCMX` MetaSpace 区使用率、容量、使用量、最小容量和最大容量。
* `YGC YGCT` 新生代GC次数和耗时。
* `FGC FGCT` FULL GC 次数和耗时。
* `GCT` GC的全部耗时。
* `NGCMN NGCMX` 新生代最小和最大容量。
* `TT MTT` 对象经过指定次数的垃圾回收会被复制到老年代。
* `Loadedjvm Unloadedjvm` 加载类数量和未加载类数量。
* `CCS CCSC CCSU CCSMN CCSMX` 压缩使用率、容量、使用量、最小容量和最大容量。