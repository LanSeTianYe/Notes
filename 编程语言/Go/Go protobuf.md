时间：2021-11-16 10:26:27

参考：

1. [Protobuf编码安装](https://github.com/davyxu/cellnet/blob/master/doc/pbcodec.md)
2. [go-GRPC指南](https://grpc.io/docs/languages/go/quickstart/)

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

