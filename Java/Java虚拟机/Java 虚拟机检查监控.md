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

### 使用  

1. 下载和使用    

		# 下载   
		wget https://alibaba.github.io/arthas/arthas-boot.jar
		# 启动   
		java -jar arthas-boot.jar --target-ip 0.0.0.0   