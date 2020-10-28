时间：2018/9/14 14:21:05   

参考：  

1. [Java中SPI机制深入及源码解析](https://cxis.me/2017/04/17/Java%E4%B8%ADSPI%E6%9C%BA%E5%88%B6%E6%B7%B1%E5%85%A5%E5%8F%8A%E6%BA%90%E7%A0%81%E8%A7%A3%E6%9E%90/)
2. [Java Service Provider Interface](https://www.baeldung.com/java-spi)

## Java SPI  

###  简介   

Java SPI (Service Provider Interface) 是 `jdk1.6` 增加的用于发现和加载接口或抽象类的实现类的机制。核心类 `ServiceLoader` 用于根据指定接口或抽象类结合 `META-INF/services/` 里的配置文件加载具体实现。  

### 怎么使用      

### JAVA SQL 框架

1. `jdk` 使用 `java.sql.Driver` 定义数据库驱动类。 

2. MySQL数据库连接器 `mysql-connector-java.jar` 实现驱动接口，创建 `META-INF/services/java.sql.Driver` 文件，文件的内容如下：

	    com.mysql.jdbc.Driver

3. 使用 `ServiceLoader` 加载接口的实现类。

		ServiceLoader<Driver> drivers = ServiceLoader.load(Driver.class); 