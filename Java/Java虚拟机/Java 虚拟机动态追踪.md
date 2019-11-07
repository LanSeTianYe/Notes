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
* 支持 `Tab` 自动补全。
* ...

### 基础知识  

1. 表达式核心变量，。`Arthas` 命令参数会使用该类进行一些逻辑判断，比如 `params.length == 1` `method.name="abc"`。

	参考: [特殊用法](https://github.com/alibaba/arthas/issues/71)

		public class Advice {
			//本次调用类所在的 ClassLoader
		    private final ClassLoader loader;
			//本次调用类的 Class 引用
		    private final Class<?> clazz;
			//本次调用方法反射引用
		    private final ArthasMethod method;
			//本次调用类的实例
		    private final Object target;
			//本次调用参数列表，这是一个数组，如果方法是无参方法则为空数组
		    private final Object[] params;
			//本次调用返回的对象。当且仅当 isReturn==true 成立时候有效，表明方法调用是以正常返回的方式结束。如果当前方法无返回值 void，则值为 null
		    private final Object returnObj;
			//本次调用抛出的异常。当且仅当 isThrow==true 成立时有效，表明方法调用是以抛出异常的方式结束。
		    private final Throwable throwExp;
			//辅助判断标记，当前的通知节点有可能是在方法一开始就通知，此时 isBefore==true 成立，同时 isThrow==false 和 isReturn==false，因为在方法刚开始时，还无法确定方法调用将会如何结束。
		    private final boolean isBefore;
			//辅助判断标记，当前的方法调用以抛异常的形式结束。
		    private final boolean isThrow;
			//辅助判断标记，当前的方法调用以正常返回的形式结束。
		    private final boolean isReturn; 
		}  
2. 常用过滤条件。
 * `'#cost >0'` 耗时大于零。 

### 命令  

#### 基础命令  
1. `cls` 清空屏幕。
2. `help` 查看帮助信息。
2. `session` 查看当前session。
3. `reset` 重置增强类，重置使用 `Arthas` 过程对类的更改。
4. `version` 版本号。
5. `history` 命令历史。
6. `quit` 退出当前客户端。
7. `stop shutdown` 关闭 `Arthas` 所有客户端都会退出。
8. `keymap` 快捷键。
#### 其它命令  
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
 * `monitor -c 5 demo.MathGame primeFactors` 监控方法调用 调用次数、成功次数、失败次数。`-c` 指定统计周期（单位秒）。
18. `watch` 观察方法参数、返回值等。 `-b` 方法调用之前 `-e` 方法异常之后 `-s` 方法返回之后 `-f` 方法结束之后（正常返回合异常返回）。
 * `watch demo.MathGame primeFactors "{params,returnObj}" -x 2` 观察方法出参和返回值，深度为2。
 * `watch demo.MathGame primeFactors "{params,returnObj}" -x 2 -b` 观察方法入参。
 * `watch demo.MathGame primeFactors "{params,target,returnObj}" -x 2 -b -s -n 2` 同时观察方法调用前和方法返回后，执行两次。
 * `watch demo.MathGame primeFactors "{params,target}" -x 3` 调整参数便利深度 `a.b.c`。
 * `watch demo.MathGame primeFactors "{params[0],target}" "params[0]<0"` 条件表达式。
 * `watch demo.MathGame primeFactors "{params[0],throwExp}" -e -x 2` 观察异常信息。
 * `watch demo.MathGame primeFactors '{params, returnObj}' '#cost>200' -x 2` 按照耗时进行过滤。
 * `watch demo.MathGame primeFactors 'target'` 观察当前对象中的属性。 
18. `trace` 方法内部调用路径，及每个调用的耗时（方法内部调用）。
 * `trace com.sun.xiaotian.blogger.web.FileInfoController getContentByFilePath` 查看对应方法里的方法调用及耗时。
 * `trace *StringUtils isBlank` 通配符。
 * `trace -j com.sun.xiaotian.blogger.web.FileInfoController getContentByFilePath` 查看对应方法里的方法调用及耗时。过滤掉JDK内部方法。
 * `trace demo.MathGame run '#cost > 10'` 耗时大于10毫秒。
 * `trace -E com.test.ClassA|org.test.ClassB method1|method2|method3` 跟踪多个方法。
18. `stack` 打印方法的调用堆栈，及执行耗时（从哪里调用到方法）。
 * `stack demo.MathGame primeFactors` 打印方法调用堆栈。
 * `stack demo.MathGame primeFactors 'params[0]<0' -n 2` 根据参数过滤，限制执行两次。
 * `stack demo.MathGame primeFactors '#cost>5'` 根据耗时过滤。
18. `tt`: TimeTunnel 时空隧道，记录下方法调用时的现场日志（入参、出参、返回值）等，方便后续模拟调用。
 * `tt -t com.sun.xiaotian.blogger.web.FileInfoController getContentByFilePath`: 记录方法的调用日志。
 * `tt -t -n com.sun.xiaotian.blogger.web.FileInfoController getContentByFilePath`: 记录方法的调用日志 ` 记录三次，方法调用量比较大时使用。、
 * `tt -t *Test print params.length==1` 方法重载的情况下，只记录参数长度为一的方法执行记录。
 * `tt -t *Test print 'params[1] instanceof Integer'` 方法重载的情况下，只记录参数类型为指定类型的方法执行记录。
 * `tt -t *Test print params[0].mobile=="13989838402"` 方法重载的情况下，只记录参数值为指定值的的方法执行记录。
 * `tt -l` 查看记录的执行日志。
 * `tt -s 'method.name=="getContentByFilePath"'` 查找指定方法名字的记录。
 * `tt -i 1000` 查看调用信息，非常详细。
 * `tt -i 1000 -p` 使用记录的日志重新调用一次， 可以指定调用次数、调用间隔等参数。

19. `options` 设置 `Arthas` 选项，设置属性 `options json-format true`。
 * `unsafe` 是否可以对系统级别的类进行增强，慎重使用，默认 `false`。
 * `dump` 是否支持被增强的类 `dump` 到外部文件中。默认 `false`，如果打开则会 dump 到 `application-directory/arthas-class-dump`  目录。
 * `json-format` 是否支持 json 序列化输出。默认 `false`，开启之后回打印实际的返回值。
 * `disable-sub-class` 是否禁用字类匹配，默认 `false` 默认关闭。打开之后不会匹配字类，缩小匹配范围。
 * `batch-re-transform` 是否支持对匹配到的类批量进行 `retransform` 操作。默认 `true`。
 * `debug-for-asm` 打印 ASM 相关的调试信息，默认 `false`。
 * `save-result` 是否开启执行结果存日志功能，默认 `false`。打开之后所有的命令执行结果都会保存到 `~/logs/arthas-cache/result.log` 中。
 * `job-timeout` 异步后台任务的默认超时时间。超过时间任务自动停止。时间格式: `1d 2h 3m 25s -> 天 小时 分 秒`。
20. `pwd` 返回当前工作目录。
21. `cat` 查看文件内容。

#### 下载及启动 
1. 下载和使用    

		# 下载   
		wget https://alibaba.github.io/arthas/arthas-boot.jar
		# 启动   
		java -jar arthas-boot.jar --target-ip 0.0.0.0

	

