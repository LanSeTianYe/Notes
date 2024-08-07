时间：2021-11-16 10:26:27

参考：

1. [Protobuf编码安装](https://github.com/davyxu/cellnet/blob/master/doc/pbcodec.md)
2. [go-GRPC指南](https://grpc.io/docs/languages/go/quickstart/)
3. [gRPC 入门](https://chai2010.cn/advanced-go-programming-book/ch4-rpc/ch4-04-grpc.html#443-grpc-%E6%B5%81)

## Go protobuf

长时间不安装 `ptotoc` 这次安装的时候又花费了很长时间，记录一下流程备用。

###  安装步骤

1. 下载，到 [github](https://github.com/protocolbuffers/protobuf/releases) 下载需要安装的包。**不要拉仓库安装，直接安装 release 包**。

	```shell
    Mac OS 64位平台，选择 protoc-x.x.x-osx-x86_64.zip
    Windows 64位平台，选择 protoc-x.x.x-win32.zip
    Linux 64位平台，选择 protoc-x.x.x-linux-x86_64.zip
   ```

2. 安装插件，不同的指令会使用不同的插件。`go get 和 go install` 都可以安装。

    ```shell
    # gogofaster 插件
    go get -v github.com/gogo/protobuf/protoc-gen-gogofaster
    go install -v github.com/gogo/protobuf/protoc-gen-gogofaster
    # gofast 插件
    go get github.com/gogo/protobuf/protoc-gen-gofast
    go install -v github.com/gogo/protobuf/protoc-gen-gofast
    # 插件列表
    protoc-gen-gofast 生成快速序列化和反序列化代码，不允许使用 gogoprotobuf 扩展。
    protoc-gen-gogofast   (same as gofast, but imports gogoprotobuf)
    protoc-gen-gogofaster (same as gogofast, without XXX_unrecognized, less pointer fields)
    protoc-gen-gogoslick  (same as gogofaster, but with generated string, gostring and equal methods)
    ```

3. 执行命令，`gogofaster ` 和插件相对应。

    ```shell
    pb:
        cd proto/ && protoc -I=. --gogofaster_out=plugins=grpc:../protogo --gogofaster_opt=paths=source_relative message.proto
    ```

### 模板 `contract_invoke.proto`
```protobuf
syntax = "proto3";

option go_package = "server/pb/protogo";

package protogo;

//SearchRequest
message SearchRequest {
  //required 必须字段
  required string query = 1;
  //optional 可选字段
  optional int32 page_number = 2;
  //repeated 列表
  repeated string description = 3;
  //enum and default value
  required Corpus groups = 4 [default = UNIVERSAL];
  //map  
  map<string, string> globalSates = 6;
}

//enum
enum Corpus {
  UNIVERSAL = 0;
  WEB = 1;
  IMAGES = 2;
  LOCAL = 3;
  NEWS = 4;
  PRODUCTS = 5;
  VIDEO = 6;
}

//定义RPC服务，会自动生成RPC相关代码
//rpc server
service ContractInvoke {
  //接收 ContractInfo 返回 ContractArgs
  rpc InvokeContractArgs(ContractInfo) returns (ContractArgs){};
  rpc ExecResult(ExecuteResult) returns (ExecuteResultResponse){};
}

//ContractInfo contract info
message ContractInfo{
  string name = 1;
  string method = 2;
  string version = 3;
}

//ContractArgs invoke contract args
message ContractArgs {
  string name = 1;
  string method = 2;
  string version = 3;
  string sid = 4;
  map<string, string> args = 5;
  map<string, string> globalSates = 6;
}

//ExecuteResult execute result
message ExecuteResult {
  string name = 1;
  string method = 2;
  string version = 3;
  string sid = 4;
  map<string, string> globalSates = 6;
  repeated string logs = 7;
  repeated Event event = 8;
  string time_cost = 9;
}

// Event message
message Event {
  // Event topic
  string topic = 1;
  // Event payload
  repeated string data = 2;
}

//ExecuteResultResponse execute result response
message ExecuteResultResponse {
}
```

### Makefile

```shell
pb:
	cd proto && protoc -I=. --gogofaster_out=plugins=grpc:../protogo\
                            --gogofaster_opt=paths=source_relative contract_invoke.proto
```

### 支持的类型

* stream: 服务端和客户端可以连续的发送和接受数据。

    ```go
    type HelloService_ChannelServer interface {
        Send(*String) error
        Recv() (*String, error)
        grpc.ServerStream
    }

    type HelloService_ChannelClient interface {
        Send(*String) error
        Recv() (*String, error)
        grpc.ClientStream
    }
    ```