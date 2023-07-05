时间：2023-06-29 18:24:24

参考：

1. [深入理解浏览器Cookie](https://github.com/huzhao0316/articals/wiki/%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3%E6%B5%8F%E8%A7%88%E5%99%A8Cookie)
1. [Http Cookies 中 Max-age 和 Expires 有什么区别？](https://jiapan.me/2017/cookies-max-age-vs-expires/)

## HTTP Cookie

`Cookie` 设计用于存储客户端和服务端交互时的会话状态信息。

`Cookie` 存储在浏览器中，当浏览器发起到服务端请求的，会根据 `Domain` 和 `Path` 共同确定是否发送Cookie的服务端。

如果 `Cookie` 设置 `Secure` 属性，只有请求是 `Https` 请求的时候会发送 `Cookie`。

如果到了 `Cookie` 已经过期，则请求的时候不会带上该 `Cookie`。

如果设置了 `HttpOnly` 属性，则客户端没有修改该 `Cookie` 的权限。

### Cookie 属性的作用

|字段|含义|
|:-|:-|
|Name|名字|
|Value|值|
|Path|请求路径，和Domain共同确定，该Cookie是否发送给服务端|
|Domain|所属的域，如`.sunfeilong.com` `note.sunfeilong.com`|
|Max-Age|距离过期还剩余多少秒。IE不支持，其余浏览器支持。**不推荐使用**|
|Expires|过期日期。**推荐使用**|
|Size|Cookie 的大小。|
|HttpOnly|控制客户端是否可以编辑该Cookie。|
|Secure|安全性，设置该属性之后只有一HTTPS请求会带上该Cookie。|

### 一次设置 Cookie 的记录

只有 `Set-Cookie: tal_token=1; Path=/; Domain=sunfeilong.com; Expires=Sat, 15 Jul 2023 02:37:29 GMT; HttpOnly` 这个Cookie会存储到浏览器中。

```shell
➜  test curl -I http://www.sunfeilong.com:8888/echo
HTTP/1.1 200 OK
Set-Cookie: tal_token=1; Path=/; Domain=sunfeilong.com; Expires=Sat, 15 Jul 2023 02:37:29 GMT; HttpOnly
Set-Cookie: tal_token=2; Path=/; Domain=note.sunfeilong.com; Expires=Sat, 15 Jul 2023 02:37:29 GMT; HttpOnly
Set-Cookie: tal_token=3; Path=/; Domain=aaaa.sunfeilong.com; Expires=Sat, 15 Jul 2023 02:37:29 GMT; HttpOnly; Secure
Set-Cookie: tal_token=3; Path=/; Domain=aaaa.sunfeilong.com; Max-Age=1689388649; HttpOnly; Secure
Date: Wed, 05 Jul 2023 02:37:29 GMT
Content-Length: 6
Content-Type: text/plain; charset=utf-8
```

### 有 Cookie 之后发送请求

```shell
curl 'http://www.sunfeilong.com:8888/echo' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,zh-TW;q=0.7' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Cookie: tal_token=1' \
  -H 'Pragma: no-cache' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1' \
  --compressed \
  --insecure
```



