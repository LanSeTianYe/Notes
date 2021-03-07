时间：2017/5/15 19:06:07

参考：

1. 《深入理解JAVA虚拟机》第二版 [周志明]

## 虚拟机参数配置 

### 虚拟机垃圾回收器配置 

* `-XX:+UseSerialGC` 新生代使用 `Seriol` 老年代使用 `Serial Old`。
* `-XX:+UseParNewGC` 新生代使用 `ParNew` 老年代使用 `Serial Old`。
* `-XX:+UseConcMarkSweepGC`  新生代使用 `ParNew` 老年代使用 `CMS`。
* `-XX:+UseParallelGC` 新生代使用 `Parallel Scavenge` 老年代使用 `Serial Old`。
* `-XX:UseParallelOldGC` 新生代使用 `Parallel Scavenge` 老年代使用 `Parallel Old`。
* `-XX:SurvivorRatio` 新生代 `Eden` 区域和 `Survivor` 区域比率配置。
* `-XX:PretenureSizeThreshold` 直接晋升到老年代的对象大小。
* `-XX:MaxTenuringThreshold` 晋升到老年代对象的年龄。
* `-XX:UseAdapttiveSizePolicy` 动态调整Java堆中各区域大小以及进入老年代的年龄。
* `-XX:HandlePromotionFailure` 是否允许担保失败，当老年代剩余空间进行担保不足时，是否尝试进行担保，如果失败则会执行 `Full GC`。
* `-XX:ParallelGCThreads` 并行GC时的内存回收线程数。
* `-XX:GCTimeRatio` GC 占总时间的比值，默认 99%，即允许 1% 的GC时间。在 `Parallel Scavenge` 垃圾收集器有用。
* `-XX:MaxGcPauseMillis` 最大GC停顿时间，在 `Parallel Scavenge` 垃圾收集器有用。
* `-XX:CMSInitiatingOccupaneyFraction` CMS 在老年代占用超过多少时进行垃圾回收，默认 68%。
* `-XX:UseCMSCompactAtFullCollection` 设置 CMS 是否在垃圾回收完成时进行一次内存整理。
* `-XX:CMSFullGcsBeforeCompaction` 设置 CMS 在若干次垃圾回收后再进行内存整理。

### GC 日志相关配置 

* `-XX:+PrintGC` 输出GC日志（简要信息）。
* `-XX:+PrintGCDetails` 输出详细日志。
* `-XX:+PrintGCTimeStamps` 输出GC时间戳。
* `-XX:+PrintGCDateStamps` 输出GC时间戳，日期形式。
* `-XX:+PrintHeapAtGC` 在进行GC前后打印出堆信息。
* `-Xloggc:./gc.log` 指定GC日志文件位置。
* `-XX:+PrintGCApplicationConcurrentTime` 打印应用程序的执行时间。
* `-XX:+PrintGCApplicationStoppedTime` 打印程序由于GC而停顿的时间。
* `-XX:+PrintReferenceGC` 跟踪弱引用。

### StringTable

StringTable 用于存放类加载时的字符串字面量，`String.intern()` 方法可以把字符串放入 StringTable中。底层使用数组加链表实现。存在垃圾回收。

* `-XX:StringTableSize=N` 控制StringTable的大小（数组大小），如果设置的太小则会导致链表长度过长，影响StringTable的性能。

* `-XX:+PrintStringTableStatistics` 输出StringTable信息。

### 其它

**堆内存：**存储对象实例。多线程共享。

 * -Xms20M  初始化堆内存大小(最小)
 * -Xmx20m  最大堆内存大小（最大）
  * -Xmn10m  新生代大小（剩余的为老年代）
     * -XX:SurvivorRation=8 Eden:ToSurvivor:FromSurvivor空间比是 `8:1:1` 

 * `-XX::+/-UseTLAB` 开启TLAB之后，每个线程会在堆中拥有一块私有的区域，用于对象创建，避免不同线程之间的资源竞争问题。

**方法区**：俗称永久代，1.8取消了方法区改为Metaspace。存储已被虚拟机加载的类信息，常量、静态变量、即时编译后的代码数据等（方法名、类名等）。多线程共享。

 * -XX:PermSize=20m  方法区大小
 * -XX:MaxPermSize=20m 最大方法区大小
 * -XX:MaxMetaspaceSize=128m 设置元空间大小

**虚拟机栈**：每个方法在创建的时候都会创建一个栈帧，用于存放局部变量表，操作数栈，动态链接，方法出口等信息。

 * -Xss1m 调节线程堆栈大小

**直接内存**：不受Java虚拟机管理，属于操作系统内存。

 * -XX:MaxDirectMemorySize=10M 设置直接内存大小，默认和Java堆大小相同。

## 性能调优

1. 对象优先分配在新生代的Eden区。

    * `-XX: PretenureSizeThreshold=<byte size>` 使大于这个值得对象直接进入老年区（只对Serial和ParNew两个垃圾回收器起作用）

2. 长期存活的对象会进入老年区。

    * -XX:MaxTenuringThreshold=15 默认值15。对象在Eden中出生，第一次Minor GC之后仍然存活，并且能被Survivor容纳，将被移动到Survivor区，并且年龄设置为1，对象在Survivor中每经历过一次Minor GC对象的年龄就增加一，当年龄达到设定值之后就会进入老年区。

3. 动态年龄判断，如果Survivor空间中相同年龄的所有对象的大小大于Survivor空间的一半，年龄大于或等于该年龄的对象直接进入老年区。

4. 空间分配担保，当老年代最大可用连续空间小于新生代多有对象占用空间大小，可能需要一次Full GC。

5. -XX:HandlePromotionFailure=false 空间担保不可行的情况下是否允许冒险。

6. 内存限制：32位windows每个进程最大2GB内存，Linux和Unix系统，可以提升至3GB甚至4GB。32位虚拟机最大内存4GB（2^32）内存。 

## 其他配置信息

* -Xverify:none 是否在编译前检查类。
* -verbose:gc 显示gc信息。
* -Dsun.awt.keepWorkingSetOnMinimize=true 设置程序可以在后台运行，防止程序最小化之后，操作系统把内存数据转移到磁盘中，导致程序运行缓慢的问题
* -Dcom.sun.management.jmxremote  允许JMX远程连接
* -XX:+HeapDumpOnOutOfMemoryError 虚拟机出现内存溢出异常时Dump出当前的内存堆转储快照以便时候分析
* -XX:+UseCompressedOops:普通对象指针压缩功能（建议维持虚拟机默认的机制，不推荐使用）

