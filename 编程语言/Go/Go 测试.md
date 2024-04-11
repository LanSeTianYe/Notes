时间： 2020-03-25 15:49:49

参考：

1. [gomock](https://pkg.go.dev/github.com/golang/mock/gomock#pkg-variables)
2. [benchmark 基准测试](https://geektutu.com/post/hpg-benchmark.html)
3. [benchstat 对比测试结果](https://pkg.go.dev/golang.org/x/perf/cmd/benchstat)
3. [go benchstat 工具](https://chenlujjj.github.io/go/benchstat/)

## Go 测试

在 `go` 语言中，以 `_test.go` 结尾的文件是测试文件。执行 `go test` 命令的时候会运行对应的测试函数。

测试函数分为三种类型Test测试（函数名以 `Test` 开头），Benchmark测试（函数名以 `Benchmark` 开头）以及Example测试（函数名以 `Example` 开头）。

### Test

验证函数的正确性。

### Benchmark

性能测试，测试代码性能。

基准命令：`go test -bench=.`

|参数|描述|值|
|::|::|::|
|-bench|基准测试的目录，后面可以跟正则表达式|-bench=.|
|-v|显示详细信息||
|-benchmem|显示内存申请情况||
|-cpu|指定使用CPU数量，会测试指定CPU核数下的性能|-cpu=1,2,5|
|-benchtime=1000000000x|指定执行次数(100x)、时间(10s)等。|-benchtime=1000x|
|-count|执行轮数|-count=2|

常用命令：

```go
go test -v -bench=.
go test -v -benchmem -benchtime=1000000000x -bench=.
go test -v -benchmem -benchtime=1000s -bench=.
go test -v -benchmem -benchtime=1000000000x -cpu=1,2,3
go test -v -benchmem -benchtime=1000000000x -count=2

# 默认会执行单元测试，加上 -run="^$"，可以排除单元测试
go test -run="^S" -bench='Benchmark(Empty|Map|SyncMap)' -benchmem -benchtime=10s
```

常用方法：

* ResetTimer：重新开始计时。
* StopTimer：暂停计时和StartTimer结合使用。
* StartTimer ：开始计时。


下面是测试 `map` 和 `sync.Map` 的例子：

```go
const MapSize = 100

func BenchmarkEmpty(b *testing.B) {
	for i := 0; i < b.N; i++ {
	}
}

func BenchmarkMap(b *testing.B) {
	data := generateMap(MapSize)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_ = data["key1"]
	}
}

func BenchmarkSyncMap(b *testing.B) {
	data := generateSyncMap(MapSize)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		data.Load("key1")
	}
}

func generateMap(size int) map[string]string {
	result := make(map[string]string, 0)
	for i := 0; i < size; i++ {
		result["key"+strconv.Itoa(i)] = strconv.Itoa(i)
	}
	return result
}

func generateSyncMap(size int) *sync.Map {
	result := &sync.Map{}
	for i := 0; i < size; i++ {
		key := "key" + strconv.Itoa(i)
		result.Store(key, strconv.Itoa(i))
	}
	return result
}
```

执行结果：

```shell
➜  benchmark git:(master) go test -v -benchmem -benchtime=1000000000x -bench=.
goos: darwin
goarch: arm64
pkg: github.com/xiaotian/demo/benchmark
BenchmarkEmpty-8        1000000000               0.3326 ns/op          0 B/op          0 allocs/op
BenchmarkMap-8          1000000000               7.297 ns/op           0 B/op          0 allocs/op
BenchmarkSyncMap-8      1000000000              15.03 ns/op            0 B/op          0 allocs/op
```

### Benchstat

计算和比较 `benchmark` 的统计结果。

安装：

```shell
go get -u golang.org/x/perf/cmd/benchstat
go install golang.org/x/perf/cmd/benchstat
```

示例：

```shell
➜  performance git:(master) ✗ go test -v -benchtime=1000x  -bench=. > old.txt 
➜  performance git:(master) ✗ go test -v -benchtime=1000x  -bench=. > new.txt

➜  performance git:(master) ✗ benchstat old.txt new.txt                      
goos: darwin
goarch: arm64
                              │    old.txt    │               new.txt                │
                              │    sec/op     │    sec/op     vs base                │
ArrayAppendNoInitSize-8          38.14µ ± ∞ ¹   47.83µ ± ∞ ¹       ~ (p=1.000 n=1) ²
ArrayAppendWithInitSize-8        32.45µ ± ∞ ¹   32.63µ ± ∞ ¹       ~ (p=1.000 n=1) ²
ArrayAssignmentWithInitSize-8    6.798µ ± ∞ ¹   6.680µ ± ∞ ¹       ~ (p=1.000 n=1) ²
ArrayTraversal-8                 4.750n ± ∞ ¹   4.959n ± ∞ ¹       ~ (p=1.000 n=1) ²
MapTraversal-8                  100.80n ± ∞ ¹   92.25n ± ∞ ¹       ~ (p=1.000 n=1) ²
geomean                          1.321µ         1.367µ        +3.43%
¹ need >= 6 samples for confidence interval at level 0.95
² need >= 4 samples to detect a difference at alpha level 0.05
```

### Example测试

对比实际输出内容和想要的输出内容 `// Output:` 之后的输出。

```go
func ExampleOutput() {
    fmt.Println("123")
    fmt.Println("456")
    // Output:
    // 123
    // 456
}
```

## testify 框架

### assert

断言，返回bool值表示断言是否成功，断言失败，继续执行后续步骤。

```go
assert.Equal(t, a, b, "a should equal b. a [%d], b [%d]", a, b)
```

### require 

require 判断失败不继续执行后面代码。

```go
require.Equal(t, a, b, "a should equal b. a [%d], b [%d]", a, b)
```

### mock 用法

模拟方法调用，只是实现需要用到的方法减少，生成方法的数量。

```go
package simple

import (
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"testing"
)

type Hello interface {
	Hello(name string) string
}

type Person struct {
	mock.Mock
	Name string
	Age  int
	Addr Address
}

type Address struct {
	province string
	city     string
}

func (person *Person) Hello(name string) string {
	arguments := person.Called(name)
	return arguments.String(0)
}

func (person *Person) Address() Address {
	arguments := person.Called()
	return arguments.Get(0).(Address)
}

func TestHello(t *testing.T) {
	p := new(Person)
	name := "张三"
	address := Address{
		province: "北京市",
		city:     "北京",
	}

	p.On("Hello", name).Return("Hello " + name)
	p.On("Address").Return(address)

	hello := p.Hello(name)
	assert.Equal(t, hello, "Hello "+name)
	assert.Equal(t, "北京市", p.Address().province)
	assert.Equal(t, "北京", p.Address().city)
}
```

## gomock

```shell
go get github.com/golang/mock/mockgen
go install github.com/golang/mock/mockgen
```

### mock 步骤

1. 定义接口。

    ```
    type Person interface {
        SetName(name string) string
    }
    ```

1.  生成 mock代码，进入接口目录。

    ```shell
    mockgen -destination ./person_mock.go -package mock -source person.go
    //go:generate mockgen -destination ./person_mock.go -package mock -source person.go
    ```

2. 使用例子。

    ```go
    func TestMock(t *testing.T) {
        //mock controller
        mockController := gomock.NewController(t)
        defer mockController.Finish()
    
        //mock person
        mockPerson := NewMockPerson(mockController)
    
        //当参数是 "name" 时执行函数(注意后面函数的参数个数需要和SetName参数个数一样)
        mockPerson.EXPECT().SetName("name1").AnyTimes().Do(func(name string) {
            fmt.Println("name1")
        })
    
        //当参数是 "name1" 时,执行函数并返回,(注意后面函数的参数个数需要和SetName参数个数一样)
        mockPerson.EXPECT().SetName("name2").AnyTimes().DoAndReturn(func(name string) string {
            fmt.Println(name)
            return "name2"
        })
    
        //当参数是 "name1" 时,执行函数并返回,(注意后面函数的参数个数需要和SetName参数个数一样)
        //gomock.Any() 指定参数匹配条件
        //AnyTimes 指定可以执行任意次
        mockPerson.EXPECT().SetName(gomock.Any()).AnyTimes().Do(func(name string) {
            fmt.Println("any", name)
        })
    
        mockPerson.SetName("name3")
        mockPerson.SetName("name1")
        mockPerson.SetName("name1")
        mockPerson.SetName("name2")
        mockPerson.SetName("name3")
        //output
        //any name3
        //name1
        //name1
        //name2
        //any name3
    }
    ```
