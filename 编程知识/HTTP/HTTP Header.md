时间：2023-07-03 15:15:15

参考：



## HTTP Request Header

|名称|含义|
|::|::|
|Host|请求要发送到的服务器的域名。|
|Origin|请求的来源（协议、主机、端口)。|
|X-Forwarded-For|请求经过的代理服务器地址，第一个是客户端，越靠后面，离客户端越远。格式 `X-Forwarded-For: <client>, <proxy1>, <proxy2>`|
|Referer|当前请求页面的来源页面的地址。|
|Cookie|页面的Cookie信息。|
|User-Agent|标识用户代理软件的应用类型、操作系统、软件开发商以及版本号。|



## HTTP Response Header

|名称|含义|示例|
|::|::|--|
|Cache-Control|控制资源缓存|public, max-age=36000|
|Etag|资源的版本|66a1cb85-8e78|
|Content-Encoding|压缩算法|gzip|