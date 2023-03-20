时间: 2023-03-20 15:24:12

参考：

1. [Golang 遇到 note: module requires Go 1.nn 解决之道，不升go](https://learnku.com/articles/74763)


## Go 依赖版本问题

问题描述：项目使用 `1.16.15` 版本的Go，项目依赖的仓库依赖了 `Go 1.17` 的方法，

**编译错误信息：** 

```shell
# golang.org/x/sys/unix
/Users/feilong/go/pkg/mod/golang.org/x/sys@v0.4.0/unix/syscall.go:83:16: undefined: unsafe.Slice
/Users/feilong/go/pkg/mod/golang.org/x/sys@v0.4.0/unix/syscall_darwin.go:95:8: undefined: unsafe.Slice
/Users/feilong/go/pkg/mod/golang.org/x/sys@v0.4.0/unix/syscall_unix.go:118:7: undefined: unsafe.Slice
/Users/feilong/go/pkg/mod/golang.org/x/sys@v0.4.0/unix/sysvshm_unix.go:33:7: undefined: unsafe.Slice
note: module requires Go 1.17
```

错误原因：项目依赖的 `golang.org/x/sys@v0.4.0` 包，依赖了当前版本Go没有的方法。

### 方法一：使用 `go graph` 

使用 `go graph` 找到依赖的包，然后降低包的版本。

```
# 找到谁依赖了 golang.org/x/sys@v0.4.0 
➜  xx git:(xx) ✗ go mod graph | grep golang.org/x/sys@v0.4.0                          
golang.org/x/crypto@v0.5.0 golang.org/x/sys@v0.4.0
golang.org/x/net@v0.5.0 golang.org/x/sys@v0.4.0
golang.org/x/term@v0.4.0 golang.org/x/sys@v0.4.0

# 找到谁依赖了 golang.org/x/crypto@v0.5.0
➜  xx git:(xx) ✗ go mod graph | grep golang.org/x/crypto@v0.5.0                       
github.com/xuri/excelize/v2@v2.7.0 golang.org/x/crypto@v0.5.0
golang.org/x/crypto@v0.5.0 golang.org/x/net@v0.5.0
golang.org/x/crypto@v0.5.0 golang.org/x/sys@v0.4.0
golang.org/x/crypto@v0.5.0 golang.org/x/term@v0.4.0
golang.org/x/crypto@v0.5.0 golang.org/x/text@v0.6.0
```

最终找到是 `github.com/xuri/excelize/v2@v2.7.0` 的依赖引入了对 `golang.org/x/sys@v0.4.0` 的依赖。把 `excelize` 的版本降到 `2.6.0` 解决问题。

### 方法二：使用 `gmchart` 解决

以图形画方式展示Go模块依赖关系，找到依赖关系。

### 安装 gmchart 

```shell
go install github.com/PaulXu-cn/go-mod-graph-chart/gmchart@latest
```

### 找到依赖关系

进入项目目录，执行下面命令，会打开浏览器，然后在浏览器中搜索 `golang.org/x/sys@v0.4.0` ，然后找上级知道找到项目直接依赖的模块。

```shell
go mod graph | gmchart
```

最终找到是 `github.com/xuri/excelize/v2@v2.7.0` 的依赖引入了对 `golang.org/x/sys@v0.4.0` 的依赖。把 `excelize` 的版本降到 `2.6.0` 解决问题。