时间：2020-11-15 15:14:14

参考：

1. [IMPROVING PAGE SPEED: CDN VS SQUID/VARNISH/NGINX/MOD_PROXY](https://blog.matthewskelton.net/2011/12/02/improving-page-speed-cdn-vs-squid-varnish-nginx/)

## HTTP 缓存服务器

HTTP 缓存服务器用于缓解Web服务器的压力。客户端请求先到缓存服务器，然后根据缓存是否命中决定直接返回或者从原始服务器获取数据之后缓存。

HTTP 缓存服务器把用户请求的内容存储在缓存服务器中，当有相同的请求时直接从缓存中读取数据，然后返回。减少实际请求到达原始服务器的数量，从而提高服务整体的响应速度。

### CDN （Content Delivery Network）内容分发网络

CDN 把静态文件缓存再不同的地理位置，用户请求静态资源时，根据DNS解析出最近的服务器地址，从最近的服务器获取到数据，提高响应速度。

静态资源发布到DNS服务器之后，如果数据内容变更，需要重新上传的DNS服务器。操作相对缓存代理服务器麻烦。

CDN 和实际服务器是分离的。

### 反向代理 (reverse proxy)

正向代理：客户端通过代理访问其它资源，此时的代理用于转发客户端的请求是正向代理。

反向代理：代理服务器代理原始服务器的服务，此时代理用户聚合原始服务器的服务是方向代理。

### [Squid](http://www.squid-cache.org/)

专业缓存服务器。

### [Varnish](https://varnish-cache.org/)

专业缓存服务器。使用VCL进行逻辑控制。提供命令行工具。

#### VCL (Varnish Configuration Language) 配置语言

* 控制怎么处理HTTP请求。
* 控制缓存哪些数据
* 控制怎么缓存数据。
* 处理HTTP请求头。

#### 命令行工具

* varnishadm：管理员命令行工具。
* varnishlog：运行日志查看工具，日志不会保存到磁盘中。
* varnishstat：缓存服务器状态信息，命中率等。

[varnish-cache-git](https://github.com/varnishcache/varnish-cache)

### Nginx(http proxy model)

http proxy model 提供代理缓存功能。

### Apache(mod_proxy)

mod_proxy 提供代理缓存功能。
