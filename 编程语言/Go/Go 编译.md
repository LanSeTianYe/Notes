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

操作系统支持的架构：true 表示支持CGO。

```go
var OSArchSupportsCgo = map[string]bool{
	"aix/ppc64": true,
	
	"android/386": true,
	"android/amd64": true,
	"android/arm": true,
	"android/arm64": true,
	
	"darwin/amd64": true,
	"darwin/arm64": true,
	
	"dragonfly/amd64": true,
	
	"freebsd/386": true,
	"freebsd/amd64": true,
	"freebsd/arm": true,
	"freebsd/arm64": true,
	
	"illumos/amd64": true,
	
	"ios/amd64": true,
	"ios/arm64": true,
	
	"js/wasm": false,
	
	"linux/386": true,
	"linux/amd64": true,
	"linux/arm": true,
	"linux/arm64": true,
	"linux/mips": true,
	"linux/mips64": true,
	"linux/mips64le": true,
	"linux/mipsle": true,
	"linux/ppc64": false,
	"linux/ppc64le": true,
	"linux/riscv64": true,
	"linux/s390x": true,
	"linux/sparc64": true,
	
	"netbsd/386": true,
	"netbsd/amd64": true,
	"netbsd/arm": true,
	"netbsd/arm64": true,
	
	"openbsd/386": true,
	"openbsd/amd64": true,
	"openbsd/arm": true,
	"openbsd/arm64": true,
	"openbsd/mips64": false,
	
	"plan9/386": false,
	"plan9/amd64": false,
	"plan9/arm": false,
	
	"solaris/amd64": true,
	
	"windows/386": true,
	"windows/amd64": true,
	"windows/arm": false,
}
```

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
