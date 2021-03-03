时间：2020-12-27 13:28:28

## Java CPU占用高问题定位分析

通过命令定位CPU占用过高代码。

1. 第一步定位到进程ID。使用 `top` 命令，找到进程ID为 `13483`。

2. 查看进程详细信息。使用 `jps` 或者 `ps -ef | grep java | grep -v grep`

    ```
    # jps
    [root@qyi-599a961908983 ~]# jps -v
    13483 halo-1.3.2.jar -XX:+UseG1GC -XX:+PrintGC
    # ps
    [root@qyi-599a961908983 ~]# ps -ef | grep java | grep -v grep
    root     13483     1  0 Nov11 pts/3    04:15:33 java -jar -XX:+UseG1GC -XX:+PrintGC /home/root/software/halo/halo-1.3.2.jar
    ```

3. 定位CPU线程，使用 `top -H -p 13483` 命令或者 `ps H -eo pid,tid,%cpu | grep 13483` , 定位到线程 `13486`。

    ```
    [root@qyi-599a961908983 ~]#top -H -p 13483
    PID   USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
    13486 root      20   0 2453368 391740   5516 S  0.3 39.0  25:17.63 java
    13483 root      20   0 2453368 391740   5516 S  0.0 39.0   0:00.00 java
    13484 root      20   0 2453368 391740   5516 S  0.0 39.0   0:21.88 java
    13485 root      20   0 2453368 391740   5516 S  0.0 39.0   2:35.75 java
    13487 root      20   0 2453368 391740   5516 S  0.0 39.0   0:01.12 java
    13488 root      20   0 2453368 391740   5516 S  0.0 39.0   0:00.34 java
    13489 root      20   0 2453368 391740   5516 S  0.0 39.0   0:13.44 java
    ```

4. 转换进程ID为16进制。`printf '%x\n' 13486`，得到结果 `34ae`。

3. 定位到对应代码调用栈。`jstack -l 13483  | grep -A 20 "34ae"`。