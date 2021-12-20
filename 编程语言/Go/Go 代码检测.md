时间：2021-11-25 15:17:17

参考：

1. [https://github.com/golang/lint](https://github.com/golang/lint)
2. [staticcheck](https://staticcheck.io/docs/)
3. [如果你用Go，不要忘了vet](https://studygolang.com/articles/9619)

## GO 代码检测

### GOLINT

检查代码命名规范，行长度，代码长度等问题。

仓库已经不维护，可以使用。

```
# 安装
go get -u golang.org/x/lint/golint
#使用
golint ./...
```

### go vet

检查代码中可能存在的Bug和性能问题。

* Print-format 错误
* Boolean 错误
* Range 循环
* Unreachable的代码
* 混杂的错误
* 误报和漏报

```
go vet ./...
```

### staticcheck

检查代码中可能存在的Bug和性能问题。

提供 [150+](https://staticcheck.io/docs/checks/) 检查选项。支持多种 [输出格式](https://staticcheck.io/docs/running-staticcheck/cli/formatters/)。

```shell
Usage: staticcheck [flags] [packages]

Flags:
  -checks checks
        Comma-separated list of checks to enable. (default "inherit")
  -explain check
        Print description of check
  -f format
        Output format (valid choices are 'stylish', 'text' and 'json') (default text)
  -fail checks
        Comma-separated list of checks that can cause a non-zero exit status. (default "all")
  -go version
        Target Go version in the format '1.x', or the literal 'module' to use the module's Go version (default "module")
  -list-checks
        List all available checks
  -show-ignored
        Don't filter ignored problems
  -tags build tags
        List of build tags
  -tests
        Include tests (default true)
  -version
        Print version and exit
```

**输出格式：**

* Text: 文本格式输出

    ```shell 
    go/src/fmt/print.go:1069:15: this value of afterIndex is never used (SA4006)
    ```

* Stylish：根据文件分组输出信息。

    ```shell
    go/src/fmt/fmt_test.go
    (43, 2)     S1021   should merge variable declaration with assignment on next line
    (1185, 10)  SA9003  empty branch

    go/src/fmt/print.go
    (77, 18)    ST1006  methods on the same type should have the same receiver name (seen 3x "b", 1x "bp")
    (1069, 15)  SA4006  this value of afterIndex is never used

    go/src/fmt/scan.go
    (465, 5)  ST1012  error var complexError should have name of the form errFoo
    (466, 5)  ST1012  error var boolError should have name of the form errFoo

    ✖ 6 problems (6 errors, 0 warnings)
    ```

* JSON：JSON格式输出

    ```json
    {
      "code": "SA4006",
      "severity": "error",
      "location": {
        "file": "/usr/lib/go/src/fmt/print.go",
        "line": 1082,
        "column": 15
      },
      "end": {
        "file": "/usr/lib/go/src/fmt/print.go",
        "line": 1082,
        "column": 25
      },
      "message": "this value of afterIndex is never used"
    }
    ```

**配置选项:**

配置信息写在当前目录的 `staticcheck.conf` 文件中。子目录会继承父目录的配置选项。子目录的相同配置会覆盖继承的配置。

```shell
# 检查哪些选项 `-` 排除
checks = ["all", "-ST1000", "-ST1003", "-ST1016", "-ST1020", "-ST1021", "-ST1022", "-ST1023"]
# 首字母缩写词，这些词需要全部大写（ST1003负责执行这些检测）
initialisms = ["ACL", "API", "ASCII", "CPU", "CSS", "DNS", "EOF", "GUID", "HTML", "HTTP", "HTTPS", "ID", "IP", "JSON", "QPS", "RAM", "RPC", "SLA", "SMTP", "SQL", "SSH", "TCP", "TLS", "TTL", "UDP", "UI", "GID", "UID", "UUID", "URI", "URL", "UTF8", "VM", "XML", "XMPP", "XSRF", "XSS", "SIP", "RTP", "AMQP", "DB", "TS"]
# 可以 . 导入再任何地方 （ST1001 检测.导入）
dot_import_whitelist = ["github.com/mmcloughlin/avo/build", "github.com/mmcloughlin/avo/operand", "github.com/mmcloughlin/avo/reg"]
# 排除检测哪些常量（ST1013 检测没有使用常量的地方）
http_status_code_whitelist = ["200", "400", "404", "500"]
```

**不检查行或者文件：**

忽略单行用法：在行上面加注释 `//lint:ignore Check1[,Check2,...,CheckN] reason`

```go
func TestNewEqual(t *testing.T) {
  //lint:ignore SA4000 we want to make sure that no two results of errors.New are ever the same
  if errors.New("abc") == errors.New("abc") {
    t.Errorf(`New("abc") == New("abc")`)
  }
}
```

忽略整个文件用法：在文件开头加注释 `//lint:file-ignore U1000 Ignore all unused code, it's generated`

**使用手册：**

```shell
# 检测当前包
staticcheck .
# 检测当前包，指定go版本
staticcheck -go 1.16 .
# 检测当前包，排除测试代码
staticcheck -tests=false .
# 检测当前包，指定输出格式 [text jsonsty lish]
staticcheck -f json .
# 检测当前包
staticcheck ./...

# 查看检测规则的说明
staticcheck -explain SA5009

··· 输出内容如下
    Invalid Printf call

    Available since
        2019.2

    Online documentation
        https://staticcheck.io/docs/checks#SA5009
···
```



