时间：2023-04-26 11:27:27

参考：

1. 《HTTP 权威指南》 David Gourley , Brian Totty , Marjorie Sayer , Sailu Reddy , Anshu Aggarwal (作者) 陈涓 , 赵振平 (译者)

## HTTP 状态码

HTTP状态码是一个规范，HTTP服务器需要根据规范返回状态码，方便其他人排查和定位错误。

### 200

状态吗2XX表示请求处理成功。
|状态码|含义|
|::|::|
|200 OK|处理成功|

```
✗ curl -I https://note.sunfeilong.com
HTTP/1.1 200 OK
Server: nginx/1.18.0
Date: Wed, 26 Apr 2023 03:34:45 GMT
Content-Type: text/html
Content-Length: 227091
Last-Modified: Fri, 31 Mar 2023 10:03:52 GMT
Connection: keep-alive
ETag: "6426b008-37713"
Accept-Ranges: bytes
```

### 300

状态吗3XX表示重定向。

|状态码|含义|
|::|::|
|301 Moved Permanently|永久搬离，URL已经移走，响应中应该包含一个Location URL表示资源的新位置。|
|302 Found|已找到，请求的资源被临时分配到新的URL时返回，在 Loaction 中返回新的位置。|

```shell
✗ curl -I http://note.sunfeilong.com 
HTTP/1.1 301 Moved Permanently
Server: nginx/1.18.0
Date: Wed, 26 Apr 2023 03:33:58 GMT.
Content-Type: text/html
Content-Length: 169
Connection: keep-alive
Location: https://note.sunfeilong.com/
```

```
✗ curl -v t.xiwang.com/s/JpYcYQ
*   Trying 123.56.30.195:80...
* Connected to t.xiwang.com (123.56.30.195) port 80 (#0)
> GET /s/JpYcYQ HTTP/1.1
> Host: t.xiwang.com
> User-Agent: curl/7.85.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 302 Found
< Content-Type: text/html; charset=utf-8
< Location: https://bcc.xiwang.com/#21
< Date: Wed, 26 Apr 2023 03:47:50 GMT
< Content-Length: 49
< 
<a href="https://bcc.xiwang.com/#21">Found</a>.

* Connection #0 to host t.xiwang.com left intact
```



### 400

状态吗4XX表示客户端错误。

|状态码|含义|
|::|::|
|400 Bad Request|坏请求，客户端发送了一条异常请求|
|401 Unauthorized|未授权|
|403 Forbidden|服务端拒绝了客户端的请求|
|404 Not Found|未找到，服务器无法找到所请求的URL|
|405 Method Not Allowed|客户端使用不允许使用的请求方法，如用GET请求调用只支持POST请求的服务时返回|
|408 Request Timeout|请求超时，客户端发送的请求求耗费太长时间，服务端可以返回该响应码并关闭连接|

### 500

状态码5XX表示服务端错误。

|状态码|含义|
|::|::|
|500 Internal Server Error|服务器内部错误，服务器处理请求的过程中出现一个错误（内存地址越界、空指针等），导致服务器无法继续处理请求。|
|502 Bad Gateway|网关错误，网关请求服务器，在网关设置的超时时间之内服务器中断请求，即没有争正常返回数据。|
|504 Gateway Timeout|网关超时，网关请求服务器，到了网关设置的超时时间之后服务器仍然没有返回数据。|