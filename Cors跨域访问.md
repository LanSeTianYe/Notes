## 信息
参考文章：  

1. [跨域资源共享 CORS 详解](http://www.ruanyifeng.com/blog/2016/04/cors.html)  
2. [實作 Cross-Origin Resource Sharing (CORS) 解決 Ajax 發送跨網域存取 Request](https://blog.toright.com/posts/3205/%E5%AF%A6%E4%BD%9C-cross-origin-resource-sharing-cros-%E8%A7%A3%E6%B1%BA-ajax-%E7%99%BC%E9%80%81%E8%B7%A8%E7%B6%B2%E5%9F%9F%E5%AD%98%E5%8F%96-request.html)
3. [AJAX POST&跨域 解决方案 - CORS](http://www.cnblogs.com/Darren_code/p/cors.html)
4. [SpringMvc+AngularJS通过CORS实现跨域方案](http://www.tuicool.com/articles/umymmqY)
5. [ Spring Boot 过滤器、监听器](http://blog.csdn.net/catoop/article/details/50501688)


## Cros跨域访问

#### 简介

CORS是一个W3C标准，全称是"跨域资源共享"（Cross-origin resource sharing）。它允许浏览器向跨源服务器，发出XMLHttpRequest请求，从而克服了AJAX只能同源使用的限制。  

CORS需要浏览器和服务器同时支持。目前，所有浏览器都支持该功能，IE浏览器不能低于IE10。  

整个CORS通信过程，都是浏览器自动完成，不需要用户参与。对于开发者来说，CORS通信与同源的AJAX通信没有差别，代码完全一样。浏览器一旦发现AJAX请求跨源，就会自动添加一些附加的头信息，有时还会多出一次附加的请求，但用户不会有感觉。  

因此，实现CORS通信的关键是服务器。只要服务器实现了CORS接口，就可以跨源通信。

#### 配置
1. 允许通过的站点

        response.setHeader("Access-Control-Allow-Origin", "http://127.0.0.1:8020");
2. 允许的请求方法

        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
3. 来指定本次预检请求的有效期，单位毫秒，在有效期内不会再次发送请求进行预检。

        response.setHeader("Access-Control-Max-Age", "3600");
4. 允许访问的请求头信息

        response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
5. 是否允许发送 Cookie

    * 服务器端
    
        ```java
        //允许访问的域名必须是确定的
        response.setHeader("Access-Control-Allow-Origin", "http://127.0.0.1:8020");
        response.setHeader("Access-Control-Allow-Credentials", "true");
        ```
    
    * 前台页面，ajax请求添加如下属性
    
        ```xml
        xhrFields: {
        withCredentials: true
        },
        ```


#### 实现
只需要在服务器端允许跨域访问即可，前台数据数据请求不需要任何特别的设置。  

##### 服务器端

只需要增加一个拦截器，然后在请求头部添加允许跨域访问的配置即可

java代码：

```java
import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CrosFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        String origin = ((HttpServletRequest) servletRequest).getHeader("Origin");
        if (StringUtils.isEmpty(origin)) {
            origin = "";
        }
        logger.debug(String.format("allowOrigins: 127.0.0.1.* or localhost* or %s, access origin: %s", allowOrigins, origin));

        //本地域名通过请求,配置文件指定的域名也允许通过
        if(origin.contains("127.0.0.1") || origin.contains("localhost") || allowOrigins.contains(origin)) {
            response.setHeader("Access-Control-Allow-Origin", origin);
        }
        //允许跨域的请求类型
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
        //指定本次预检请求的有效期,单位为秒,在此期间不用发出另一条预检请求
        response.setHeader("Access-Control-Max-Age", "3600");
        //允许cookie
        response.setHeader("Access-Control-Allow-Credentials", "true");
        //允许所有类型的请求头
        response.setHeader("Access-Control-Allow-Headers", "*");

        filterChain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {

    }
}
```

web.xml 添加如下配置


```xml
<filter>
    <filter-name>cors</filter-name>
    <filter-class>*.*.CrosFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>cors</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

##### 前端访问

```javascript
var host = "http://123.123.123.123:8080";

function testGetAndHaveOneParam() {
    //参数
    var param = {
        name: '小明'
    }
    //请求
    jQuery.ajax({
        type: "GET",
        url: host + '/ajaxTest/testGetAndHaveOneParam',
        data: param,
        dataType: 'json',
        success: function (data) {
            console.log('testGetAndHaveOneParam' + JSON.stringify(data));
        },
        error: function (error) {
            console.log(error);
        }
    });
}
```

