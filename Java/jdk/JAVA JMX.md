时间：2019/3/12 13:10:46  

参考：

1. [Java Management Extensions](https://en.wikipedia.org/wiki/Java_Management_Extensions "Java Management Extensions")
2. [从零开始玩转JMX(一)——简介和Standard MBean](https://blog.csdn.net/u013256816/article/details/52800742)

## JMX    

### 简介
  
JMX 全称 Java Management Extensions, Java 的一项技术，提供工具管理和监控应用程序，系统对象、设备和面向服务的网络等。

在虚拟机内部，根据规范创建对应的Bean，暴漏一些方法，在虚拟机外部可以通过 `web` `jconsole` 等方式调用暴露的方法，达到变更类属性或者变更类参数的目的。
