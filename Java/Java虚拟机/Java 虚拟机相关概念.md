##   
时间：2017/8/12 17:12:54 

参考：

1. [周志明]深入理解JAVA虚拟机

## 内存分区  

* 程序计数器 ：当前执行的指令地址。
* 虚拟机栈：当前线程执行的方法的 参数入口、返回地址等。
* 本地虚拟机栈: 类似于虚拟机栈。
* 堆: 储存创建的对象，分为新生代和老年代。新创建的对象会放入新生代，经历过几次GC之后还没有被清除的对象会被放在老年代。
* 方法区: 类、常量和类静态变量。

## 垃圾收集器 

### 垃圾回收器种类 
* 新生代
	* Serial: 单线程运行，执行的时候需要暂停虚拟机正在执行的所有任务 `Stop The World`。使用于客户端模式和单核电脑。
	* ParNew: Serial 回收器的多线程版本。
	* Parallel Scavenge: 吞吐量优先，通过参数设置需要满足的吞吐量回收器自动调节堆内存分配。 
* 老年代 
	* CMS (Concurrent Make Sweep):  并行执行标记清理算法。
	* Serial Old: Serial 回收器的老年代版本。
	* Parallel Old: Parallel  回收器的老年代版本。
* 新生代和老年代公用：
	* G1：把堆内分成不同的 `Region` 根据配置，垃圾回收是在对应的 `Region` 进行。

### 垃圾回收器配置    

* `-XX:+UseSerialGC` 新生代使用 `Seriol` 老年代使用 `Serial Old`。
* `-XX:+UseParnNewGC` 新生代使用 `ParNew` 老年代使用 `Serial Old`。
* `-XX:+UseConcMarkSweepGC`  新生代使用 `ParNew` 老年代使用 `CMS`。
* `-XX:+UseParallel` 新生代使用 `Parallel Scavenge` 老年代使用 `Serial Old`。
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