## 异常描述
Tomcat启动项目的时候，出现 `java.lang.OutOfMemoryError: PermGen space` 的错误.
## 解决办法
1. IDEA
在启动配置的  `VM options` 中添加 

        -Xms512m -Xmx1024m -XX:PermSize=128M -XX:MaxPermSize=256m
2. eclipse
在 window->Preferences->Tomcat->JVM Settings 中添加JVM参数如下即可： 

		-Xms128M -Xmx512M -XX:PermSize=128M -XX:MaxPermSize=256M 
3. tomcat 解决方案，在 `catalina.bat` 的 setlocal下面添加，(主要是后面的两个参数)

        setlocal
        set "JAVA_OPTS=%JAVA_OPTS% -Dfile.encoding=GBK -Djava.net.preferIPv4Stack=true -Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Duser.timezone=GMT+08 -Xmx1024m -XX:MaxPermSize=256m"
