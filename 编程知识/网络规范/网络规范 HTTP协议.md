时间：2020-10-29 15:24:24

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

### HTTP 状态码

服务端响应码，用于标识服务端处理结果。状态码是规范，服务端依据规范返回即可。

|响应码|名字|描述|
|::|::|--|
|1XX||处理中。|
|2XX||处理成功。|
|200|OK|处理成功时返回。|
|204|No Content|处理成功但没有数据返回时返回。|
|206|Partial Content|客户端执行范围请求时返回。|
|3XX||需要进行附加操作以完成请求，一般指重定向。|
|301|Moved Permanently|请求的资源被永久分配到新的URI时返回，在 Loaction 中返回新的位置。|
|302|Found|请求的资源被临时分配到新的URI时返回，在 Loaction 中返回新的位置。|
|304|Not Modified|资源没有改变，可以使用客户端缓存是返回。|
|4XX||服务器无法处理请求。|
|400|Bad Request|请求报文存在语法错误。|
|401|Unauthorized|需要认证或认证失败。|
|403|Forbidden|禁止访问。|
|404|Not Found|无法找到资源。|
|5XX||服务器处理请求出错。|
|500|Internal Server Error|服务器内部错误。|
|503|Service Unavailable|服务暂时不可用|

### HTTP 请求报文

#### HTTP 请求报文

* 请求方法、UR和HTTP 版本I：如 `GET / HTTP/1.1`
* HTTP首部字段：Header信息

#### HTTP 响应报文

* HTTP版本、状态码和原因：如 `HTTP/1.1 200 OK`
* HTTP首部字段：Header信息

### HTTP 媒体类型