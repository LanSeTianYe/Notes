时间：2021-05-31 14:28:28

参考：

1. [Stack Traces In Go](https://www.ardanlabs.com/blog/2015/01/stack-traces-in-go.html)

## Go Stack Trace 信息

go 编译的时候会优化掉没有使用的参数，可以使用 `-gcflags "-N -l"` 禁止编译优化。

### 堆栈追踪信息含义

1. `slice` ：引用类型。长度为三，第一个是指向底层数组的指针，第二个表示长度，第三个表示容量。

    ```go
    //data := make([]string, 0)
    //testParam(data)
    func testParam(data []string) {
      panic("")
    }
    
    # 输出
    main.testParam({0x1400006ef48, 0x0, 0x0})
            /Users/feilong/workspace/github/FPF_Go/main.go:13 +0x38
    main.main()
            /Users/feilong/workspace/github/FPF_Go/main.go:9 +0x38
    exit status 2
    ```

2. `map` 类型。长度为一，显示map的地址。

    ```go
    //data := make(map[string]string, 0)
    //testParam(data)
    
    func testParam(data map[string]string) {
      panic("")
    }
    
    # 输出
    goroutine 1 [running]:
    main.testParam(0x14000066e68)
            /Users/feilong/workspace/github/FPF_Go/main.go:16 +0x98
    main.main()
            /Users/feilong/workspace/github/FPF_Go/main.go:11 +0x7c
    exit status 2
    ```

3. string：应用类型，长度为二，第一个表示地址指针执行底层字节数组，第二个表示字符串长度。

    ```go
    //testParam("data")
    func testParam(data string) {
      panic("")
    }
    
    # 输出
    main.testParam({0x104928d35, 0x4})
            /Users/feilong/workspace/github/FPF_Go/main.go:12 +0x34
    main.main()
            /Users/feilong/workspace/github/FPF_Go/main.go:8 +0x28
    ```
    
4. 指针类型：长度为1，表示指针地址。

    ```go
    testParam(&A{})
    func testParam(data *A) {
      panic("")
    }
    // 输出
    main.testParam(0x14000098f58)
            /Users/feilong/workspace/github/FPF_Go/main.go:12 +0x30
    main.main()
            /Users/feilong/workspace/github/FPF_Go/main.go:8 +0x30
    exit status 2
    ```

4. int 类型：长度为1，表示int的值。

    ```go
    //testParam(10000000)
    func testParam(data int) {
    	panic("")
    }
    
    //输出
    main.testParam(0x989680)
            /Users/feilong/workspace/github/FPF_Go/main.go:12 +0x30
    main.main()
            /Users/feilong/workspace/github/FPF_Go/main.go:8 +0x24
    exit status 2
    ```

4. boolean、uint8类型，会合并参数，一个字可以表示四个boolean。在64位机器上，一个字可以表示8个布尔类型。

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

5. 接口类型参数，第一个表示类型，第二个表示指针地址。

    ```go
    // testParam(errors.New("s"))
    func testParam(data error) {
      panic("")
    }
    
    //输出
    main.testParam({0x104f718c8, 0x14000110000})
        /Users/feilong/workspace/github/FPF_Go/main.go:14 +0x34
    main.main()
            /Users/feilong/workspace/github/FPF_Go/main.go:10 +0x34
    ```

8. 指针作为方法的接收器，会第一个打印接收器的地址。

    ```go
    //data := &Data{}
    //data.testParam()
    type Data struct{ value string }
    
    func (d *Data) testParam() {
      panic("")
    }
    
    //输出
    main.(*Data).testParam(0x14000098f58)
            /Users/feilong/workspace/github/FPF_Go/main.go:8 +0x30
    main.main()
            /Users/feilong/workspace/github/FPF_Go/main.go:13 +0x24
    
    
    ```

9. 结构体作为方法的接收器，会第打印结构体的属性信息。

    ```go
    type Data struct {
      value  string
      value1 string
    }
    
    func (d Data) testParam() {
      panic("")
    }
    
    func main() {
      data := Data{value: "1", value1: "11"}
      data.testParam()
    }
    
    //输出
    main.Data.testParam({{0x104ef4c88, 0x1}, {0x104ef4ca6, 0x2}})
            /Users/feilong/workspace/github/FPF_Go/main.go:9 +0x3c
    main.main()
            /Users/feilong/workspace/github/FPF_Go/main.go:14 +0x4c
    
    ## demo2----------------------
    type Data int
    
    func (d Data) testParam() {
    	panic("")
    }
    
    func main() {
    	data := Data(11)
    	data.testParam()
    }
    //输出
    main.Data.testParam(0xb)
            /Users/feilong/workspace/github/FPF_Go/main.go:6 +0x30
    main.main()
            /Users/feilong/workspace/github/FPF_Go/main.go:11 +0x24
    ```

10. 方法没有接收器，不会打印多余信息。

    ```go
    func testParam() {
      panic("")
    }
    
    func main() {
      testParam()
    }
    
    // 输出
    main.testParam()
            /Users/feilong/workspace/github/FPF_Go/main.go:6 +0x2c
    main.main()
            /Users/feilong/workspace/github/FPF_Go/main.go:10 +0x1c
    ```