时间：2021-06-07 16:59:69

参考：

1. [Linux下抓包命令tcpdump](https://www.cnblogs.com/monogem/p/9802756.html)

## tcpdump

选项：

1. `-nn` 不解析域名和端口。
2. `-i` 指定网卡。
3. `-vv` 显示详细信息。
4. `-c` 接收指定数量包之后停止。
5. `src host 172.16.1.95 and udp`：来源主机是 `172.16.1.95` 并且是`UDP`协议。

### 例子

1. 查看来源主机是`172.16.1.95`的udo数据包。 

    ```
    tcpdump -nn  -i eno1 'src host 172.16.1.95 and udp' -vv -c 10000
    ```
    
## tracepath

1. 查看网络路径的MTU:

    ```
    tracepath -m 10 -b 43.225.158.197/80
    ```
    
    结果如下:
    
    ```
    1?: [LOCALHOST]                                         pmtu 1500
    1:  bogon                                                 0.359ms
    1:  bogon                                                 0.274ms
    2:  249.16.126.124.broad.bjtelecom.net                    1.986ms
    3:  no reply
    4:  36.112.241.85                                         2.752ms
    5:  202.97.42.6                                           7.509ms
    6:  59.43.132.26                                         35.971ms
    7:  59.43.188.78                                         76.721ms
    8:  59.43.246.226                                        87.402ms asymm  7
    9:  59.43.181.190                                       110.624ms asymm  8
    0:  no reply
        Too many hops: pmtu 1500
        Resume: pmtu 1500
    ```
