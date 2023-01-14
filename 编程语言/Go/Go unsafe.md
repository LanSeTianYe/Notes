时间：2021-07-22 10:59:59

参考：

## Go unsafe


```go
// uintptr is an integer type that is large enough to hold the bit pattern of
// any pointer.
type uintptr uintptr
```

```go
type A struct {	Name string}

func (a *A) Method1() {	fmt.Println("a method 1")}

type B struct {	Name string	Age  int}

func (b *B) Method1() {	fmt.Println("b method 1")}

func (b *B) Method2() {	fmt.Println("b method 2")}

func main() {
	a := &A{}
	a.Method1()
  
	b := (*B)(unsafe.Pointer(a))
	b.Method1()
	b.Method2()

	a = (*A)(unsafe.Pointer(b))
	a.Method1()
}

# 输出
a method 1
b method 1
b method 2
a method 1
```
