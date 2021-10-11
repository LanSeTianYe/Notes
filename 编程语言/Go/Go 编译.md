时间：2021-09-26 16:16:16

参考：

## GO 编译

### go install

生成可执行文件同时编译依赖的文件。

1. 保存编译生成的中间文件

    ```shell
    go install -i mypkg
    ```

### GO 交叉编译

GO 可以在一个平台编译生成其它平台的可执行文件。

```shell
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build main.go
```

**参数：**

1. GOOS（系统）： 可选参数 `darwin` `freebsd` `linux` `windows `
2. GOARCH（架构）：可选参数 `386` `amd64` `arm`


### 示例

```shell
#amd64
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build main.go
CGO_ENABLED=0 GOOS=linux   GOARCH=amd64 go build main.go
CGO_ENABLED=0 GOOS=darwin  GOARCH=amd64 go build main.go
CGO_ENABLED=0 GOOS=freebsd  GOARCH=amd64 go build main.go
#386
CGO_ENABLED=0 GOOS=windows GOARCH=386 go build main.go
CGO_ENABLED=0 GOOS=linux   GOARCH=386 go build main.go
CGO_ENABLED=0 GOOS=freebsd   GOARCH=386 go build main.go
#arm
CGO_ENABLED=0 GOOS=windows GOARCH=arm go build main.go
CGO_ENABLED=0 GOOS=linux   GOARCH=arm go build main.go
CGO_ENABLED=0 GOOS=freebsd   GOARCH=arm go build main.go
```
