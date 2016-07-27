日期：2016-7-27 21:07:38  
参考文章：[use Quartz in Spring Boot](http://samchu.logdown.com/posts/297038-use-quartz-in-spring-boot)  
参考项目：[spring-boot-quartz-demo](https://github.com/davidkiss/spring-boot-quartz-demo/blob/master/pom.xml)


## 遇到的问题
由于shrio依赖了1.6版本的quartz，自己引入的版本是2.2.1，项目Spring加载的时候加载了1.6版本的，所以报了下面的错误：

	代码后面补上

## 具体过程

参考文章（非常好的一篇文章）：[use Quartz in Spring Boot](http://samchu.logdown.com/posts/297038-use-quartz-in-spring-boot)  
