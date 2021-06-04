时间：2021-05-31 14:28:28

参考：

1. [Stack Traces In Go](https://www.ardanlabs.com/blog/2015/01/stack-traces-in-go.html)

## Go Stack Trace 信息

go 编译的时候会优化掉没有使用的参数，可以使用 `-gcflags "-N -l"` 禁止编译优化。

### 堆栈追踪信息含义

1. `slice` ：引用类型。长度为三，第一个是指向底层数组的指针，第二个表示长度，第三个表示容量。

    ```
    // Slice header values
    Pointer:  0x2080c3f50
    Length:   0x2
    Capacity: 0x4
    ```

2. string：应用类型，长度为二，第一个表示地址指针执行底层字节数组，第二个表示字符串长度。

    ```
    // String header values
    Pointer: 0x425c0
    Length:  0x5
    ```
3. int 类型：长度为1.

    ```
    // Integer value
    Base 16: 0xa
    ```
    
4. 指针作为方法的接收器，会第一个打印接收器的地址。如果不是指针或者没有接收器不会打印额外信息。

5. boolean、uint8类型，会合并参数，一个字可以表示四个boolean。在64位机器上，一个字可以表示8个布尔类型。

    ```
    # 代码
    01 package main
    02
    03 func main() {
    04     Example(true, false, true, 25)
    05 }
    06
    07 func Example(b1, b2, b3 bool, i uint8) {
    08     panic("Want stack trace")
    09 }
    # 异常信息
    01 goroutine 1 [running]:
    02 main.Example(0x19010001)
           /Users/bill/Spaces/Go/Projects/src/github.com/goinaction/code/
           temp/main.go:8 +0x64
    03 main.main()
           /Users/bill/Spaces/Go/Projects/src/github.com/goinaction/code/
           temp/main.go:4 +0x32
    # 参数解析
    // Parameter values
    true, false, true, 25

    // Word value
    Bits    Binary      Hex   Value
    00-07   0000 0001   01    true
    08-15   0000 0000   00    false
    16-23   0000 0001   01    true
    24-31   0001 1001   19    25

    // Declaration
    main.Example(b1, b2, b3 bool, i uint8)

    // Stack trace
    main.Example(0x19010001)
    ```

6. 接口类型参数，第一个表示类型，第二个表示指针地址。