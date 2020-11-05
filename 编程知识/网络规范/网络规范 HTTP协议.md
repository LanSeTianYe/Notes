时间：2020-10-29 15:24:24

参考：

1. 《图解HTTP》 上野 宣 (作者) 于均良 (译者)
2. 《HTTP 权威指南》  David Gourley , Brian Totty , Marjorie Sayer , Sailu Reddy , Anshu Aggarwal (作者) 陈涓 , 赵振平 (译者)

## HTTP 协议

下面是 `curl -v www.baidu.com` 命令的输出。

```shell
* About to connect() to www.baidu.com port 80 (#0)
*   Trying 180.101.49.11...
* Connected to www.baidu.com (180.101.49.11) port 80 (#0)
> GET / HTTP/1.1
> User-Agent: curl/7.29.0
> Host: www.baidu.com
> Accept: */*
>
< HTTP/1.1 200 OK
< Accept-Ranges: bytes
< Cache-Control: private, no-cache, no-store, proxy-revalidate, no-transform
< Connection: keep-alive
< Content-Length: 2381
< Content-Type: text/html
< Date: Thu, 29 Oct 2020 07:21:03 GMT
< Etag: "588604c8-94d"
< Last-Modified: Mon, 23 Jan 2017 13:27:36 GMT
< Pragma: no-cache
< Server: bfe/1.0.8.18
< Set-Cookie: BDORZ=27315; max-age=86400; domain=.baidu.com; path=/
<
<!DOCTYPE html>
</html>
* Connection #0 to host www.baidu.com left intact
```

### HTTP请求方法

|名字|描述|
|::|::|
|GET|获取资源|
|POST|发送数据|
|PUT|上传文件|
|HEAD|获取报文首部|
|DELETE|删除文件|
|OPTIONS|查询支持的方法|
|TRACE|追踪路径|
|CONNECT|使用隧道协议连接代理|

### HTTP 状态码

服务端响应码，用于标识服务端处理结果。状态码是规范，服务端依据规范返回即可。

|响应码|名字|描述|
|::|::|--|
|1XX||信息|
|100|Continue|继续，收到请求的起始部分，客户端应继续请求|
|101|Switching  Protocols|协议切换，服务端正根据客户端要求将协议切换成Update首部列出的协议|
|2XX||成功|
|200|OK|服务器已成功处理请求|
|201|Created|已创建，对那些要服务器创建对象的请求来说，资源一创建完毕|
|202|Accepted|已接受，请求已接收，但服务器尚未处理|
|203|Non-Authoritative Infomation|非权威信息，服务器已将事务处理成功，只是实体首部包含的信息不是来自 原始服务器，而是来自资源副本。|
|204|No Content|没有内容，响应报文包含首部和状态行，但不包含实体的主题内容|
|205|Reset Content|重置内容，表示浏览器应该重置当前页面上的所有HTML标签|
|206|Partial Content|部分内容，部分请求成功|
|3XX||重定向|
|300|Multiple Choices|多项选择，客户端请求实际指向了多个资源的URL，用户可以选择显示的内容|
|301|Moved Permanently|永久搬离，URL已经移走，响应中应该包含一个Location URL表示资源的新位置|
|302|Found|已找到，请求的资源被临时分配到新的URL时返回，在 Loaction 中返回新的位置|
|303|See Other|参见其他，高呼客户端一个新的URL，新的URL在Location中返回。|
|304|Not Modified|未修改，客户端可以他们所包含的请求首部发起条件请求，说明资源没有发生过变化|
|305|Use Proxy|使用代理，必须使用代理访问，代理的位置在Location中返回|
|307|Temporary Redirect|临时重定向，类似于301，但客户端应该使用Location给出的URL对子资源进行重定向|
|4XX||客户端错误|
|400|Bad Request|坏请求，告诉客户端它发送了一条异常请求|
|401|Unauthorized|未授权，和适当的首部一起返回，当客户端访问需要授权的资源之前，请它进行身份认证|
|403|Forbidden|禁止，服务器拒绝了请求|
|404|Not Found|未找到，服务器无法找到所请求的URL|
|405|Method Not Allowed|不允许使用的请求方法，如不支持GET请求等|
|408|Request Timeout|请求超时，客户端完成请求耗费太长时间，服务端可以返回该响应码并关闭连接|
|5XX||服务器错误|
|500|Internal Server Error|内部服务器错误，服务器遇到一个错误使其无法为请求提供服务|
|501|Not Implemented|未实现，服务器无法满足客户端请求的某个服务|
|502|Bad Gateway|网关故障，作为网关或代理的服务器遇到了来自响应链中上游服务的无效响应|
|503|Service Unavailable|未提供该服务，服务暂时不可用|
|504|Gateway Timeout|网关超时，类似于408，但响应来自网关或代理，此网关或代理在等待另外一台服务器响应的时候出现超时|
|505|HTTP Version Not Supported|服务器收到的情趣是它不支持的或不愿处理的版本|

### HTTP请求或响应头

用于传输除请求或响应数据之外的一些数据。 注：`>` 表示请求 `<` 表示响应。

> 注：对于请求头或者响应头出现的重复项，不同的浏览器处理方式不一样，需要注意不要出现重复，以免出现在不同浏览器下表现出现差异。

常用请求头：

