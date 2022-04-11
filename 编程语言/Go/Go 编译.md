时间：2021-09-26 16:16:16

参考：

1. [Go 条件编译](https://zsy-cn.github.io/%E6%9D%A1%E4%BB%B6%E7%BC%96%E8%AF%91.html)

## Go 编译

### go install

生成可执行文件同时编译依赖的文件。

1. 保存编译生成的中间文件

    ```shell
    go install -i mypkg
    ```

### Go 交叉编译

Go 可以在一个平台编译生成其它平台的可执行文件。

操作系统和处理器架构：[src/go/build/syslist.go](http://air.codes/src/go/build/syslist.go)

操作系统是否支持CGO ，源代码路径：[src/cmd/go/internal/cfg/zosarch.go](http://air.codes/src/cmd/go/internal/cfg/zosarch.go)

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

### Go 条件编译

通过编译标签或者文件后缀表明文件在什么机器环境下参与编译。

#### 编译标签

**系统标签：** 系统默认提供的标签，如Go版本、操作系统、处理器架构、是否开启 CGO 等。

``` go
# 非linux且非windows平台下使用
//go:build !linux && !windows
// +build !linux,!windows
# linux 或 windows 平台使用
//go:build linux || windows
// +build linux windows
# linux 或 windows 平台 且 amd64 处理器架构使用
//go:build (linux || windows) && amd64
// +build linux windows
// +build amd64
# (linux 或 windows 平台) 且 (amd64 处理器架构) 且 (不开启CGO) 时使用
//go:build (linux || windows) && amd64 && !cgo
// +build linux windows
// +build amd64
// +build !cgo
# 忽略
go:build ignore
```

**自定义标签：**在编译条件中添加自定义标签，在编译时指定标签即可使用。

```go
go build -tags mytag1 mytag2
```

#### 文件后缀

文件命名格式: `aa_GOOS_GOARCH.go`、 `aa_GOOS.go` 和 `aa_GOARCH.go` 

上面三种命名格式分别表示：

1. 在对应操作系统和处理器架构的机器上编译时使用。
2. 在对应操作系统的机器上编译时使用。
3. 在对应处理器架构的机器上编译时使用。