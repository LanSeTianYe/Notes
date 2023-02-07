时间：2021-06-04 10:38:38

参考：

1. [Go 大杀器之性能剖析 PProf](https://eddycjy.gitbook.io/golang/di-9-ke-gong-ju/go-tool-pprof)
2. [go-pprof](https://golang.org/pkg/runtime/pprof/)

## go pprof

### 命令行版本

程序启动之后开始监听程序，程序执行结束之后把内存和CPU信息写入到文件中，然后命令行工具分析查看。

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

#### 使用

1. 总览：`http://127.0.0.1:8086/debug/pprof/`

2. 通过命令行查看。在命令行模式下可以使用 `sample_index` 切换到不同的采样维度，如：`(pprof) sample_index=alloc_objects`。

    ```shell
    go tool pprof -h
    
    ### CPU和内存
    # 内存占用
    go tool pprof http://127.0.0.1:8086/debug/pprof/heap
    go tool pprof -http=:8081 http://127.0.0.1:8086/debug/pprof/heap
    
    # CPU 耗时
    go tool pprof http://127.0.0.1:8086/debug/pprof/profile?seconds=30
    go tool pprof -http=:8081 http://127.0.0.1:8086/debug/pprof/profile?seconds=30
    
    
    ### 并发信息
    # 阻塞 阻塞在同步原语上的堆栈信息
    go tool pprof -http=:8081 http://127.0.0.1:8086/debug/pprof/block
    
    # 互斥锁 阻塞在互斥锁上的堆栈信息
    go tool pprof -http=:8081 http://127.0.0.1:8086/debug/pprof/mutex
    
    # 当前启动协程的堆栈信息
    go tool pprof http://127.0.0.1:8086/debug/pprof/goroutine
    go tool pprof -http=:8081 http://127.0.0.1:8086/debug/pprof/goroutine
    
    
    # 遗留的便捷入口
    -inuse_space           Same as -sample_index=inuse_space
    -inuse_objects         Same as -sample_index=inuse_objects
    -alloc_space           Same as -sample_index=alloc_space
    -alloc_objects         Same as -sample_index=alloc_objects
    -total_delay           Same as -sample_index=delay
    -contentions           Same as -sample_index=contentions
    -mean_delay
    ```

