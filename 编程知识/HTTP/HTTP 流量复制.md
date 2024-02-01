时间：2020-12-02 18:13:13

参考：

1. [goreplay](https://goreplay.org/)
2. [Design A Dark Traffic System To Test HTTPS Requests With Goreplay](https://medium.com/a-layman/software-testing-design-a-dark-traffic-system-to-test-https-requests-with-goreplay-8d143ebc5497)
3. [流量复制重放工具goreplay与diffy结合使用](http://xifxiong.online/goreplay/)
4. [goreplay-wiki](https://github.com/buger/goreplay/wiki)
5. [kudiffy-一个很酷的自动化回归平台](https://tech.kujiale.com/kudiffy-yi-ge-hen-ku-de-zi-dong-hua-hui-gui-ping-tai/)

## HTTP 流量复制

记录接收到的HTTP请求、转发到其它地址。

### [goreplay](https://github.com/buger/goreplay)

GoReplay is an open-source network monitoring tool which can record your live traffic, and use it for shadowing, load testing, monitoring and detailed analysis.

GoReplay 监听HTTP端口，记录HTTP请求。把记录的请求发送到其它HTTP服务，支持流量放大或缩小。可以用记录的请求测试服务（功能测试或压力测试）。

### GoReplay 使用

常用命令：

```
# 模拟启动一个Http服务器
gor file-server :8090
# 监听8090端口，把HTTP请求打印在控制台
gor -input-raw :8090 -output-stdout
# 监听8090端口，把HTTP请求保存在本地文件
gor -input-raw :8090 -output-file ./request.gor
# 监听8090端口，把HTTP请求保存在本地文件，追加不创建新文件
gor -input-raw :8090 -output-file ./request.gor -output-file-append
# 监听8090端口，把收到的请求再次转发到8090端口（死循环）
gor -input-raw :8090 --output-http 'localhost:8090'
# 读取本地记录文件的请求，转发到指定地址
gor -input-file request.gor -output-http 'localhost:8090'
# 读取以request开头的本地记录文件的请求，转发到指定地址
gor -input-file request* -output-http 'localhost:8090'
# 读取本地记录文件的请求，（请求数量扩大八倍），转发到指定地址
gor -input-file './request_0.gor|800%' -output-http 'localhost:8090'
# 读取本地记录文件的请求，（请求数量扩大八倍），转发到多个指定地址，每个发送一份
gor -input-file './request_0.gor|800%' -output-http 'localhost:8090' -output-http 'localhost:8091'
# 读取本地记录文件的请求，（请求数量扩大八倍），转发到多个指定地址，每个请求发送到其中的一个服务器
gor -input-file './request_0.gor|800%' -output-http 'localhost:8090' -output-http 'localhost:8091' --split-output true
# 读取本地记录文件的请求，（请求数量扩大八倍），转发到指定地址，转发时限制每秒转发的次数最多为10（只支持整数）
gor -input-file './request_0.gor|800%' -output-http 'localhost:8090|10'
# 读取本地记录文件的请求，（请求数量扩大八倍），转发到指定地址，转发时最多转发50%的流量
gor -input-file './request_0.gor|800%' -output-http 'localhost:8090|50%'
# 读取本地记录文件的请求，（请求数量扩大八倍），转发到指定地址，根据header过滤，转发时最多转发10%的流量
gor -input-file './request_0.gor|800%' -output-tcp "localhost:8090|10%" --http-header-limiter "X-API-KEY:10%"
```

其它命令：

* `-http-pprof :8080`：通过HTTP端口暴漏goreplay 运行情况，之后访问 `localhost:8080/debug/pprof/`。

    ``` shell
    ./gor -input-raw :8090 -output-stdout -http-pprof :8080
    ```
    
* `-input-dummy 1` 每秒发送一个请求到 `/`。

* `-input-file-loop` 循环读取文件。

* `-input-tcp :8091` 从一个运行中的gor读取数据。

* `-input-raw-track-response` 显示响应信息。

* `-input-raw-realip-header "X-Real-IP"` 添加真实IP到请求头。

* `-output-file-flush-interval duration` 刷新数据到文件时间间隔，默认1s。

* `-output-file-size-limit value` 输出文件大小，默认32mb。

* `-output-http-redirects 2` 转发重定向，默认忽略。

* `-output-http-timeout 5s` 转发超时限制，默认5s。

* `-output-http-response-buffer 200kb` 最大接收响应大小，默认200kb。

* `-http-original-host` 不要修改Host。

* `-http-allow-method GET` 过滤掉非GET请求。

* `-http-allow-url /api` 只允许到 `/api` 路径到请求。

* `-http-disallow-url /api` 不允许到 `/api` 路径到请求。

* `-recognize-tcp-sessions` [tcp session 保存tcp状态](https://github.com/buger/goreplay/wiki/%5BPRO%5D-Recording-and-replaying-keep-alive-TCP-sessions)。

* `-exit-after 30s` 多长时间之后结束。

### [ngx_http_mirror_module](http://nginx.org/en/docs/http/ngx_http_mirror_module.html)

The ngx_http_mirror_module module (1.13.4) implements mirroring of an original request by creating background mirror subrequests. Responses to mirror subrequests are ignored.

不够灵活，变更需要重新加载Nginx。

