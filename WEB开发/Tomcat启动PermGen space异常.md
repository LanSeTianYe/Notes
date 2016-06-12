## 异常描述
Tomcat启动项目的时候，出现 `java.lang.OutOfMemoryError: PermGen space` 的错误.
## 解决办法
1. IDEA
在启动配置的  `VM options` 中添加 

        -Xms512m -Xmx1024m -XX:PermSize=128M -XX:MaxPermSize=256m
2. eclipse
在 window->Preferences->Tomcat->JVM Settings 中添加JVM参数如下即可： 

		-Xms128M -Xmx512M -XX:PermSize=128M -XX:MaxPermSize=256M 
