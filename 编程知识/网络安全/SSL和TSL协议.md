时间：2017-05-17 10:31:38 

参考： 

1. [Transport Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security)
2. [图解SSL/TLS协议](http://www.ruanyifeng.com/blog/2014/09/illustration-ssl.html)
3. [根证书、服务器证书、用户证书](https://www.nginx.cn/5559.html)

## SSL/TSL简介

* SSL（Secure Socket Layer）安全套接字 。 
* TSL（Transport Layer Security）传输层安全。

    SSL是Netscape开发的专门用户保护Web通讯的，TLS是由IETF指定的一种新的协议，建立在SSL基础之上。SSL和TSL是同一事物的不同阶段的称呼。

    发展过程（后面的版本基于前面的版本）： `SSL1.0->SSL2.0->SSL->3.0->TSL1.0->TSL1.1->TSL1.3` 


## 协议过程

1. 客户端发送握手信息给服务器，包含以下信息

    * 客户端支持的加密算法
    * 随机数（发送给服务器）

2. 服务器响应客户端，发送下面信息

    * 一套加密算法：从客户端支持的机密算法中选取
    * 随机数 （发送给客户端，和客户端发送的不是同一个）
    * 发送证书链

3. 客户端根据证书链验证证书的合法性，发送下面内容给服务器

    * 服务器公钥加密过的随机数（encrypted-pre-master secrt）：和上面两个随机数不是同一个。

4. 服务器解密随机数，使用三个随机数作为对称加密算法的秘钥,用于加密传输数据，之后响应客
户端：

    * 可以进行通信。 

5. 客户端用三个随机数组成的秘钥加密数据，用公钥加密sessionId，发送给服务器

6. 服务器用非对称算法解密sessionId，用对称加密算法数据。

7. 回到第五步 
