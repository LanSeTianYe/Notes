##  

1. 时间 ： 2017/4/10 10:27:56 

2. 参考

 * [Apache JMeter](http://jmeter.apache.org/)
 * [Selenium](http://docs.seleniumhq.org/)
 * [JProfiler](https://yq.aliyun.com/articles/276)


## 工具

### Apache JMeter
#### 简介
The Apache JMeter™ application is open source software, a 100% pure Java application designed to load test functional behavior and measure performance. It was originally designed for testing Web Applications but has since expanded to other test functions.

#### 作用
1. 测试不同类型应用、服务和协议的性能。
 * WEB-HTTP,HTTPS(Java、NodeJs、PHP、ASP.NET ...)
 * SOAP/REST WebServices
 * FTP
 * Database via JDBC (Java Data Base Connectivity)
 * [LDAP](http://baike.baidu.com/link?url=PGalnBFW6Squx3yOyDH-BIdnxA2QFUrMDY3Lx5b-L8MAL8Mh6kxAncWQwnGpjpDoYs8GSR0uMiUOAwIjut7paK) (Lightweight Directory Access Protocol)
 * Message-oriented middleware (MOM) via JMS， 通过JMS实现的面向消息流的中间件。
 * Mail-SMTP(S)、POP3(S)和IMAP(S)
 * Native commands or shell scripts。（原生命令或shell脚本）。
 * TCP
 * Java 对象。
2. 允许快速测试计划包含记录（通过浏览器或应用程序）、构造和调试的全功能测试工具。
3. 在任何兼容Java的平台上用命令行的方式进行负载测试。
4. 简单的从从流行的响应格式（HTML、JSON、XML和任何文本格式）中提取数据。
5. 完全可一直和百分之百Java实现。
6. 完全的多线程框架允许多个线程同时采集和单独的线程组同时采集不同的功能。
7. 缓存和在线分析或重播测试结果。
8. 高扩展性的核心
 * 可插拔的模块允许无限扩大的测试能力
 * 脚本支持（JSR223-compatible languages like Groovy and BeanShell）
 * 服务负载统计有几种不同的选择
 * 数据分析和可视化插件具有极大的可扩展性和个性化定制功能
 * 提供动态数据输入和数据操作功能。
 * 通过第三方开源库（Maven、Graddle和Jenkins）快速集成。

## Selenium(硒)
包含两个版本 `Selenium WebDriver`  和 `Selenium IDE`