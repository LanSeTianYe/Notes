时间: 2020-11-09 17:04:04

## Java 虚拟机垃圾收集器

### 垃圾收集器

####  Serial 

新生代，单线程。使用内存占用小的场景。200M以内。

#### ParNew

新生代，Serial 多线程版本。使用与内存占用大的场景。

只能结合 CMS 使用。

#### Parallel Scavenge

新生代，多线程、标记复制，关注吞吐量（即垃圾回收时间占虚拟机运行时间的百分比）。

* `-XX：MaxGCPauseMillis` 停顿时间。
* `-XX：GCTimeRatio` 垃圾回收所占时间比率。
* `-XX：+UseAdaptiveSizePolicy` 开关，打开之后可以自动调节，新生代、老年代以及新生代 Eden、Survivor 空间大小。

#### Serial Old

老年代，单线程、标记整理。

#### Parallel Old

老年代，多线程，标记整理。

#### CMS 

老年代，多线程、标记清除。并发，低停顿收集器。但是效果一般。

#### G1 

新生代和老年代，多线程，

* `-XX：G1HeapRegionSize` 区块大小， 1~32M，2的n次幂。
* `-XX：MaxGCPauseMillis` 最大收集停顿时间，默认200毫秒。

### 指定垃圾收集器

* `-XX:+UseSerialGC` Serial+Serial Old
* `-XX:+UseParNewGC` ParNew+Serial Old，从JDK1.8开始被废弃。
* `-XX:+UseConcMarkSweepGC` ParNew+CMS+Serial Ol
* `-XX:+UseParallelGC` Parallel Scavenge+Serial Old(PS Mark Sweep)
* `-XX:+UseParallelOldGC` Parallel Scavenge+Parallel Old
* `-XX:+UseG1GC` G1

### 查看垃圾收集日志

JDK1.9 之前

*　｀-XX：+PrintGC｀ 简要GC
*　`-XX：+PrintGCDetails` 详细GC

JDK1.9 以及之后

* `-Xlog:gc` 简要GC
* `-Xlog:gc*` 详细GC
