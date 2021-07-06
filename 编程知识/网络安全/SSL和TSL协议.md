时间：2017-05-17 10:31:38 

参考： 

1. [Transport Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security)
2. [图解SSL/TLS协议](http://www.ruanyifeng.com/blog/2014/09/illustration-ssl.html)
3. [根证书、服务器证书、用户证书](https://www.nginx.cn/5559.html)
4. [HTTPS篇之SSL握手过程详解](https://razeencheng.com/post/ssl-handshake-detail.html)
5. [几幅图拿下HTTPS](https://mp.weixin.qq.com/s/U9SRLE7jZTB6lUZ6c8gTKg)

## SSL

### TLS 支持国密算法

TLS支持国密算法，是在TLS握手流程中增加国密算法的选项，并没有实现国密标准的SSL。

根据国内发布的 [rfc8998](https://www.rfc-editor.org/rfc/rfc8998.html)，可以把国密算法集成到TLS1.3之中，不适用于TLS1.3之前的版本。

开源实现: [BabaSSL](https://github.com/BabaSSL/BabaSSL)

###  国密SSL

双证书：

签名证书：表明身份。密钥用于签名，不应被存储，丢失时重新生成密钥对。公钥用于验证签名，需要存储（存储主要是为了验证旧密钥的签名）。

加密证书：加密数据。公钥不需要被存储，公钥丢失时重新生成密钥对，公钥用于加密数据。密钥用于解密数据，需要被存储（存储主要为了解密旧数据）。

####  [中华人民共和国密码行业标准 GM/T 0024-2014 SSL VPN 技术规范](http://www.gmbz.org.cn/main/viewfile/20180110021416665180.html) 

参考TLS1.1(RFC4346) 实现。

发布于2014-02-13，实施于2014-02-13。

开源实现：[gmsm](https://github.com/tjfoc/gmsm)

####  [中华人民共和国密码行业标准 GM/T 38636-2020 信息安全技术传输层密码协议（TLCP）](http://c.gb688.cn/bzgk/gb/showGb?type=online&hcno=778097598DA2761E94A5FF3F77BD66DA)。

定义TLS通信规范，双证书（加密证书和签名证书）模式，支持验证客户端证书。

支持客户端验证，规范定义了一个参数用于控制是否开启客户端验证。

发布于2020-04-28，实施于2020-11-01。

开源实现: [BabaSSL](https://github.com/BabaSSL/BabaSSL)

### 标准TLS

#### 密钥交换算法

1. RSA：使用`客户端随机数+服务端随机数+客户端预主密钥（经服务端公钥加密后传递给服务器）` 计算出加密密钥。如果服务端私钥泄漏之前发送的数据都会被解密（不支持向前保密）。

2. ECDHE：客户端使用服务端公钥和客户端私钥计算出加密密钥。服务端使用客户端公钥和服务端私钥计算出相同的加密密钥。最终密钥使用 `客户端随机数 + 服务端随机数 + ECDHE 算法算出的共享密钥` 计算得出。