|名字|<>|含义|举例|作用|
|::|::|--|--|--|
|Date|<>|请求或响应创建时间|Date: Thu, 29 Oct 2020 07:21:03 GMT||
|Cache-Contorl|<>|控制是否缓存|Cache-Contorl: private, max-age=0，no-cache|控制缓存服务器是否缓存|
|Content-Length|<>|请求数据长度|Content-Length: 2381||
|Content-Encoding|<>|数据压缩方式|Content-Encoding: gzip||
|Content-Type|<>|数据类型|Content-Type: text/html||
|Transfer-Encoding|<>|分块传输编码格式|Transfer-Encoding: chunked||
|Host|>|请求的域名，主机地址。|Host: www.baidu.com|同一台服务器部署多个服务时，使用HOST区分请求到那个服务|
|Accept|>|客户端可以接收数据类型|Accept: image/avif,image/webp,image/apng,image/*,*/*;q=0.8||
|Accept-Charset|>|客户端可以接收的字符集|||
|Accept-Encoding|>|客户端可以接收的压缩格式|Accept-Encoding: gzip, deflate, br||
|Accept-Language|>|客户端可以接收的语言类型|Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,zh-TW;q=0.7||
|Max-Forward|>|最大转发次数|Max-Forward: 10||
|User-Agent|>|客户端类型|User-Agent: curl/7.29.0|标识请求客户端类型|
|Connection|>|管理持久连接。控制代理服务器不转发的首部字段。|Connection: keep-alive  Connection: Token|复用连接，减少创建连接的开销|
|Keep-Alive|>|保持连接参数|Keep-Alive:timeout:15,max=100||
|If-Match|>|条件请求，服务端判断条件满足时执行|If-Match: "1234" -> 当 ETAG = “1234”时候处理请求||
|If-Modified-Since|>|资源在指定时间之后没有变更过，则返回 304，Not Modified。|If-Modified-Since: Thu,12 Jul 2020 07:30:00 GMT|避免多次请求相同的数据|
|Referer|>|请求原始URI。请求一个页面，该也页面加载的其它资源的 Referer 都是该页面的的URI| Referer: https://blog.sunfeilong.com/                        ||
|Cookie|>|客户端的Cookie| Cookie: JSESSIONID=31212121;_ga=GA1.3.;_gid=GA1.3.107;       |客户端标识|
|Range|>|范围请求|Range:bytes=5001-10000|获取部分内容|
|Set-Cookie|<|Cookie内容|Set-Cookie: dwf_sg_task_completion=False; Domain=developer.mozilla.org; expires=Sat, 28 Nov 2020 08:03:18 GMT; Max-Age=2592000; Path=/; Secure|记录状态信息，区分客户端|
|ETag|<|资源标识|ETag: "5f9fe0ef-34f27"|判断文件是否更新|
|Last-Modified|<|文件上次变更时间|Last-Modified: Mon, 02 Nov 2020 10:35:27 GMT||
|Location|<|重定向地址||浏览器收到该请求后会重定向到该地址|
|Server|<|服务器名字|Server:nginx|判断服务器类型|
|Content-Range|<|响应数据范围|Content-Range: bytes 5001-10000/10000||
|Vary|<|控制缓存，当请求和本地缓存的Vary值相同时直接返回|Vary: Accept-Language||
|Allow|<|服务器允许的请求方法|Allow: GET,POST||
|Expires|<|资源过期时间|Expires: Mon, 02 Nov 2020 10:35:27 GMT||
|X-Frame-Options|<|控制网站内容是否可以在其它网站的Frame标签内显示|X-Frame-Options: DENY/SAMEORIGIN|防止点击劫持|
|X-XSS-Protection|<|XSS防护机制开关|X-XSS-Protection: 0/1|防止跨站脚本攻击|

### HTTP 请求报文

#### HTTP 请求报文

* 起始行：请求方法、UR和HTTP 版本I：如 `GET / HTTP/1.1`
* 首部字段：HTTP首部字段：Header信息
* 主体：请求数据

#### HTTP 响应报文

* 起始行：HTTP版本、状态码和原因：如 `HTTP/1.1 200 OK`
* 首部字段：HTTP首部字段：Header信息
* 主体：响应数据

### HTTP 媒体类型

* 文本类型: text

    * text/html

* 图片类型: image

    * image/png
    * image/gif

* 视频类型: video

    * video/mp4
    * video/quicktime

* application

    * application/json

### URL 特殊字符

URL使用US-ASCII编码表示，[US-ASCII](http://www.columbia.edu/kermit/ascii.html) 可以表示0-126共127个字符。保留字符和其余不可表示字符需要转义。

|名字|作用|
|::|::|
|%|保留字符，转义|
|/|保留字符：路径分隔符|
|.|保留字符：路径|
|..|保留字符：路径|
|#|保留字符：分段定界符|
|?|保留字符：查询定界符|
|;|保留字符：参数分界符|
|:|保留字符：方案、主机/端口、用户/密码分界符|
|$ +|保留|
|@ & =|保留|
|{}\|\^~[]'|使用受限|
|<>"|不安全，这些字符在URL范围之外通常有特殊意义|
|0x00-0x1F,0x7F|受限，不可打印|
|>0x7F|受限，十六进制值，不在US-ASCII字符可表示范围之内|