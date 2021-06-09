时间：2021-06-04 10:38:38

参考：

1. [Go pprof的使用](https://studygolang.com/articles/12970)
2. [go-pprof](https://golang.org/pkg/runtime/pprof/)

## go pprof

1. StartCPUProfile：开始监控cpu。
2. StopCPUProfile：结束监控CPU。
3. WriteHeapProfile：把队中的内存信息写入到文件中。

### 命令行版本

#### CPU取样分析

```go
# 开始分析
f, err := os.Create("cpu.prof")
if err != nil {
    panic(err)
}
defer f.Close()
if err := pprof.StartCPUProfile(f); err != nil {
    panic(err)
}
defer pprof.StopCPUProfile()

# 等待结束分析
exitChan := make(chan os.Signal)
signal.Notify(exitChan, os.Interrupt, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT)
select {
case <-exitChan:
    pprof.StopCPUProfile()
    f.Close()
    os.Exit(1)
}
```

通过浏览器查看内存分析结果

```shell
go tool pprof -http=127.0.0.1:8080 cup.prof
```

#### 内存取样分析

```go
if err := pprof.WriteHeapProfile(f); err != nil {
    log.Fatal("could not write memory profile: ", err)
}
f.Close()
```

### Web 页面版本

Web页面版本只需要导入web包，然后启动Web端口即可。

```
# 导入包
_ "net/http/pprof"

# 程序开始的地方启动Web服务
go http.ListenAndServe(":8080", nil)
```

### 使用

1. 通过浏览器查看信息：[http://localhost:8080/debug/pprof/](http://localhost:8080/debug/pprof/)
2. 通过命令行查看

    ```shell
    go tool pprof -inuse_space http://127.0.0.1:8080/debug/pprof/heap
    go tool pprof -seconds=10 http://127.0.0.1:8080/debug/pprof/profile
    go tool pprof http://127.0.0.1:8080/debug/pprof/goroutine
    ```

