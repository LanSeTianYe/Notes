时间：2022-11-25 14:36:36

参考：

1. [Slice](https://books.studygolang.com/gopl-zh/ch4/ch4-02.html)

## Go 疑惑 🤔

### Slice

`Slice` 的切片产生的 `子Slice` 和 `原Slice` 共同引用一个底层数组，所以对 `原Slice` 和 `子Slice` 的操作会互相影响 。

```go
months[4] = "4" => 会影响 summer[0]的值
summer = append(summer, "9") => 会影响 months[9] 的值
```

如果触发扩容操作，则 `两个Slice` 会指向不同的底层数组。

![](../../img/go/slice.png)

### 值类型和指针类型

Go在传递参数的时候，会进行复制。如果是值类型则会复制一份，如果是指针则只会复制指针的地址。因此类型占用内存空间比较大或者想要在函数内部改变参数的值情况下可以传递指针，其余情况可以传递值。

 类型的函数，等价于第一个参数是对应的接收器的方法。

```go
type EmptyType struct{}
func (p EmptyType) Value() {}
func (p *EmptyType) Point() {}

var fnValue func(person EmptyType)
fnValue = EmptyType.Value

var fnPoint func(person *EmptyType)
fnValue = EmptyType.Point
```



### 结构体组合

结构体组合等价于在组合的结构体里面定义了一个被组合结构体的变量。不同之处在于如果没有指定名字，可以直接在组合结构体上调用对应的方法。

**并不是面向对象里面的继承的概念，不适用里氏替换原则。**

如代码所示：`B1等价于B2`。

```go
type A struct{}

func (a A) Hello() {}

type B1 struct {
	A
	Name string
}

type B2 struct {
	A    A
	Name string
}

func main() {
	b1 := new(B1)
	b1.Hello()
	b1.A.Hello()

	b2 := new(B2)
	b2.A.Hello()
}
```

