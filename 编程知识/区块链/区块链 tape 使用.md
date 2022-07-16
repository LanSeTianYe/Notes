时间：2020-03-31 10:44:44

参考：

1. [tape](https://github.com/Hyperledger-TWGC/tape)
2. [tape-issues-146](https://github.com/Hyperledger-TWGC/tape/issues/146)
3. [配置](https://github.com/Hyperledger-TWGC/tape/blob/master/docs/configfile.md)
3. [快速开始](https://github.com/Hyperledger-TWGC/tape/blob/master/docs/gettingstarted.md)
4. [工作流程](https://github.com/Hyperledger-TWGC/tape/blob/master/docs/workflow.md#%E5%B7%A5%E4%BD%9C%E6%B5%81%E7%A8%8B)
4. [功能规划](https://github.com/Hyperledger-TWGC/tape/blob/master/docs/roadmap.md)

环境：

1. tape-0.1.1

## Tape 使用说明

### Tape 简介

Tape 项目原名 Stupid，最初由 TWGC（Technical Working Group China，超级账本中国技术工作组）成员郭剑南开发，目的是提供一款轻量级、可以快速测试 Hyperledger Fabric TPS 值的工具。Stupid 取自 KISS 原则 Keep it Simple and Stupid，目前已正式更名为 Tape，字面含义卷尺，寓意测量，测试。目前 Tape 已贡献到超级账本中国技术社区，由 TWGC 性能优化小组负责维护。

### 安装运行

1. 从[release地址](https://github.com/Hyperledger-TWGC/tape/releases) `下载 v0.1.1`  版本。

2. 运行 `./tape config.yaml 40000`。4000是执行的交易数量，要配置成 `batchsize` 的整数倍，避免超时出块的情况。

### 配置

#### Tape 主要配置参数

[配置说明](https://github.com/Hyperledger-TWGC/tape/blob/master/docs/configfile.md)

| 参数 | 说明 | 默认值 |
| ---- | ---- | ------ |
| channel | 通道（对应于链） | mychannel |
| chaincode | 链码(智能合约) | basic |
| args | 调用链码的参数 | GetAllAssets |
| commitThreshold | 多少个committers接收区块被认为成功 | 2 |
| mspid | MSP ID 是用户属性的一部分，表明该用户所属的组织。 | Org1MSP |
|num_of_conn      | 客户端和 Peer 节点，客户端和排序节点之间创建的 gRPC 连接数量。如果你觉得向 Fabric 施加的压力还不够，可以将这个值设置的更大一些。 | 10 |
|client_per_conn | 每个连接用于向每个 Peer 节点发送提案的客户端数量。如果你觉得向 Fabric 施加的压力还不够，可以将这个值设置的更大一些。所以 Tape 向 Fabric 发送交易的并发量为 `num_of_conn` * `client_per_conn`。 | 10 |

#### 其它配置

* 设置日志级别：`export TAPE_LOGLEVEL=warn`。默认 `warn`，支持的日志级别 `panic/fatal/error/warn/warning/info/debug/trace`

### 运行结果

什么时候停止？Tape接收到 Peer 节点广播的区块之后，会计算区块中交易数量，以及总耗时，当接收到区块的交易数量和运行 Tape 时输入的参数一致时，结束运行，并根据总耗时计算 TPS。

```
Time 0.18s Block 54 Tx 10
Time 0.20s Block 55 Tx 10
Time 0.24s Block 56 Tx 10
Time 0.26s Block 57 Tx 10
Time 0.27s Block 58 Tx 10
Time 0.30s Block 59 Tx 10
Time 0.32s Block 60 Tx 10
Time 0.34s Block 61 Tx 10
Time 0.35s Block 62 Tx 10
Time 0.37s Block 63 Tx 10
tx: 100, duration: 365.319234ms, tps: 273.733192
```
输信息含义：

* `Time`：从第一个交易发送到现在持续的时间。
* `Block`：peer 节点的块高度。
* `tx`：块里面的交易数量。

#### 数据统计

可以和 `chainmaker` 一样查看 `peer` 节点的输出日志。

##### 已知信息：

1. 运行时间 `duration`。
2. 运行的交易数量 `tx`。
2. 块高度和每一个块里面的交易数量。

##### 可以计算

1. 上链TPS。Tape已经统计出来。
2. 出块时间。Tape每一次打印日志的时间间隔。
