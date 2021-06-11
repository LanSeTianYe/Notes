时间：2021-06-11 15:28 

参考:

1. [Linux内网测试环境模拟网络丢包和延时 ](https://lessisbetter.site/2019/05/18/linux-simulate-bad-network/)


## tc 命令

### 示例

1. 模拟延时为1000毫秒。

    ```shell
    # 延时100ms
    tc qdisc add dev ens33 root netem delay 1000ms
    # 抖动，延时在[1000-100,1000+100]之间
    tc qdisc add dev ens33 root netem delay 1000ms 100ms
    # 相关性，下一个包和上一个包延时的相关性，相关性越高延迟越相近
    # 100% 等价于固定延时，0%等价于随机延时
    tc qdisc add dev ens33 root netem delay 1000ms 100ms 30%
    ```

2. 模拟丢包率。

    ```shell
    # 丢包率50%
    tc qdisc add dev ens33 root netem loss 50%
    # 相关性，和前一个丢包率相关性为25%
    tc qdisc add dev ens33 root netem loss 50% 25%
    ```

3. 模拟包重复。

    ```shell
    # 报文重复
    tc qdisc add dev ens33 root netem duplicate 50% 25%
    ```

4. 模拟报文损坏。

    ```shell
    # 报文损坏
    tc qdisc add dev ens33 root netem corrupt 50%
    ```

5. 模拟报文乱序。

    ```shell
    # 三个延迟1000ms，一个不延时
    tc qdisc add dev ens33 root netem reorder 100% gap 3 delay 1000ms
    # 50%延迟1000ms发送，其它正常发送
    tc qdisc add dev ens33 root netem reorder 50% 15% delay 1000ms
    ```
    
6. 查看当前规则。

    ```shell
    tc qdisc show dev ens33
    ```
    
6. 删除规则。

    ```shell
    tc del dev ens33 root netem
    ```