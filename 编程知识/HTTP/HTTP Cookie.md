时间：2023-06-29 18:24:24

参考：

1. [深入理解浏览器Cookie](https://github.com/huzhao0316/articals/wiki/%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3%E6%B5%8F%E8%A7%88%E5%99%A8Cookie)
1. [Http Cookies 中 Max-age 和 Expires 有什么区别？](https://jiapan.me/2017/cookies-max-age-vs-expires/)

## HTTP Cookie

### Cookie 属性的作用

|字段|含义|
|::|::|
|Name|名字|
|Value|值|
|Domain|所属的域 `.sunfeilong.com` `note.sunfeilong.com`|
|Max-Age|距离过期还剩余多少秒。IE不支持，其余浏览器支持。不推荐使用|
|Expires|过期日期，推荐使用|
|Path|请求路径，和域共同确定是否发送Cookie给服务端|
|Size|Cookie大小|
|HttpOnly|设置该属性后客户端不可以编辑该Cookie|
|Secure|设置该属性后，只有HTTPS请求会发送该属性|





