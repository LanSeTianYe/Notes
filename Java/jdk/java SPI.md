时间：2018/9/14 14:21:05   

参考：  

1. [Java中SPI机制深入及源码解析](https://cxis.me/2017/04/17/Java%E4%B8%ADSPI%E6%9C%BA%E5%88%B6%E6%B7%B1%E5%85%A5%E5%8F%8A%E6%BA%90%E7%A0%81%E8%A7%A3%E6%9E%90/)

## Java SPI  

###  简介   

Java SPI (Service Provider Interface) 服务提供者接口，是JDK内置的一种服务提供发现机制。

设计目的：提供接口定义规范，不同厂商根据自己的需要实现接口，用户只需关心接口定义，无需关心具体的实现。 SPI 提供服务加载机制，自动加载对应实现。

### 怎么使用  

以 `java.sql.Driver` 为例：   

	<dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>5.1.25</version>
    </dependency>

1. 定义接口规范，参考 `java.sql.Driver` 类。
2. 实现接口，并在 `META-INF/services/` 创建名字为 `java.sql.Driver` 的文件，文件的内容是具体实现类：

	    com.mysql.jdbc.Driver
3. 通过 `ServiceLoader` 加载接口的实现类。

		ServiceLoader<Driver> drivers = ServiceLoader.load(Driver.class); 