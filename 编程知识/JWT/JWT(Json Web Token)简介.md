时间： 2017-11-21 15:39:45
参考： 

1. [https://jwt.io/introduction/](https://jwt.io/introduction/) 
2. [http://blog.leapoahead.com/2015/09/06/understanding-jwt/](http://blog.leapoahead.com/2015/09/06/understanding-jwt/) 
3. [http://blog.leapoahead.com/2015/09/07/user-authentication-with-jwt/](http://blog.leapoahead.com/2015/09/07/user-authentication-with-jwt/) 
4. [JWT-JAVA](https://github.com/auth0/java-jwt) 

##  JWT (JSON Web Token) 简介

### JWT 简介

JWT 是 Json Web Token 的简称，是一个开源标准（[RFC7519](https://tools.ietf.org/html/rfc7519)）。该标准定义了一个紧凑、自包含的安全的传输JSON数据的方法。以及数字签名机制，用于验证数据是否被更改。 

JWT由Header、Payload和Signature。Header包含使用的算法(alg)和类型(typ)等信息，Payload包含过期时间（exp）、发送者(iss)、以及自定义的数据。Signature是Header和Payload的数字签名。 

最终生成的token的格式是： `base64(Header).base64(Payload).RSA256(base64(Header).base64(Payload))`，用 `.` 分割， 依次代表Header、Payload和Signature。前两部分可以通过 base64 反编码，因此可以解析成JSON对像。最后一部分是签名，用于验证数据是否被更改。 

### 怎么用 

**用于登陆:** 客户端登陆的时候，服务器把登陆用户的信息，以Token的方式发送给客户端。然后客户端每次请求都带上token，服务器验证和解析token，就能确定是谁发送的请求，可以替代传统的Session存储登陆信息的方式。

### JWT-JAVA 使用 

```java
private final Algorithm algorithm;

public JwtTokenManager() throws UnsupportedEncodingException {
    algorithm = Algorithm.HMAC256("secret");
}

public String getToken() {
    String token;
    try {
		//签名，指定发送发，包含name，age等信息。
        token = JWT
                .create()
                .withIssuer("xiaotian")
                .withClaim("name", "user1")
                .withClaim("age", 20)
                .sign(algorithm);
    } catch (JWTCreationException e) {
        throw new XiaoTianException("创建token失败", e);
    }
    return token;
}

public void verify(String token) {
    JWTVerifier verifier = JWT.require(algorithm).withIssuer("xiaotian").build();
	//认证失败的时候会抛出异常
    DecodedJWT decodedJWT = verifier.verify(token);
}

public void decode(String token) {
	//反编码 token
    DecodedJWT decodedJWT = JWT.decode(token);
}
```

## 应用场景 

1. 认证：客户端用户完成登陆之后，把用户信息（如Id，name）放在Playlaod部分，把生成的token返回给客户端，然后客户端每次请求都带上这个token，服务器通过验证和解析token里的用户信息就能确定用户。

2. 单点登陆：使用token作为登陆口令，token存储在客户端，token包含用户信息，服务器解析token就能确定用户，对于分布式系统，避免了Session存储信息带来的Session同步问题。 

3. 数据传递： 把需要传递的信息放在Payload部分，签名机制可以确保消息的来源，以及消息是否被篡改。 

## 优点 

1. 以JSON以及Base64编码的格式存储数据更节省空间。
2. JSON数据的解析放在服务器端，减轻客户端负担。 
3. token数据存储在客户端，减轻服务器数据存储压力。

## 缺点 

1. token被攻击者截取，攻击者何以使用token进行对应用户的操作，通过使用 https 可以避免。 
