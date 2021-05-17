时间：2021-05-17 15:14:14

参考：

1. [Go语言圣经-中文版-Channels](https://books.studygolang.com/gopl-zh/ch8/ch8-04.htmlChannels)

## Go channel

1. 创建 `channel`

    ```go
    # 无缓存channel，接收者和发送者都会阻塞，等待对方发送或接收
    make(chain int)
    make(chain int,0)
    # 有缓存，达到缓存大小会阻塞
    make(chain int,3)
    ```

2. 关闭 `channel`, 关闭之后发送数据将产生panic异常，数据全部接收完之后会返回零值和关闭标识。

    ```go
    ch := make(chan int,3)
    go func(){
        ch <- 0
        ch <- 1
        ch <- 2
        ch <- 3
    }()
    close(ch)
    
    //isOpen true 表示channel里面还有数据, false 表示channel里面没有数据，并且chanel已经关闭
    v, isOpen := <-ch
    if !isOpen{
        //channel has closed
    }

    ```
    
3. `for range` 从 channel 中读取数据，如果channel已经关闭并且没有更多数据，循环会结束。