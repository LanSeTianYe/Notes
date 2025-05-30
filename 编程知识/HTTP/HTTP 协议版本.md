**时间:** 2025-05-26 15:56:00

**参考：**

* HTTP/2 in Action 中文版
* grok

## HTTP 协议版本

|功能|HTTP/0.9|HTTP/1.0|HTTP/1.1|HTTP/2.0|HTTP/3.0|
|:----:|:--|:--|:--|:--|:--|
|年份|1991|1996|1997|2015|2022|
|请求类型|GET|GET、 POST、 HEAD|GET、POST、HEAD<br/>PUT、PATCH、<br/>OPTIONS、DELETE|✅|✅|
|版本|❎|✅|✅|✅|✅|
|状态码|❎|✅|✅|✅|✅|
|头部|❎|✅|✅|✅|✅|
|Cookie|❎|✅未标准化|✅标准化支持|✅|✅|
|Keep-Alive|❎|✅默认不启用|✅默认启用|✅|✅|
|管道机制|❎|❎|✅存在缺陷|✅多路复用|✅QUIC|
|Host 头部|❎|❎不必需|✅必须包含|✅|✅|
|多路复用|❎|❎|❎|✅|✅|
|服务器推送|❎|❎|❎|✅|✅|
|安全性|❎|❎|✅TLS（可选）|✅要求 TLS 1.2+|✅|
|协议类型|文本|文本|文本|二进制|二进制|
|传输层协议|TCP|TCP|TCP|TCP|UDP|

**多路复用**：`HTTP/2.0` 开始支持多路复用，即在一个链接上发送和接受多个请求。通过在一个链接上建立多个流（Stream） 方式实现。 `HTTP/1` 通过打开多个链接实现并发请求。

**服务端推送**：允许服务端向服务器发送没有请求的额外资源。比如浏览器请求了 `index.html`，服务端在发送 `index.html` **的同时**，可以把 `sytle.css` 、 `script.js` 等文件也发送给客户端。

类似于：
```
请问，可以给我这个页面吗？”答案可能是：“当然，并且这里有一些额外的资源，你在加载那个页面时会用得到。
```

**服务器发送事件**：即 `SSE (Server-Sent Events)`，是基于 `HTTP/1.0` 协议的 `KeepAlive` 的应用层扩展，通过 `text/event-stream` 内容类型实现。

### 附录

#### 有哪些网站使用了 HTTP/3.0 ？

1. `cdnjs.cloudflare.com`，用浏览器访问 [https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.52.2/min/vs/loader.js](https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.52.2/min/vs/loader.js)，在 `开发者工具 -> 网络 ->协议`里面可以看到。（又是不是）
