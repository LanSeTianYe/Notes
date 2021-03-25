时间： 2020-03-25 15:49:49

参考：

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