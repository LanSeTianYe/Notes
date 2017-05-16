## 
时间：2017/5/15 19:06:07  
参考：

1. [周志明]深入理解JAVA虚拟机

## 虚拟机各分区内存配置

**堆内存：**存储对象实例。多线程共享。

 * -Xms20M  初始化堆内存大小
 * -Xmx20m  最大堆内存大小
  * -Xmn10m  新生代大小（剩余的为老年代）

**方法区**：俗称永久代，1.8取消了方法区改为Metaspace。存储加载的类信息，常量等。多线程共享。
 
 * -XX:PermSize=20m  方法区大小
 * -XX:MaxPermSize=20m 最大方法区大小
 * -XX:MaxMetaspaceSize=128m 设置源空间大小

**虚拟机栈**：存储方法块儿里面的数据，包含局部变量，对象引用和方法返回地址等。
 
 * -Xss5m 调节线程堆栈大小

**直接内存**：不受Java虚拟机管理，属于操作系统内存。

 * -XX:MaxDirectMemorySize=10M 设置直接内存大小


## 其他配置信息

 * -Xverify:none 是否在编译前检查类
 * -XX:+UseConcMarkSweepGC  使用CMS收集器（老年代）
 * -XX:+USeParNewGC (CMS默认的新生代收集器)
 * -XX:+PrintGCDetails 打印GC信息
 * -XX:+PrintReferenceGC 打印GC过程中不同类型引用耗时
 * -XX:+PrintGCApplicationStoppedTime 显示GC过程，停止执行应用程序的时间
 * -XX:+PrintGCDateStamps 
 * -Xloggc:gclog.log 把GC日志打印到文件中
 * -Dsun.awt.keepWorkingSetOnMinimize=true 设置程序可以在后台运行，防止程序最小化之后，操作系统把内存数据转移到磁盘中，导致程序运行缓慢的问题
 * -Dcom.sun.management.jmxremote  允许JMX远程连接
 * -XX:+HeapDumpOnOutOfMemoryError 虚拟机出现OutOfMemory异常的时候自动生成dump文件
