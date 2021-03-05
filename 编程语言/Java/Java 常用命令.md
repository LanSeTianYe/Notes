时间: 2019-11-22 11:48:25

## 常用命令

1. 命令行启动 `jar` 包，打印控制台输出的 `./log.txt`。

    ``` shell
    nohup java -jar -Dfile.encoding=UTF-8 -Dserver.port=2050 ./arthas-tunnel-server-3.1.4.jar > log.txt &
    ```

