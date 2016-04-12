下载地址：  
1. [apache-cassandra-3.4](http://pan.baidu.com/s/1hsLcYsW)
****
### windows安装：
1. 下载并解压。
2. cmd切换到bin目录执行 `cassandra run` 即可启动服务。

注意: 3.4版本的必需使用 jdk1.8，所以换件变量里面的JAVA_HOME要设置成1.8的路径，buRn的话会报下面的错误。

		Exception in thread "main" java.lang.UnsupportedClassVersionError: org/apache/cassandra/service/CassandraDaemon : Unsupported major.minor version 51.0
			at java.lang.ClassLoader.defineClass1(Native Method)
			at java.lang.ClassLoader.defineClass(ClassLoader.java:634)
			at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
			at java.net.URLClassLoader.defineClass(URLClassLoader.java:277)
			at java.net.URLClassLoader.access$000(URLClassLoader.java:73)
			at java.net.URLClassLoader$1.run(URLClassLoader.java:212)
			at java.security.AccessController.doPrivileged(Native Method)
			at java.net.URLClassLoader.findClass(URLClassLoader.java:205)
			at java.lang.ClassLoader.loadClass(ClassLoader.java:321)
			at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:294)
			at java.lang.ClassLoader.loadClass(ClassLoader.java:266)
			Could not find the main class: org.apache.cassandra.service.CassandraDaemon. Program  
***
###  windows使用 `cqlsh`
1. 安装 `python 2.7` 版本。
2. 配置 `python 目录` 到环境变量(path)。
2. cmd切换到bin目录执行 `cqlsh`


