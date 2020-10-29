时间：2020-10-29 15:24:24

## HTTP 协议


下面是 `curl -v www.baidu.com` 命令的输出。

```
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

### 请求方法

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

### 请求或响应头

用于传输除请求或响应数据之外的一些数据。 `>` 表示请求 `<` 表示响应。

|名字|<>|含义|举例|作用|
|::|::|--|--|--|
|Host|<>|请求的域名，主机地址。|Host: www.baidu.com||
|User-Agent|>|客户端类型|User-Agent: curl/7.29.0|标识请求客户端类型|
|Connection|>|保持连接，不主动关闭连接|Connection: keep-alive|复用连接，减少创建连接的开销|
|Content-Length|<>|请求数据长度|Content-Length: 2381||
|Content-Encoding|<>|数据压缩方式|Content-Encoding: gzip||
|Content-Length|<>|数据类型|Content-Type: text/html||
|If-Modified-Since|>|资源在指定时间之后没有变更过，则返回 304，Not Modified。|If-Modified-Since: Thu,12 Jul 2020 07:30:00 GMT|避免多次请求相同的数据|
|Accept|>|客户端可以接收数据类型|Accept: image/avif,image/webp,image/apng,image/*,*/*;q=0.8||
|Accept-Encoding|>|客户端可以接收的压缩格式|Accept-Encoding: gzip, deflate, br||
|Accept-Language|>|客户端可以接收的语言类型|Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,zh-TW;q=0.7||
|Set-Cookie|<|Cookie内容|Set-Cookie: dwf_sg_task_completion=False; Domain=developer.mozilla.org; expires=Sat, 28 Nov 2020 08:03:18 GMT; Max-Age=2592000; Path=/; Secure|记录状态信息，区分客户端|
|Cookie|>|客户端的Cookie| Cookie: JSESSIONID=31212121;_ga=GA1.3.;_gid=GA1.3.107;       |客户端标识|
|Server|<|服务器名字|Server:nginx|判断服务器类型|

