时间：2021-10-11 14:04:04

参考:

1. [Golang — GOROOT、GOPATH、Go-Modules-三者的關係介紹](https://medium.com/%E4%BC%81%E9%B5%9D%E4%B9%9F%E6%87%82%E7%A8%8B%E5%BC%8F%E8%A8%AD%E8%A8%88/golang-goroot-gopath-go-modules-%E4%B8%89%E8%80%85%E7%9A%84%E9%97%9C%E4%BF%82%E4%BB%8B%E7%B4%B9-d17481d7a655)
2. [Go 包依赖管理工具 —— govendor](https://shockerli.net/post/go-package-manage-tool-govendor/)
3. [go_command_tutorial](https://github.com/hyper0x/go_command_tutorial)
4. [初探 Go 的编译命令执行过程](https://halfrost.com/go_command/)

## GO 项目结构

在 `GO 1.11` 增加了 `Go Modules`，使用mod的方式管理依赖。

系统参数如下：

```shell
xiaotian@LAPTOP-SDV1PEGS:~$ go version
go version go1.15.12 linux/amd64
```

GO 的环境变量如下，和项目结构相关的几个环境变量分别是：

**GOROOT**: GO安装目录，里面包含内置的类库。
**GOPATH**: GO开发目录，里面存放用户依赖的第三方代码（非mod模式）。
**GOMODCACHE**: 缓存依赖的mod的位置（mod 模式）。
**GOTOOLDIR**: GO工具目录。

```shell
xiaotian@LAPTOP-SDV1PEGS:~$ go env
GO111MODULE="on"
GOARCH="amd64"
GOBIN=""
GOCACHE="/home/xiaotian/.cache/go-build"
GOENV="/home/xiaotian/.config/go/env"
GOEXE=""
GOFLAGS=""
GOHOSTARCH="amd64"
GOHOSTOS="linux"
GOINSECURE=""
GOMODCACHE="/home/xiaotian/go/pkg/mod"
GONOPROXY=""
GONOSUMDB=""
GOOS="linux"
GOPATH="/home/xiaotian/go"
GOPRIVATE=""
GOPROXY="https://goproxy.cn,direct"
GOROOT="/usr/local/go"
GOSUMDB="sum.golang.org"
GOTMPDIR=""
GOTOOLDIR="/usr/local/go/pkg/tool/linux_amd64"
GCCGO="gccgo"
AR="ar"
CC="gcc"
CXX="g++"
CGO_ENABLED="1"
GOMOD="/dev/null"
CGO_CFLAGS="-g -O2"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-g -O2"
CGO_FFLAGS="-g -O2"
CGO_LDFLAGS="-g -O2"
PKG_CONFIG="pkg-config"
GOGCCFLAGS="-fPIC -m64 -pthread -fno-caret-diagnostics -Qunused-arguments -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build821839068=/tmp/go-build -gno-record-gcc-switches"
```

### GO 版本管理历史

#### vendor

从1.5开始提供支持，从1.7开始默认开启 `vendor`特性。要求项目必须在 `GOPATH的src目录`。从1.11版本开始提供 `go modules` 支持，从此开始不推荐使用 vendor 方式管理包。

在 `vendor` 模式下，包查找顺序：

1. 当前包的 `vendor目录`。
2. 如果当前包不存在`vendor`目录，则向上级查找直到找到 `GOPATH的src下的vendor目录`。
3. 查找 `GOROOT的src目录`。
4. 查找 `GOPATH的src目录`。

### GO 目录结构

```shell
xiaotian@LAPTOP-SDV1PEGS:~/go$ cd /usr/local/go/ && tree -L 2
├── api
├── bin #编译后的可执行文件
├── doc
├── lib
├── misc
├── pkg #编译的中间文件 strings.a
├── src
└── test
```

### 不开启 go modules

```shell
go env -w GO111MODULE="off"
```

下载的第三方仓库都会放到 `GOPATH的src` 目录。

GO 编译代码的时候，先从 `GOROOT的src` 目录，再从 `GOPATH的src` 目录查找，如果没有找打则编译报错。

**源代码：hello.go**

```go
package main

import "fmt"
import "github.com/gin-gonic/gin"

func main() {
    router := gin.Default()
    router.Run()
    fmt.Println("HELLO")
}
```

**执行代码:**

```shell
xiaotian@LAPTOP-SDV1PEGS:~/go/src/mypkg$ go run hello.go
hello.go:4:8: cannot find package "github.com/gin-gonic/gin" in any of:
        /usr/local/go/src/github.com/gin-gonic/gin (from $GOROOT)
        /home/xiaotian/go/src/github.com/gin-gonic/gin (from $GOPATH)
```

### 开启 go modules

```shell
go env -w GO111MODULE="on" && go env -w GOPROXY=https://goproxy.cn,direct
```

下载的第三方仓库都会放到 `GOPATH的pkg的mod` 目录。

GO 编译代码的时候，先从 `GOROOT的src` 目录，再从 `GOPATH的pkg的mod` 目录查找，如果没有找到则编译报错。编译后的可执行文件在 `GOPATH的bin目录`，编译的中间文件 （`.a` ）文件在 `GOPATH的pkg目录的GOHOSTOS_GOHOSTARCH` 目录。

**第三方依赖目录结构：**

```shell
xiaotian@LAPTOP-SDV1PEGS:~/go$ tree -L 2 pkg/
pkg/
├── mod
│   ├── cache
│   ├── github.com
│   ├── go.starlark.net@v0.0.0-20200821142938-949cc6f4b097
│   ├── golang.org
│   ├── gopkg.in
│   ├── honnef.co
│   └── mvdan.cc
└── sumdb
    └── sum.golang.org
```


## 附注

**go mod 命令说明:**

```shell
xiaotian@LAPTOP-SDV1PEGS:~/go/src/mypkg$ go help mod
Go mod provides access to operations on modules.

Usage:

        go mod <command> [arguments]

The commands are:

        download    download modules to local cache
        edit        edit go.mod from tools or scripts
        graph       print module requirement graph
        init        initialize new module in current directory
        tidy        add missing and remove unused modules
        vendor      make vendored copy of dependencies
        verify      verify dependencies have expected content
        why         explain why packages or modules are needed

Use "go help mod <command>" for more information about a command.
```