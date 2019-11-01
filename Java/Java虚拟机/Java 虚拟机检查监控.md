时间：2019/3/15 11:59:51 

参考：

1. [Java动态追踪技术探究](https://mp.weixin.qq.com/s?__biz=MjM5NjQ5MTI5OA==&mid=2651750347&idx=2&sn=9355f3f908b59c738ae090ff702f56ee&chksm=bd12a6868a652f9088949f667e60c9893ad18148768141197d084f289ddfc235f86aec500b4e&mpshare=1&scene=1&srcid=031519FZAErMdg5Kra97IGsq#rd)
2. [Arthas](https://github.com/alibaba/arthas)
3. [Arthas文档](https://alibaba.github.io/arthas)
4. [Arthas 案例](https://github.com/alibaba/arthas/issues/569)
5. [ONGL](https://commons.apache.org/proper/commons-ognl/language-guide.html)

## Java动态追踪技术探究  

### Arthas（阿尔萨斯）   

阿里开源的Java诊断工具，采用命令行方式，支持Tab自动补全，相较于JDK提供的 `jps` `jstack` `jinfo` 等原生命令更全面更好用。

#### 可以做什么  
* 监控JVM实时运行状况。
* 监控方法的调用耗时。
* 观察方法的返回值、抛出异常、入参等。
* 支持 `ongl` 表达式。
* ...

### 命令  

1. `dashboard` 查看进程整体运行情况概要界面。
2. `thread` 查看线程堆栈信息。
 * `thread` 显示所有线程。	
 * `thread id` 指定线程信息。
 * `thread -n number` 查看占用率最高的前 `number` 个线程的堆栈信息。
 * `thread -b` 查看阻塞其它线程的线程。
 * `thread -i time`: 线程CPU时间占用时间统计。
 * `thread -n 3 -i 1000` 指定采样间隔。
3. `jvm` 查看当前JVM信息。

 * `COUNT`: JVM当前活跃的线程数。
 * `DAEMON-COUNT`: JVM当前活跃的守护线程数。
 * `PEAK-COUNT`: 从JVM启动开始曾经活着的最大线程数。
 * `STARTED-COUNT`: 从JVM启动开始总共启动过的线程次数。
 * `DEADLOCK-COUNT`: JVM当前死锁的线程数。
 * `MAX-FILE-DESCRIPTOR-COUNT`：JVM进程最大可以打开的文件描述符数。
 * `OPEN-FILE-DESCRIPTOR-COUNT`：JVM当前打开的文件描述符数。
4. `sysprop` 查看系统属性。

 * `sysprop` 查看所有属性。
 * `sysprop java.version` 查看单个属性。
 * `sysprop user.country country` 设置属性。
5. `sysenv` 查看当前JVM的环境属性。
6. `vmoption`：查看虚拟机选项配置。
 * `vmoption` 查看配置。
 * `vmoption PrintGCDetails true` 设置虚拟机选项配置。 
7. `logger`: 查看所有 `logger` 信息。
 * `logger` 查看所有。 
 * `logger -n org.springframework.web` 指定名字查看。
8. `mbean` 查看 Mbean 的信息。
9. `sc` 搜索虚拟机已经加载的类信息。
 * `sc com.sun.xiaotian.blogger.*` 搜索指定包下面的类。
 * `sc -d com.sun.xiaotian.blogger.util.PinYin` 打印类的详细信息。
 * `sc -df com.sun.xiaotian.blogger.model.ArticleInfo` 输出类的成员变量。
 * `sc -df -x 3 com.sun.xiaotian.blogger.model.ArticleInfo` 成员变量深度为3。
10 `sm` 搜索类的方法。
 * `sm java.lang.String` 搜索指定类的方法。
 * `sm -d java.lang.String` 搜索指定类的方法，并展示方法的详细信息。
 * `sm -d java.lang.String toString`  搜索指定类的指定方法。
11. `dump` dump已加载的类到特定目录。
 * `dump com.sun.xiaotian.blogger.*` dump 指定包。
12. `heapdump` dump 堆信息到指定目录。
 * `heapdump /tmp/dump.hprof` dump到指定目录。
 * `heapdump --live /tmp/dump.hprof` 只 dump  live 对象。
13. `jad` 反编译类文件。
 * `jad  com.sun.xiaotian.blogger.BloggerRun` 反编译指定类。
 * `jad --source-only  com.sun.xiaotian.blogger.BloggerRun` 反编译指定类，只显示源码。
 * `jad com.sun.xiaotian.blogger.BloggerRun main` 反编译指定函数。
 * `jad -c @6767c1fc com.sun.xiaotian.blogger.BloggerRun` 指定类加载器。
14. `classloader` 查看classloader的继承树，urls，类加载信息。
 * `classloader` 类加载器的统计信息。 
 * `classloader -t` 查看类加载器的继承树。
 * `classloader -a` 查看所有类加载器（危险）。
 * `classloader -c 1b6d3586 -r java/lang/String.class` 使用类加载器查找类。
 * `classloader -c 3d4eac69 --load demo.MathGame` 使用类加载器加载类。
15. `mc` 内存编译器，编译 `.java` 文件。
16. `redefine` 加载外部class。
17. `monitor` 监控方法调用。
 * `monitor -c 5 demo.MathGame primeFactors`

#### 下载及启动 
1. 下载和使用    

		# 下载   
		wget https://alibaba.github.io/arthas/arthas-boot.jar
		# 启动   
		java -jar arthas-boot.jar --target-ip 0.0.0.0

	

