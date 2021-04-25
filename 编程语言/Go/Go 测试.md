时间： 2020-03-25 15:49:49

参考：

1. [gomock](https://pkg.go.dev/github.com/golang/mock/gomock#pkg-variables)

## Go 测试

在 `go` 语言中，以 `_test.go` 结尾的文件是测试文件。执行 `go test` 命令的时候会运行对应的测试函数。

测试函数分为三种类型Test测试（函数名以 `Test` 开头），Benchmark测试（函数名以 `Benchmark` 开头）以及Example测试（函数名以 `Example` 开头）。

### Test测试

验证函数的正确性。

### Benchmark测试

测试函数的性能。

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
go get github.com/golang/mock/mockgen@v1.5.0
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
