时间：2021-08-25 10:35:35

参考：

1. [理解 Go interface 的 5 个关键点](https://sanyuesha.com/2017/07/22/how-to-understand-go-interface/)
2. [接口值](https://books.studygolang.com/gopl-zh/ch7/ch7-05.html)

## Go interface

在Go语言中，变量总是被一个定义明确的值初始化。

```go
var a int

#内存中的结构如下：
type:int
value:0
```

`interface`  在Go语言中可以有如下的使用方式：

### 声明接口：

```go
// 可以从里面读数据
type Reader interface {
	Read(p []byte) (n int, err error)
}
// 可以往里面写数据
type Writer interface {
	Write(p []byte) (n int, err error)
}
```

### 表示任意类型

在使用 `interface` 表示任意类型的时候，有一个问题，怎么把一个指针类型转换成对应的值。

```go
func main() {
	intValue := 1
	strValue := "hello"

	hello(intValue)
	hello(strValue)

	hello(&intValue)
	hello(&strValue)
}

func hello(info interface{}) {
	fmt.Printf("%v\n", info)
}

//输出内容
1
hello
0xc00000a0a0
0xc00003a1f0
```

### 指针类型转换成对应的值类型

```go
// 把string类型的指针转换为对应的stirng类型
s := *(info.(*string))
```

### 理解 `interface{}` 和 `*interface{}`

`interface{}` 表示任意类型的值。
`*interface{}` 表示一个 `interface` 类型的指针，里面存储的是值是 `interface` 类型的，即里面存储的值可以是任意类型，赋值的时候需要使用 `*pointer=xxx`

```go
var message = "hello"

var interfaceValue interface{}
fmt.Println("0: " + pretty.Sprint(interfaceValue))
interfaceValue = message
fmt.Println("1: " + reflect.TypeOf(interfaceValue).String())
fmt.Println("1: " + pretty.Sprint(interfaceValue))
interfaceValue = &message
fmt.Println("2: " + reflect.TypeOf(interfaceValue).String())
fmt.Println("2: " + pretty.Sprint(interfaceValue))

var temp interface{}
var interfacePointer = &temp
fmt.Println("3: " + reflect.TypeOf(interfacePointer).String())
fmt.Println("3: " + pretty.Sprint(interfacePointer))
*interfacePointer = message
fmt.Println("4: " + reflect.TypeOf(interfacePointer).String())
fmt.Println("4: " + pretty.Sprint(interfacePointer))
*interfacePointer = &message
fmt.Println("5: " + reflect.TypeOf(interfacePointer).String())
fmt.Println("5: " + pretty.Sprint(interfacePointer))

//输出结果如下
0: nil
1: string
1: hello
2: *string
2: &"hello"
3: *interface {}
3: &nil
4: *interface {}
4: &"hello"
5: *interface {}
5: &&"hello"
```






