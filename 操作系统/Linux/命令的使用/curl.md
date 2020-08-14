时间 ： 2017/4/20 16:14:22
参考:

1. [curl 的用法指南](http://www.ruanyifeng.com/blog/2019/09/curl-reference.html)
2. [cookbooks-curl](https://catonmat.net/cookbooks/curl)

## 命令介绍
用于和网络服务器进行通信

## 语法

```shell
curl [options] [URL...]
```

**选项**

 * `-v`: 输出通信的整个过程。
 * `-o, --output <file>`: 把获取到的数据都写入到文件中。
 * `-O, --remote-name`: 使用服务器上的文件名字保存本地文件。
 * `-s, --silent`: 安静模式，不显示进度条或错误信息。
 * `-S, --show-error`: 当使用 `-s` 模式的时候，使用 `-S` 可以显示错误信息。
 * `--limit-rate <speed>` : 限制下载速度，速度单位(B,K,M,G)。
 * `-L`: 如果网页的Header里面指定重定向地址，请求会重定向到指定的地址。
 * `-c，--cookie-jar <file name>`:把操作完成之后的 cookie 写入到指定文件。如果文件名是 `-` cookie 将写入到控制台。
 * `-C,--continue-at <offset>`: 断点续传， `-C -` 自动查找中断点。
 * `-z,--time-cond <date expression>|<file>`:获取一个文件，这个文件的变更时间在给定时间之后或之前，默认之后，如果没有匹配日期表达式，则会以表达式为名字获取对应文件的修改日期。时间表达式以 `-`  开头，获取变更时间在给定时间前的文件。
 * `-y,--speed-time <time>`:如果下载速度小于 `speed-limit` 的时间超过指定时间，则停止下载。如果 `speed-limit` 没有设置则为1。
 * `-Y,--speed-limit <speed>`: 如果下载速度小于指定速度(bytes per second),并且下载时间超过 `speed-time` 指定的时间，则终止下载。如果 `speed-time` 没有设置则为30。
 * `-u,--user <username:password;options>`:指定用户明和密码登录，如果密码没有指定，后面会询问。
 * `-x,--proxy <[protocol://][user:password@]proxyhost[:port]>`:代理访问。
 * `-d,--data` <data> : Post请求发送指定的数据到服务器。使用 `'-d  name=daniel  -d
              skill=lousy'` 将发送 `name=daniel&skill=lousy`。如果data以字母@开头，将会从对应的文件中读取。
 * `-D,--dump-header <file>` ：把协议头信息写入指定文件。
 * `-b,--cookie <name=data>`:吧数据当成cookie发送给服务器，如果没有 `=` 号，则会从文件中读取。
 *  `-A,--user-agent <agent string>`: 用户代理，什么类型的浏览器。
 *  `-I, --head` ： 只获取HTTP响应头

## 具体使用

*  请求指定网址，请求内容显示在命令行。

    ```shell
    curl http://www.baidu.com
    ```

* GET 请求

     ```shell
     curl -X GET http://www.baidu.com
     ```

* GET 请求,加参数

     ```shell
     curl -G -d 'name=name' -d 'age=age' http://www.baidu.com
     ```

* POST 请求, `-d` 指定参数 

    ```shell
    curl -d 'name=name＆age=age' -X POST http://www.baidu.com
    ```

* POST 请求, `--data-urlencode` URL Encode 参数

    ```shell
    curl --data-urlencode 'name=nam e＆age=age' -X POST http://www.baidu.com
    ```

* Header 请求

    ```shell
    curl -I http://www.baidu.com
    ```
    
* 指定代代理头

    ```shell 
    curl -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36' https://www.baidu.com
    ```
    
5. 发送Cookie

    ```shell
    curl -b 'name=value;name=value' https://www.baidu.com
    ```

* 设置 Referer

    ```shell
    curl -e 'https://www.baidu1.com' https://www.baidu.com
    ```

* 添加HEADER

    ```shell
    curl -H 'TOKEN: xxxxxx' -H 'XX: xx'  https://www.baidu.com
    ```

* 显示响应的HTTP头

    ```shell
    curl -i http://www.baidu.com
    ```

* 跳过ssl检测

    ```shelll
    curl -k https://www.baidu.com
    ```

* 支持重定向

    ```shell
    curl -L http://www.baidu.com
    ```

* 限制带宽

    ```shell
    curl --limit-rate 1b http://www.baidu.com
    ```

* 把网址内容保存到指定文件中。

    ```
    curl -o baidu.html http://www.baidu.com
    # 简单正则
    curl -o "#1.html" http://www.cnblogs.com/gbyukg/p/332682[0-9].html
    curl -o "#1_#2.html" http://www.{cnblogs}.com/gbyukg/p/332682[0-9].html
    ```

* 使用服务器上的文件名自动保存在本地，（如果文件在服务器不是以文件存在，则会出错）。

    ```shell
    curl -O https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/logo_white_fe6da1ec.png
    # 错误
    curl -O http://www.baidu.com
    ```

* 从ftp服务器下载文件

    ```shell
    # 列出目录下的所有文件夹
    curl -u ftpuser:ftppass -O ftp://ftp_server/public_html/
    # 下载文件
    curl -u ftpuser:ftppass -O ftp://ftp_server/public_html/xss.php
    ```
* 上传文件

    ```shell
    # 将myfile.txt文件上传到服务器
    curl -u ftpuser:ftppass -T myfile.txt ftp://ftp.testserver.com
    # 同时上传多个文件
    curl -u ftpuser:ftppass -T "{file1,file2}" ftp://ftp.testserver.com
    # 从标准输入获取内容保存到服务器指定的文件中
    curl -u ftpuser:ftppass -T - ftp://ftp.testserver.com/myfile_1.txt
    ```
* 查询单词意思或翻译

    ```shell
    curl dict://dict.org/d:bash
    # 列出所有可用词典
    curl dict://dict.org/show:db
    # 在fd-deu-fra词典中查询bash单词的含义
    curl dict://dict.org/d:bash:fd-deu-fra
    ```