##
日期：2016-11-11 07:48:22  
参考文章：  
1.  [A Guide to Designing and Building RESTful Web Services with WCF 3.5](https://msdn.microsoft.com/en-us/library/dd203052.aspx)
##


#### RESTful 是什么？

RESTful 通俗的来说就是 WEB 服务URL命名的一种规范，实现这种规范的目的是：当我们需要调用一个服务的时候，我们知道了资源就可以根据GET、PUT、DELETE和POST等方法以及命名规范推断出需要调用的服务的URL，从而对资源进行操作，减少对文档的需求。

RESTful 比较核心的地方是要实现 Hypermedia ，服务器每个服务返回的数据都应包含，与这个服务相关的其他服务的 URL 这样，当服务的获取这完成中操作后，就能从返回的数据找到后面需要请求的服务。

幂等性： 同一个操作执行多次之的结果相同。如 get、put、delete、head 和 options 等。 post不具有幂等性（按标准的方法定义实现的方法）。


##  设计 RESTful Service

